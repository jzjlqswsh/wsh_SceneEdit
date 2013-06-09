package wshExpand.control 
{
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.events.MouseEvent3D;
	import away3d.materials.TextureMaterial;
	import away3d.utils.Cast;
	import wshExpand.data.AttackDatas;
	import wshExpand.sys.SceneManage;
	
	import com.Astart.AcorrsLineGrid;
	import com.Astart.Astart;
	import com.Astart.Grid;
	import com.Astart.Node;
	
	import wshExpand.data.RoleProData;
	import wshExpand.display.ExpandMesh;
	import wshExpand.fight.FightDataManage;
	import wshExpand.skeletonExpand.ExpandMeshEvent;
	import wshExpand.utils.Equation;
	import wshExpand.utils.Functions;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	/**
	 * ...战斗角色 数据
	 * @author wangshuaihua
	 */
	public class FightRoleDummy extends Abstract_move
	{
		
		public static var frameTime:int = 0;	//当前帧编号
		
		private var _nextRunFrame:int = 0;		//下次帧编号		g
		
		private var _stepArr:Array = [];		//执行 步骤数组
		public function get stepArr():Array
		{
			return _stepArr;
		}

		private function setNowStep(arr:Array):void
		{
			if (_stepArr.length > 0) {
				if (_stepArr[_stepArr.length - 2]) {
					if (_stepArr[_stepArr.length - 2][0] == arr[0]) {
						_stepArr.splice(_stepArr.length - 2, 1);
					}
				}
				_stepArr[_stepArr.length - 1] = arr;
				_nextRunFrame = arr[0] + arr[1];		//下次执行帧编号
			}else {
				_nextRunFrame = arr[0] + arr[1];		//下次执行帧编号
				addStep(arr);
			}
		}
		private function addStep(arr:Array):void
		{
			_stepArr.push(arr);
		}
		private function setAddStep(arr:Array):void
		{
			_stepArr[_stepArr.length - 1] = arr;
		}
		
		
		private var _beginChangeFrame:int;
		private var _changeFrame:int;
		
		public function setMyNode(value:Node):void 
		{
			_myNode = value;
		}
		
		public function changeMyNode(posx:Number,posy:Number):void
		{
			var node:Node = Astart.myGrid.getNodeByXY(posx, posy);
			setMyNode(node);
		}
		
		//==============CD
		private var _cdAttackFrame:int = 0;		//使用攻击的 时间点
		private var _adjustFindFrame:int = 0;	//调整寻路的时间点
		private var _adjustFindTime:int = 5;//0.1 * Game_3d_D.FRAME_RATE;
		
		//下次开始攻击的帧数
		private var _nextAttackFrame:int;
		
		//==========数据
		private var _myProData:RoleProData;
		
		//序号  在刷新数组里的序号
		private var _myIndex:int;
		
		private var _camp:int = 1;			// 阵营 gs 
		
		private var _zhenIndex:int = 0;		//布阵序号 第几对			gs
		
		private var _zhenDir:int = 1;		//方位 1向右  -1向左		gs
		
		public static const ACTIONSTATE_NORMAL:String = "normal";	//普通
		public static const ACTIONSTATE_ATTACK:String = "attack";	//攻击
		public static const ACTIONSTATE_BEHIT:String = "behit";	//挨打
		public static const ACTIONSTATE_DAODI:String = "daodi";	//倒地
		public static const ACTIONSTATE_DIED:String = "died";		//死亡
		private var _actionState:String = ACTIONSTATE_NORMAL;//动作状态
		public function setActionState(action:String):void
		{
			_actionState = action;
		}
		
		
		//命令状态  0待命 1冲锋 2寻对手  3移动 4战斗 
		public static const COMMANDSTATE_AWAIT:int = 0;
		public static const COMMANDSTATE_CHONGFENG:int = 1;
		public static const COMMANDSTATE_FIND:int = 2;
		public static const COMMANDSTATE_MOVE:int = 3;
		public static const COMMANDSTATE_FIGHT:int = 4;
		public static const COMMANDSTATE_NOTARGER:int = 5;
		
		private var _commandState:int = COMMANDSTATE_AWAIT;	
		public function setCommandState(value:int,obj:* = null):void 
		{
			_commandState = value;
		}
		
		//动作名字
		private var _currentLable:String;	
		//当前帧
		private var _currentFrame:int;
		//动作是否完成
		private var _actionFinished:Boolean = false;
		
		
		//目标 攻击对象
		private var _myTarget:FightRoleDummy;
		
		
		private var _dieded:Boolean = false;
		
		public function FightRoleDummy() 
		{
			super();
			_updataByTime = false;
			SceneManage.getInstance().deleteFromObjectArr(this);
		}
		
		//设置数据
		override public function setM(data:*):void
		{
			//_myName = "player_1";
			_myProData = data as RoleProData;
			saveProData = getSaveProData(_myProData);
			_nextAttackFrame = frameTime + int(_myProData.myCd*Game_3d_D.FRAME_RATE);
		}
		
		override public function initShow(ctn:*,posx:Number = 0, posy:Number = 0, posz:Number = 0):void 
		{
			_myX = posx;
			_myY = posy;
			_myZ = posz;
			initPosArr = [posx, posy, posz];
			initStand();
		}
		
		
		
		
		
		
		
		//================================================寻找目标 相关=======================================
		//寻路过程中再次寻找目标
		private function adjustTarger():void
		{
			if (_adjustFindTime == 0) {
				setCommandState(COMMANDSTATE_FIND);
				_adjustFindTime = _adjustFindTime;
			}
		}
		
		
		//判断一个对象是否在攻击范围内
		private function checkInAttackDis(who:FightRoleDummy):Boolean
		{
			if(who.died){
				return false;
			}
			var dis:int = Math.abs(who.myNode.x - _myNode.x) + Math.abs(who.myNode.y - _myNode.y);
			return _myProData.attackDis >= dis;
		}
		
		
		
		//寻找下一个目标
		private function findNextTarget():FightRoleDummy
		{
			//=======得到敌人数组
			var roleArr:Vector.<FightRoleDummy>;
			roleArr = FightDataManage.getInstance().getEnemyArr(_zhenIndex);
			
			
			//-----找距离小的
			var minDis:int = 1000;
			var dis:int;
			var tagetRole:FightRoleDummy;	//目标对象
			for (var i:int = 0; i < roleArr.length; i++ ) {
				dis = Math.abs(roleArr[i].myNode.x - _myNode.x) + Math.abs(roleArr[i].myNode.y - _myNode.y);
				if (dis < minDis) {
					minDis = dis;
					tagetRole = roleArr[i];
				}
			}
			return tagetRole;
		}
		
		//寻找能攻击到目标的格子
		private function findCanAttackNode(tagetNode:Node,attackDis:int):Node
		{
			var nodesArr:Array = getNodesByDis(tagetNode, attackDis);
			//-------找最近的
			var minDis:int = 1000;
			var dis:int;
			var endNode:Node;
			for (var i:int = 0; i < nodesArr.length; i++ ) {
				if ( checkNodeFree(nodesArr[i])) {
					continue;
				}
				dis = Math.abs(nodesArr[i].x - _myNode.x) + Math.abs(nodesArr[i].y - _myNode.y);
				if (dis < minDis) {
					minDis = dis;
					endNode = nodesArr[i];
				}
			}
			setNodeFull(endNode);
			return endNode;
		}
		
		
		//得到最近的格子
		private function findNearNode(tagetNode:Node,attackDis:int):Node
		{
			var nodesArr:Array = getNodesByDis(tagetNode, attackDis);
			//-------找最近的
			var minDis:int = 1000;
			var dis:int;
			var endNode:Node;
			for (var i:int = 0; i < nodesArr.length; i++ ) {
				if ( checkNodeFree(nodesArr[i])) {
					continue;
				}
				dis = Math.abs(nodesArr[i].x - _myNode.x) + Math.abs(nodesArr[i].y - _myNode.y);
				if (dis < minDis) {
					minDis = dis;
					endNode = nodesArr[i];
				}
			}
			if (endNode) {
				return endNode;
			}else {
				return findNearNode(tagetNode, attackDis + 1);
			}
			
		}
		
		
		private var _myTargerNode:Node;
		//判断目标点是否有人抢先
		private function checkNodeFree(node:Node):Boolean
		{
			if (!node.biaojiArr) {
				return false;
			}
			if (node.biaojiArr.length == 1) {
				if (node.biaojiArr[0] == this) {
					return false;
				}
			}
			if (node.biaojiArr.length != 0) {
				return true;
			}
			return false;
		}
		//设置格子被占
		private function setNodeFull(node:Node):void
		{
			
			if (!node) {
				setNodeFull(myNode)
				return;
			}
			deleteNodeFree();
			if (!node.biaojiArr) {
				node.biaojiArr = [];
			}
			node.biaojiArr.push(this);
			_myTargerNode = node;
		}
		// 删除格子被占信息
		private function deleteNodeFree():void
		{
			if(!_myTargerNode){
				return;
			}
			if (_myTargerNode.biaojiArr) {
				if (_myTargerNode.biaojiArr.indexOf(this) != -1) {
					_myTargerNode.biaojiArr.splice(_myTargerNode.biaojiArr.indexOf(this), 1);
				}
			}
			_myTargerNode = null;
		}
		
		//根据攻击距离得到周围的格子
		public static function getNodesByDis(node:Node,dis:int = 1):Array
		{
			var attackDis:int = dis;
			//获取敌人目标
			var minHang:int = node.x - attackDis;
			var maxHang:int = node.x + attackDis;
			if (minHang < 0) {
				minHang = 0;
			}
			if (maxHang >= Astart.myGrid.row ) {
				maxHang = Astart.myGrid.row - 1;
			}
			var minLie:int = node.y - attackDis;
			var maxLie:int = node.y + attackDis;
			if (minLie < 0) {
				minLie = 0;
			}
			if (maxLie >= Astart.myGrid.col ) {
				maxLie = Astart.myGrid.col - 1;
			}
			var nodesArr:Array = [];
			var tempNode:Node;
			var i:int;
			var j:int;
			for ( i = minLie; i <= maxLie; i++ ) {
				for ( j = minHang; j <= maxHang; j++ ) {
					if ( Math.abs(j - node.x) + Math.abs(i - node.y) <= attackDis) {
						if (i != node.y || j != node.x) {
							tempNode = Astart.myGrid.nodes[i][j];
							nodesArr.push(tempNode);
						}
					}
				}
			}
			return nodesArr;
		}
		
		
		
		
		
		//====获取目前位置能攻击的目标
		private function getTarget():FightRoleDummy
		{
			var i:int;
			var nodesArr:Array = getNodesByDis(_myNode, _myProData.attackDis);
			//=======得到敌人数组
			var roleArr:Vector.<FightRoleDummy>;
			roleArr = FightDataManage.getInstance().getEnemyArr(_zhenIndex);
			//getRoleArrByType
			var tempArr:Array = [];
			var sortInfo:Object = new Object();
			var sortDic:Dictionary = new Dictionary();
			for (i = 0; i < roleArr.length; i++ ) {
				if (roleArr[i].died == false&&roleArr[i].dieded == false&& nodesArr.indexOf(roleArr[i].myNode) != -1) {
					sortInfo = new Object();
					tempArr.push(sortInfo);
					sortDic[sortInfo] = roleArr[i];
					//距离
					sortInfo.dis = Math.abs(roleArr[i].myNode.x - _myNode.x) + Math.abs(roleArr[i].myNode.y - _myNode.y);
					sortInfo.x = roleArr[i].myNode.x;
					sortInfo.y = roleArr[i].myNode.y;
				}
			}
			if (tempArr.length > 0) {
				//排序
				tempArr.sortOn(["dis", "y", "x"], [Array.NUMERIC, Array.NUMERIC, Array.NUMERIC]);
				return sortDic[tempArr[0]];
			}
			return null;
		}
		
		private var _nextAttackTarget:FightRoleDummy;
		//寻找下一个攻击目标 并 的 位置
		private function getCanAttackTarget():void
		{
			//deleteNodeFree();
			//=======得到敌人
			_nextAttackTarget = findNextTarget();
			if (!_nextAttackTarget) {
				stopAction();
				return;
			}
			//=====能攻击到敌人的点
			var endNode:Node = findCanAttackNode(_nextAttackTarget.myNode, _myProData.attackDis);
			if (endNode) {
				//寻找最近的目标
				searchRode(endNode);
			}else {
				//setCommandState(COMMANDSTATE_NOTARGER);
				stopAction();
				
			}
		}
		
		
		//========================================战斗AI===================================================
		private function fightAi():void 
		{
			//初始化状态
			initMyState();
			
			if (_commandState == COMMANDSTATE_FIND) {
				//=========如果目标还在攻击范围内 继续攻击该目标
				/*if (_myTarget && checkInAttackDis(_myTarget)&&!checkNodeFree(myNode)) {
					setCommandState(COMMANDSTATE_FIGHT);
				}else {*/
					_myTarget = getTarget();
					if (_myTarget&&!checkNodeFree(myNode)) {
						setCommandState(COMMANDSTATE_FIGHT);
					}else {
						// 寻找能达到的最近的点
						getCanAttackTarget();
						return;
					}
				//}
			}
			if (_commandState == COMMANDSTATE_FIGHT) {
				attack();
			}
		}
		
		//======================================================================================
		
		private var _attackSkill:String;		//攻击技能
		private var _attackData:Object;			//攻击数据
		private function checkWhickSkill():void
		{
			_attackSkill = "attack";
			_attackData = AttackDatas.copyDatas(_myName,_attackSkill)
		}
		
		//====攻击
		private function attack():void
		{
			if (_dieded) {
				return;
			}
			//判断用何种攻击  技能
			checkWhickSkill();
			
			setCommandState(COMMANDSTATE_FIND);
			
			setNodeFull(myNode);
			//开始攻击
			_cdAttackFrame = frameTime;
			beginAttack();
			
			if(_died){
				return;
			}
			if(_myTarget.died){
				_myTarget = null;
				setCommandState(COMMANDSTATE_FIND);
				return;
			}
		}
		
		
		
		//开始攻击
		private function beginAttack():void
		{
			if (_dieded) {
				return;
			}
			_nextAttackFrame = frameTime + int(_myProData.myCd*Game_3d_D.FRAME_RATE);
			var attackTestFrame:int = _attackData.攻击延迟 -1;
			
			setActionState(FightRoleDummy.ACTIONSTATE_ATTACK);
			var arr:Array = [frameTime,attackTestFrame,[0,0,"beginAttack",[_myTarget.myIndex]]];
			setNowStep(arr);
			addStep(["attackTest"]);
		}
		
		
		//攻击检测
		private function attackTest():void
		{
			if (_dieded) {
				return;
			}
			var hurt:int;
			_nextRunFrame = _nextAttackFrame;
			//攻击
			//目标受伤
			if (_myTarget&&_myTarget.died == false) {
				var index:int = _myTarget.myIndex;
				_myTarget.behit(this);
				var arr:Array = [frameTime,_nextAttackFrame-frameTime,[0,0,"attackTest",[index]]];
				setNowStep(arr);
			}else {
				setAddStep(["fightAi"]);
				return;
			}
			addStep(["fightAi"]);
		}
		
		
		//挨打函数  外部调用
		override public function behit(who:Abstract_basic):void
		{
			if (_dieded) {
				return;
			}
			var hurt:int = (who as FightRoleDummy).myProData.attackHurt;
			
			//在此帧有动作的 先执行一遍动作
			if (_nextRunFrame == frameTime) {
				checkRun();
			}
			var arr:Array;
			setNodeFull(myNode);
			_myProData.changeHealth( -hurt);
			if (_myProData.health <= 0) {
				arr = [frameTime+1, 0, [0, 0, "setEndLoopDied"]];
				setNowStep(arr);
				//死亡
				//deleteMe();
				_dieded = true;
			}else {
				arr = [frameTime+1, _myProData.yingzhi, [0, 0, "beHitAction",[(who as FightRoleDummy).myIndex,(who as FightRoleDummy).attackSkill,hurt]]];
				setNowStep(arr);
				addStep(["endAida"]);
				var nextFrame:int = _nextAttackFrame-frameTime-_myProData.yingzhi-1;
				if (nextFrame < 1) {
					nextFrame = 1;
				}
				arr = [frameTime+_myProData.yingzhi+1, nextFrame, [0, 0, "endAida"]];
				setNowStep(arr);
				addStep(["fightAi"]);
			}
		}
		
		
		//=====挨打结束
		private function endBehit():void
		{
			if(_died||_dieded){
				return;
			}
			fightAi();
		}
		
		//====================停止
		private function stopAction():void
		{
			if (_dieded) {
				return;
			}
			setNodeFull(myNode)
			initMyState();
			var arr:Array = [frameTime, _adjustFindTime,[0, 0,"stopAction"]];
			setNowStep(arr);
			addStep(["fightAi"]);
		}
		
		
		
		
		
		private var _walkArr:Array;
		private var _walkStep:int = 0;	//寻路步骤
		private var _walkPoint:Point;
		private var _nextPointAble:Boolean = false;
		
		//===================寻路
		public function searchRode(node:Node,fast:Boolean = true):void 
		{
			updataMyPose();
			if (fast) {
				_walkArr = [node];
				_walkStep = 0;
				_nextPointAble = true;
			}else {
				Astart.myGrid.startNode = _myNode;
				Astart.myGrid.endNode = node;
				var arr:Array = Astart.findPath(Astart.myGrid);
				if (arr) {
					_walkArr = Astart.myAcorrs.getPsnode(arr);
					_walkArr.shift();
					_walkStep = 0;
					_nextPointAble = true;
				}
			}
			if (_walkArr) {
				moveToNextNode();
			}
			//trace(_walkArr, "4444444444")
		}
		
		//===寻路结束函数
		private var searthRoadEnd:Array;
		//去下一个节点
		private function moveToNextNode():void
		{
			var arr:Array;
			if (_walkStep < _walkArr.length-1) {
				moveToNode(_walkArr[_walkStep]);
				arr = ["moveToNextNode"];
				addStep(arr);
			}else if (_walkStep == _walkArr.length-1) {
				//寻到目的点
				moveToNode(_walkArr[_walkStep]);
				arr = ["fightAi"]
				addStep(arr);
				return;
			}
			_walkStep++
		}
		
		//去一个节点
		private function moveToNode(node:Node):void
		{
			var walkPoint:Point = Astart.myGrid.getXYByNodeRandom(node);
			
			var ang:Number = Math.atan2(walkPoint.y - _myZ, walkPoint.x - _myX);
			var sX:Number = Equation.getNumByDecimal(Math.cos(ang) * _myProData.mySpeed, 4);
			var sZ:Number = Equation.getNumByDecimal(Math.sin(ang) * _myProData.mySpeed, 4);
			initWalk(sX, sZ);
			
			var lastFrame:int = Functions.checkDis(walkPoint.x,walkPoint.y, 0,_myX, _myZ, 0) / _myProData.mySpeed;
			
			if (lastFrame > _adjustFindTime) {
				lastFrame = _adjustFindTime;
			}
			var arr:Array = [frameTime, lastFrame, [_speedX, _speedZ]];
			_adjustFindFrame = frameTime;
			setNowStep(arr);
		}
		
		//更新位置的时间
		private var _updataPosFrame:int;
		//===更新位置
		private function updataMyPose():void
		{
			if (_updataPosFrame == frameTime) {
				return;
			}
			if (_stepArr.length >= 2) {
				var arr:Array = _stepArr[_stepArr.length - 2];
				var xSpeed:Number = arr[2][0];
				var zSpeed:Number = arr[2][1];
				_myX += xSpeed * (frameTime - _updataPosFrame);
				_myZ += zSpeed * (frameTime - _updataPosFrame);
				changeMyNode(_myX, _myZ);
			}
			_updataPosFrame = frameTime;
		}
		//===更新状态
		private function initMyState():void
		{
			if (_commandState == COMMANDSTATE_CHONGFENG) {
				setCommandState(COMMANDSTATE_FIND);
			}
			_walkArr = null;
			_walkStep = 0;
			initStand();
		}
		
		//执行步骤
		private function runStep():void
		{
			if (_stepArr.length <= 1) {
				return;
			}
			//更新位置
			updataMyPose();
			var arr:Array = _stepArr[_stepArr.length - 1];
			this[arr[0]]();
		}
		//检查是否执行
		public function checkRun():void
		{
			if (_dieded) {
				trace(_stepArr[_stepArr.length - 1],"555555555555555")
				deleteMe();
				return;
			}
			if (frameTime == _nextRunFrame) {
				runStep();
			}
		}
		
		
		
		
		
		
		//================================================外部调用==================================================
		
		
		
		
		//=======================数据
		private var initPosArr:Array;
		private var saveProData:Object = { };
		private function getSaveProData(data:RoleProData):Object
		{
			var obj:Object = new Object();
			//obj.mySpeed = data.mySpeed;		//速度
			obj.myName = _myName;
			obj.zhenDir = _zhenDir;			//阵位
			return obj;
		}
		
		private function getData():Object
		{
			var obj:Object = new Object();
			obj.stepArr = getStepArr();		//步骤
			obj.initPos = initPosArr;	//初始位置
			obj.proData = saveProData;	//速度 阵位等属性
			obj.myIndex = _myIndex;		//序号  在刷新数组里的序号 唯一标示 
			return obj;
		}
		public function getStepArr():Array 
		{
			//tempArr.sortOn(["dis", "y", "x"], [Array.NUMERIC, Array.NUMERIC, Array.NUMERIC]);
			_stepArr.sortOn(["0"], [Array.NUMERIC]);
			return _stepArr;
		}
		
		
		
		//=============================================================== d g s=============================================
		override public function deleteMe():void 
		{
			FightDataManage.getInstance().addFightDara(getData());
			
			FightDataManage.getInstance().deleteFromArr(this);
			_myTarget = null;
			_myProData = null;
			deleteNodeFree();
			_myNode = null;
			super.deleteMe();
		}
		
		
		
		public function set camp(value:int):void 
		{
			_camp = value;
		}
		
		public function get camp():int 
		{
			return _camp;
		}
		
		public function get myNode():Node 
		{
			updataMyPose();
			return _myNode;
		}
		
		public function get zhenIndex():int 
		{
			return _zhenIndex;
		}
		
		public function set zhenIndex(value:int):void 
		{
			_zhenIndex = value;
		}
		
		public function get myProData():RoleProData 
		{
			return _myProData;
		}
		
		public function get zhenDir():int 
		{
			return _zhenDir;
		}
		
		public function get myIndex():int 
		{
			return _myIndex;
		}
		
		public function set myIndex(value:int):void 
		{
			_myIndex = value;
		}
		
		public function get nextRunFrame():int 
		{
			return _nextRunFrame;
		}
		
		public function get attackSkill():String 
		{
			return _attackSkill;
		}
		
		public function get dieded():Boolean 
		{
			return _dieded;
		}
		
		
		
		
		public function setZhenDir(value:int):void 
		{
			_zhenDir = value;
		}
		
		
		
		
		
		
	}

}