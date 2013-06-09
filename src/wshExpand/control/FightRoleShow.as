package wshExpand.control 
{
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.events.MouseEvent3D;
	import away3d.materials.TextureMaterial;
	import away3d.tools.helpers.MeshHelper;
	import away3d.utils.Cast;
	import wshExpand.effect.Effect_sprite3D;
	import wshExpand.effect.Effect_bone;
	import wshExpand.fight.FightShowManage;
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import wshExpand.load.LoadXmlData;
	import wshExpand.sys.SceneManage;
	
	import com.Astart.AcorrsLineGrid;
	import com.Astart.Astart;
	import com.Astart.Grid;
	import com.Astart.Node;
	
	import wshExpand.data.RoleProData;
	import wshExpand.display.ExpandMesh;
	import wshExpand.skeletonExpand.ExpandMeshEvent;
	
	import flash.geom.Point;
	import flash.utils.setTimeout;

	/**
	 * ...战斗角色 显示
	 * @author wangshuaihua
	 */
	public class FightRoleShow extends Abstract_action
	{
		
		private var _camp:int = 1;			// 阵营 gs 
		
		private var _zhenIndex:int = 0;		//布阵序号 第几对			gs
		
		private var _zhenDir:int = 1;		//方位 1向右  -1向左		gs
		
		public static var ACTIONSTATE_NORMAL:String = "normal";	//普通
		public static var ACTIONSTATE_ATTACK:String = "attack";	//攻击
		public static var ACTIONSTATE_BEHIT:String = "behit";	//挨打
		public static var ACTIONSTATE_DAODI:String = "daodi";	//倒地
		public static var ACTIONSTATE_DIED:String = "died";		//死亡
		private var _actionState:String = ACTIONSTATE_NORMAL;//动作状态
		public function setActionState(action:String):void
		{
			_actionState = action;
		}
		
		
		//命令状态  0待命 1冲锋 2寻对手  3移动 4战斗 
		public static var COMMANDSTATE_AWAIT:int = 0;
		public static var COMMANDSTATE_CHONGFENG:int = 1;
		public static var COMMANDSTATE_FIND:int = 2;
		public static var COMMANDSTATE_MOVE:int = 3;
		public static var COMMANDSTATE_FIGHT:int = 4;
		public static var COMMANDSTATE_NOTARGER:int = 5;
		
		private var _commandState:int = COMMANDSTATE_AWAIT;	
		public function setCommandState(value:int,obj:* = null):void 
		{
			_commandState = value;
		}
		
		//=====编号  
		private var _myIndex:int;		//gs
		
		//目标 攻击对象
		private var _myTarget:FightRoleShow;
		private var _myTargetPos:Array;
		
		
		
		public function FightRoleShow() 
		{
			super();
			_updataByTime = false;
			SceneManage.getInstance().deleteFromObjectArr(this);
		}
		
		override protected function setNameShow():void
		{
			if (_zhenDir == -1) {
				setNameObj("<font color='#FF8844'>"+"名字:" + _myName);
			}else {
				setNameObj("名字:" + _myName);
			}
		}
		
		//动作结束
		override protected function actionComplete(e:ExpandMeshEvent):void 
		{
			_actionFinished = true;
			if(_died){
				return;
			}
			if (FightShowManage.getInstance().fightState == FightShowManage.FIGHTSTATE_END) {
				justgotoFrame(_standActionStr);
				initStand();	//站立状态
				return;
			}
			trace(e.infoObj,"dfasdjalsflajh")
			if (e.infoObj == _attackActionStr) {
				endAttack();
			}else {
				justgotoFrameAll(e.infoObj)
			}
		}
		
		
		override public function initShow(ctn:*, posx:Number = 0, posy:Number = 0, posz:Number = 0):void 
		{
			super.initShow(ctn, posx, posy, posz);
			
			trace("2")
		}
		
		//========================================刷新==================================================
		
		//控制
		override protected function controlEvent():void 
		{
			if (FightShowManage.runByFrame) {
				runByFrame();		//按帧执行
			}else {
				runByTime();		//按时间执行
			}
		}
		
		
		public static function getTimeByFrame(frame:int):int
		{
			return 1000 * frame / Game_3d_D.FRAME_RATE;
		}
		private var _endRun:Boolean = false;
		
		//按时间执行
		private function runByTime():void
		{
			if (_endRun) {
				return;
			}
			
			actionEvent();
			getNowStepArrByTime();
			//======根据步骤来显示
			showByStepByTime();
			
			//=====调整位置
			adjustPosByTime();
			
			if (FightShowManage.getInstance().nowTime >= getTimeByFrame(FightShowManage.getInstance().resultObj.endFrame)) {
				stopAction();
				_endRun = true;
			}
		}
		
		
		private var _nextRunTime:int = -1;
		private var _runFrameTime:int;
		private var _runStepArrs:Array;
		private function getNowStepArrByTime():void
		{
			if (FightShowManage.getInstance().nowTime < _nextRunTime) {
				return;
			}
			_runStepArrs = [];
			for (var i:int = _nowStepIndex; i < stepArr.length; i++ ) {
				if (FightShowManage.getInstance().nowTime < getTimeByFrame(stepArr[i][0])) {
					_nextRunTime = getTimeByFrame(stepArr[i][0]);
					_nowStepIndex = i;
					break;
				}
				if (stepArr[i].length > 1) {
					_runStepArrs.push(stepArr[i]);
				}
			}
		}
		
		
		//======根据步骤来显示
		private function showByStepByTime():void 
		{
			if (!_runStepArrs) {
				return;
			}
			for (var i:int = 0; i < _runStepArrs.length; i++ ) {
				runOneStepArrByTime(_runStepArrs[i]);
			}
			_runStepArrs = null;
		}
		
		private var _beginMoveTime:int;
		private var _speedPoint:Point = new Point();
		
		private function runOneStepArrByTime(arr:Array):void 
		{
			if (arr.length == 1) {
				initStand();
				gotoFrame(_standActionStr);
				return;
			}
			if (arr[2][0] != 0 || arr[2][1] != 0) {
				adjustPosByTime(getTimeByFrame(arr[0]));
				//=====位移做处理
				_beginMoveTime = getTimeByFrame(arr[0]);
				_speedPoint = new Point();
				_speedPoint.x = arr[2][0] * Game_3d_D.FRAME_RATE / 1000;
				_speedPoint.y = arr[2][1] * Game_3d_D.FRAME_RATE / 1000;
				//trace(FightShowManage.getInstance().nowTime,_beginMoveTime,"================",_myID)
				initWalk(arr[2][0], arr[2][1]);
				adjustPosByTime();
				updataRoleRotation();
				justgotoFrame(_walkActionStr);
			}else {
				initStand();
				gotoFrame(_standActionStr)
			}
			if (arr[2][2]) {
				//trace(FightShowManage.runFrameTime,"ID",_myID,"执行的函数",_nowStepArr[2][2])
				this[arr[2][2]].apply(null,arr[2][3]);
			}
		}
		
		override protected function initStand():void 
		{
			adjustPosByTime();
			super.initStand();
			_speedPoint.x = 0;
			_speedPoint.y = 0;
		}
		
		
		/**
		 * //=====调整位置
		 * @param	changeWalkTime		在下次改变速度之前的调整时间
		 */
		private function adjustPosByTime(changeWalkTime:int = -1):void 
		{
			if (_moveState != MOVESTATE_WALK) {
				return;
			}
			var endTime:int;
			if (changeWalkTime == -1) {
				endTime = FightShowManage.getInstance().nowTime;
			}else {
				endTime = changeWalkTime;
			}
			
			var offerTime:int = endTime - _beginMoveTime;
			var nextX:Number = _speedPoint.x * offerTime+_myX;
			var nextZ:Number = _speedPoint.y * offerTime+_myZ;
			initPos(nextX, _myY, nextZ);
			_beginMoveTime = endTime;
		}
		
		
		//==================================================按帧执行
		private function runByFrame():void
		{
			actionEvent();
			
			if (FightShowManage.runFrameTime > FightShowManage.getInstance().resultObj.endFrame) {
				return;
			}
			getNowStepArr();
			
			//======根据步骤来显示
			showByStep();
			
			if (FightShowManage.runFrameTime == FightShowManage.getInstance().resultObj.endFrame) {
				stopAction();
			}
		}
		
		
		
		public var stepArr:Array;
		private var _nowStepIndex:int = 0;
		private var _nowStepArr:Array;
		private var _runFrameNum:int = 0;
		private var _nextRunFrame:int = 0;
		
		private function getNowStepArr():void
		{
			if (FightShowManage.runFrameTime != _nextRunFrame) {
				return;
			}
			if (_nowStepArr) {
				_nowStepIndex++;
			}
			_nowStepArr = stepArr[_nowStepIndex];
			_runFrameNum = _nowStepArr[0];
			if (stepArr[_nowStepIndex + 1]) {
				if (stepArr[_nowStepIndex + 1].length == 1) {
					_nextRunFrame = -1;
				}else {
					_nextRunFrame = stepArr[_nowStepIndex + 1][0];
				}
			}else {
				_nextRunFrame = -1;
			}
		}
		
		
		//======根据步骤来显示
		private function showByStep():void 
		{
			if (FightShowManage.runFrameTime == _runFrameNum) {
				if (_nowStepArr.length == 1) {
					initStand();
					gotoFrame(_standActionStr);
					return;
				}
				if (_nowStepArr[2][0] != 0 || _nowStepArr[2][1] != 0) {
					initWalk(_nowStepArr[2][0], _nowStepArr[2][1])
					updataRoleRotation();
					justgotoFrame(_walkActionStr)
				}else {
					initStand();
					gotoFrame(_standActionStr)
				}
				if (_nowStepArr[2][2]) {
					//trace(FightShowManage.runFrameTime,"ID",_myID,"执行的函数",_nowStepArr[2][2])
					this[_nowStepArr[2][2]].apply(null,_nowStepArr[2][3]);
				}
				if (_nextRunFrame == _runFrameNum) {
					getNowStepArr();
					showByStep();
				}
			}
		}
		
		//动作事件
		private function actionEvent():void 
		{
			
		}
		
		
		//======================================================================================
		
		//开始攻击
		private function beginAttack(index:int):void
		{
			_myTarget = FightShowManage.getInstance().allRoleDic[index];
			if (!_myTarget) {
				_myTargetPos = FightShowManage.getInstance().allRolePosDic[index];
			}
			setActionState(ACTIONSTATE_ATTACK);
			gotoFrame(_attackActionStr);
			updataRoleRotationToTarget();	//角度
		}
		
		//攻击检测
		private function attackTest(index:int):void
		{
			
		}
		
		//挨打
		private function beHitAction(index:int,skillName:String,hurt:int):void
		{
			Effect_bone.addBoneEff(_mesh.parent,1,_myX, _myY + _myHeight/2, _myZ);
			Effect_sprite3D.creatTextEff(_mesh.parent, "伤害-"+hurt, new Vector3D(_myX, _myY + _myHeight, _myZ), new Vector3D(_myX, _myY + _myHeight*1.5, _myZ), 1);
			stop();
		}
		
		//挨打结束
		private function endAida():void
		{
			start();
			justgotoFrame(_standActionStr);
		}
		
		//====攻击结束
		private function endAttack():void 
		{
			if(_died){
				return;
			}
			setActionState(ACTIONSTATE_NORMAL);
			gotoFrame(_standActionStr);
		}
		
		
		//====================停止
		private function stopAction():void
		{
			initStand();
			gotoFrame(_standActionStr);
		}
		
		
		
		//人物角度 速度方向
		private function updataRoleRotation():void
		{
			_mesh.rotationY = 180 * Math.atan2(-_speedZ, _speedX) / Math.PI - 90;
		}
		//人物角度 目标方向
		private function updataRoleRotationToTarget():void
		{
			var tagetX:Number;
			var tagetZ:Number;
			if (_myTarget) {
				tagetX = _myTarget.myX;
				tagetZ = _myTarget.myZ;
			}else {
				tagetX = _myTargetPos[0];
				tagetZ = _myTargetPos[2];
			}
			_mesh.rotationY = 180 * Math.atan2(-(tagetZ- _myZ), tagetX - _myX) / Math.PI - 90;
		}
		
		
		
		override protected function move():void 
		{
			if (FightShowManage.runByFrame) {
				super.move();
			}else {
				updataPlugPos();
			}
		}
		
		//=============================================================== d g s=============================================
		override public function deleteMe():void 
		{
			
			var arr:Vector.<ExpandMesh> = LoadXmlData.sceneMeshArr;
			
			trace(_myID,"死亡")
			FightShowManage.getInstance().deleteFromArr(this);
			_myTarget = null;
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
		
		
		public function get zhenIndex():int 
		{
			return _zhenIndex;
		}
		
		public function set zhenIndex(value:int):void 
		{
			_zhenIndex = value;
		}
		
		public function get zhenDir():int 
		{
			return _zhenDir;
		}
		
		public function get myHeight():int 
		{
			return _myHeight;
		}
		
		public function get myIndex():int 
		{
			return _myIndex;
		}
		
		public function set myIndex(value:int):void 
		{
			_myIndex = value;
		}
		
		
		public function setZhenDir(value:int):void 
		{
			_zhenDir = value;
		}
		
		
		
		
		
		
	}

}