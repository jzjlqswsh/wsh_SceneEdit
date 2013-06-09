package wshExpand.fight 
{
	import com.Astart.Astart;
	import com.Astart.Node;
	import wshExpand.control.FightRoleDummy;
	
	import wshExpand.data.RoleProData;
	import wshExpand.display.ExpandMesh;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	/**
	 * ...战斗管理 数据
	 * @author wangshuaihua
	 */
	public class FightDataManage 
	{
		public static const FIGHTSTATE_READY:int = 1;
		public static const FIGHTSTATE_CHONGFENG:int = 2;
		public static const FIGHTSTATE_FIGHT:int = 3;
		public static const FIGHTSTATE_END:int = 4;
		//战斗状态  1准备 2冲锋 3战斗 4结束
		private var _fightState:int = FIGHTSTATE_READY;		//g
		public function changeFightState(state:int):void
		{
			_fightState = state;
		}
		
		//战斗结果 1胜利 2失败
		private var _fightResult:int = 0;		//g
		
		private var _zhenWidth:int = 4;
		private var _zhenHeight:int = 4;
		
		//存储的数据
		private var fightDataArr:Array = [];
		public function addFightDara(data:Object):void
		{
			fightDataArr.push(data);
		}
		
		
		
		
		//战斗中的角色数组
		private var _allRoleArr:Vector.<FightRoleDummy> = new Vector.<FightRoleDummy>();	
		private var _roleDirectionArr:Array = [];
		//根据类型拿到角色
		public function getRoleArrByType(type:int):Vector.<FightRoleDummy>
		{
			for (var i:int = 0; i < _roleDirectionArr.length; i++ ) {
				if (_roleDirectionArr[i][0] == type) {
					return _roleDirectionArr[i][1];
				}
			}
			return null;
		}
		//各个阵角色数量
		private var _roleNumArr:Array = [];
		
		//根据阵序号 拿角色
		public function getRoleArrByIndex(index:int):Vector.<FightRoleDummy>
		{
			return _roleDirectionArr[index][1];
		}
		public function getEnemyArr(index:int):Vector.<FightRoleDummy>
		{
			var arr:Array = [];
			for (var i:int = 0; i < _roleDirectionArr.length; i++ ) {
				if (i != index) {
					arr.push(_roleDirectionArr[i][1]);
				}
			}
			if (arr.length == 1) {
				return arr[0];
			}else {
				return uniteArrs(arr);
			}
		}
		
		//合并数组  并返回新的数组
		public static function uniteArrs(arg:Array):Vector.<FightRoleDummy>
		{
			if (!arg || arg.length == 0) {
				return null;
			}
			var newArr:Vector.<FightRoleDummy> = new Vector.<FightRoleDummy>();
			var oldArr:Vector.<FightRoleDummy>;
			for (var i:int = 0; i < arg.length; i++ ) {
				oldArr = arg[i];
				for (var j:int = 0; j < oldArr.length; j++ ) {
					newArr.push(oldArr[j]);
				}
			}
			return newArr;
		}
		
		public function getFriendArr(index:int):Vector.<FightRoleDummy>
		{
			return _roleDirectionArr[index][1];
		}
		
		
		private static var _instance:FightDataManage;
		static public function getInstance():FightDataManage 
		{
			if (!_instance) {
				_instance = new FightDataManage();
			}
			return _instance;
		}
		
		public function FightDataManage() 
		{
			
		}
		
		
		
		
		//创建战斗
		public function creatFight(roleArr:Array):void
		{
			creatRole(roleArr[0], 1);
			creatRole(roleArr[1], -1);
			setTimeout(readyFight, 1);
		}
		
		//准备战斗  开始冲锋
		private function readyFight():void 
		{
			changeFightState(FIGHTSTATE_CHONGFENG);
			FightRoleDummy.frameTime = 0;
			var node:Node;
			var myNode:Node;
			var role:FightRoleDummy;
			var i:int;
			var j:int;
			var arr:Vector.<FightRoleDummy>;
			
			var hang:int;
			var lie:int;
			
			for (i = 0; i < _roleDirectionArr.length; i++ ) {
				arr = _roleDirectionArr[i][1];
				for (j = 0; j < arr.length; j++  ) {
					role = arr[j];
					hang = role.myNode.x;
					if (_roleDirectionArr[i][0] == 1) {
						lie = Astart.myGrid.col / 2 - _zhenWidth + role.myNode.y;
					}else {
						lie =  role.myNode.y - Astart.myGrid.col/2 +_zhenWidth;
					}
					node = Astart.myGrid.nodes[lie][hang];
					role.setCommandState(FightRoleDummy.COMMANDSTATE_CHONGFENG, node);
					role.searchRode(node, true);
				}
			}
			getStep();
		}
		
		//======方案2============
		private function getStep():void
		{
			var getTime:int = getTimer();
			var num:int = 0;
			var role:FightRoleDummy;
			while (_fightState != FIGHTSTATE_END) {
				num++;
//				if (num == 50) {
//					break;
//				}
				FightRoleDummy.frameTime = getNextRunFrame1();
				//trace(getNextRunFrame1(),"888888888888888888888888")
				for (var i:int = _allRoleArr.length - 1; i >= 0; i-- ) {
					role = _allRoleArr[i];
					if(_fightState != FIGHTSTATE_END){
						role.checkRun();
					}
				}
			}
			var timeNum:int = getTimer() - getTime;
			trace("运行帧数：" +num, FightRoleDummy.frameTime, "执行时间：" + timeNum);
			saveFightData();
		}
		
		private function getNextRunFrame1():int
		{
			var endNum:int = -1;
			for (var i:int = 0; i < _allRoleArr.length; i++ ) {
				if (endNum == -1) {
					endNum = _allRoleArr[i].nextRunFrame;
				}else if (_allRoleArr[i].nextRunFrame < endNum) {
					endNum = _allRoleArr[i].nextRunFrame;
				}
			}
			return endNum;
		}
		
		//获得下次需要运行的帧
		private function getNextRunFrame():Array
		{
			var endNum:int = -1;
			//var role:FightRoleDummy;
			var roleArr:Vector.<FightRoleDummy> = new Vector.<FightRoleDummy>();
			for (var i:int = 0; i < _allRoleArr.length; i++ ) {
				if (endNum == -1) {
					endNum = _allRoleArr[i].nextRunFrame;
					roleArr.push(_allRoleArr[i]);
				}else if (_allRoleArr[i].nextRunFrame < endNum) {
					endNum = _allRoleArr[i].nextRunFrame;
					roleArr.splice(0,roleArr.length);
					roleArr.push(_allRoleArr[i]);
				}else if (_allRoleArr[i].nextRunFrame == endNum) {
					roleArr.push(_allRoleArr[i]);
				}
			}
			return [endNum,roleArr];
		}
		
		//======存储数据
		private function saveFightData():void
		{
			FightShowManage.getInstance().resultObj.endFrame = FightRoleDummy.frameTime+1;
			FightShowManage.getInstance().resultObj.result = _result;
			for (var i:int = _allRoleArr.length-1; i >=0; i-- ) {
				_allRoleArr[i].deleteMe();
			}
			//按序号排序  --》
			fightDataArr.sortOn(["myIndex"], [Array.NUMERIC]);
			FightShowManage.getInstance().showDataArr = fightDataArr;
			trace(fightDataArr.toString().length,"1111111111111111111")
			FightShowManage.getInstance().creatFight();
			
			//======清空自己
			fightDataArr = [];
			_allRoleArr = new Vector.<FightRoleDummy>();
			_roleDirectionArr = [];
			_fightState = FIGHTSTATE_READY;
			_roleNumArr = [];
		}
		
		
		
		
		
		/**
		 * //创建人物
		 * @param	zhengArr 阵型
		 * @param	type     方位
		 */
		private function creatRole(zhengArr:Array,type:int = 1):void
		{
			var arr:Array = [type,new Vector.<FightRoleDummy>()]
			_roleDirectionArr.push(arr);
			
			var jianju:int = 10;
			//创建多个角色
			var copePlay:FightRoleDummy;
			var copyMesh:ExpandMesh;
			var hang:int;
			var lie:int;
			var p:Point;
			for (var i:int = 0; i < zhengArr.length; i++  ) {
				for (var j:int = 0; j < zhengArr[i].length; j++ ) {
					if (!zhengArr[i][j]) {
						continue;
					}
					copePlay = new FightRoleDummy();
					copePlay.setMyName(/*"meizi"*/"player_1")
					copePlay.setZhenDir(type);							//阵位置
					copePlay.zhenIndex = _roleDirectionArr.length-1;	//序列
					copePlay.camp = type;
					copePlay.setM(new RoleProData());
					hang = Astart.myGrid.numRows / 2 - zhengArr.length / 2 + i;;
					lie = j;
					if (type == -1) {
						lie = Astart.myGrid.numCols - j-1;
					}
					
					copePlay.setMyNode(Astart.myGrid.nodes[lie][hang]);
					p = Astart.myGrid.getXYByNodeRandom(copePlay.myNode);
					copePlay.initShow(null,p.x, 0, p.y);
					_allRoleArr.push(copePlay);
					copePlay.myIndex = _allRoleArr.length - 1;
					arr[1].push(copePlay);
					if (!_roleNumArr[_roleDirectionArr.length - 1]) {
						_roleNumArr[_roleDirectionArr.length - 1] = 0;
					}
					_roleNumArr[_roleDirectionArr.length - 1]++;
				}
			}
		}
		
		private var _result:int;		//战败的阵营
		//从数组清楚
		public function deleteFromArr(role:FightRoleDummy):void
		{
			if (_allRoleArr.indexOf(role) != -1) {
				_allRoleArr.splice(_allRoleArr.indexOf(role),1);
			}
			if (_roleDirectionArr[role.zhenIndex][1].indexOf(role) != -1) {
				_roleDirectionArr[role.zhenIndex][1].splice(_roleDirectionArr[role.zhenIndex][1].indexOf(role),1);
			}
			//数量
			_roleNumArr[role.zhenIndex]--;
			if (_roleNumArr[role.zhenIndex] == 0) {
				_result = role.zhenIndex;
				trace("第" + role.zhenIndex + "阵营战败了")
				changeFightState(FIGHTSTATE_END);
			}
		}
		
		
		
		public function updataFrame():void
		{
			
		}
		
		
		//战局判断
		private function fightResurtCheck():Boolean 
		{
			if (_fightState == FIGHTSTATE_END) {
				for (var i:int = 0; i < _roleNumArr.length ; i++ ) {
					if (_roleNumArr[i] == 0) {
						return true;
					}
				}
			}
			return false;
		}
		
		
		
		public function get fightState():int 
		{
			return _fightState;
		}
		
		public function get fightResult():int 
		{
			return _fightResult;
		}
		
		
		
	}

}