package wshExpand.fight 
{
	import com.Astart.Astart;
	import com.Astart.Node;
	import wshExpand.load.LoadXmlData;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import wshExpand.control.FightRoleShow;
	import wshExpand.data.RoleProData;
	import wshExpand.display.ExpandMesh;
	import wshExpand.sys.SceneManage;
	/**
	 * ...战斗管理
	 * @author wangshuaihua
	 */
	public class FightShowManage 
	{
		public static var runFrameTime:int = 0;
		
		public static var runByFrame:Boolean = false;
		
		public static var FIGHTSTATE_READY:int = 1;
		public static var FIGHTSTATE_CHONGFENG:int = 2;
		public static var FIGHTSTATE_FIGHT:int = 3;
		public static var FIGHTSTATE_END:int = 4;
		//战斗状态  1准备 2冲锋 3战斗 4结束
		private var _fightState:int = FIGHTSTATE_READY;		//g
		public function changeFightState(state:int):void
		{
			_fightState = state;
		}
		
		//战斗结果 1胜利 2失败
		private var _fightResult:int = 0;		//g
		
		
		//战斗中的角色数组
		private var _allRoleArr:Vector.<FightRoleShow> = new Vector.<FightRoleShow>();	
		private var _allRoleDic:Dictionary = new Dictionary();
		
		private var _allRolePosDic:Dictionary = new Dictionary();
		
		//各个阵角色数量
		private var _roleNumArr:Array = [];
		
		
		//显示数据
		public var showDataArr:Array;
		//分出胜负 数据
		public var resultObj:Object = new Object();
		
		private static var _instance:FightShowManage;
		static public function getInstance():FightShowManage 
		{
			if (!_instance) {
				_instance = new FightShowManage();
			}
			return _instance;
		}
		
		public function FightShowManage() 
		{
			
		}
		
		
		
		
		//创建战斗
		public function creatFight():void
		{
			creatRole();
			
			readyFight();
		}
		
		//准备战斗  开始冲锋
		private function readyFight():void 
		{
			changeFightState(FIGHTSTATE_CHONGFENG);
			runFrameTime = 0;
		}
		
		
		/**
		 * //创建人物
		 * @param	zhengArr 阵型
		 * @param	type     方位
		 */
		private function creatRole():void
		{
			//创建多个角色
			var copePlay:FightRoleShow;
			var copyMesh:ExpandMesh;
			var type:int;
			var obj:Object;
			for (var i:int = 0; i < showDataArr.length; i++  ) {
				obj = showDataArr[i];
				type = obj.proData.zhenDir;
				copePlay = new FightRoleShow();
				copePlay.stepArr = obj.stepArr;
				trace(copePlay.myID,"  ID  ",copePlay.stepArr,"55555555555")
				//trace(copePlay.myID,"  ID  ",copePlay.stepArr[copePlay.stepArr.length-2],copePlay.stepArr[copePlay.stepArr.length-1],"55555555555")
				copePlay.camp = type;
				copePlay.setMyName(obj.proData.myName)
				copePlay.setZhenDir(type);
				copyMesh = ExpandMesh.creatObj(copePlay.myName);
				copePlay.setV(copyMesh);
				copyMesh.rotationY = -90 * type;
				copePlay.initShow(SceneManage.getInstance().scene3D,obj.initPos[0], obj.initPos[1], obj.initPos[2]);
				//copyMesh.setScale(0.1, 0.1, 0.1);
				copyMesh.play("root");
				_allRoleArr.push(copePlay);
				copePlay.myIndex = i;
				trace(i,"7777777777777777")
				_allRoleDic[i] = copePlay;
			}
		}
		
		//从数组清楚
		public function deleteFromArr(role:FightRoleShow):void
		{
			if (_allRoleArr.indexOf(role) != -1) {
				_allRolePosDic[role.myIndex] = [role.myX, role.myY, role.myZ];
				_allRoleDic[role.myIndex] = null;
				_allRoleArr.splice(_allRoleArr.indexOf(role), 1);
			}
		}
		
		
		private var _beginTime:int = -1;
		private var _nowTime:int;			//当前执行到的时间		g
		public function updataFrame():void
		{
			if (_fightState == FIGHTSTATE_READY) {
				return;
			}
			if (_beginTime == -1) {
				_beginTime = getTimer();
				_nowTime = 0;
			}else {
				_nowTime = getTimer() - _beginTime;
			}
			
			for (var i:int = _allRoleArr.length-1; i >=0; i-- ) {
				_allRoleArr[i].updataFrame();
			}
			//====战局判断
			//fightResurtCheck();
			if (_nowTime >= FightRoleShow.getTimeByFrame(resultObj.endFrame)) {
				trace("第" + resultObj.result + "阵营战败了")
				_fightState = FIGHTSTATE_READY;
				_beginTime = -1;
				setTimeout(endFight, 5000);
			}
//			if (runFrameTime == resultObj.endFrame) {
//				trace("第" + resultObj.result + "阵营战败了")
//				setTimeout(endFight, 5000);
//			}
			runFrameTime++;
		}
		
		//========战斗结束
		private function endFight():void
		{
			clearFight();
			SceneManage.getInstance().enterToCity();
		}
		
		
		//=======删除战斗
		private function clearFight():void
		{
			for (var i:int = _allRoleArr.length - 1; i >= 0; i-- ) {
				_allRoleArr[i].deleteMe();
			}
			_allRoleArr = new Vector.<FightRoleShow>();
			_allRoleDic = new Dictionary();
			_allRolePosDic = new Dictionary();
			
		}
		
		
		//战局判断
		private function fightResurtCheck():Boolean 
		{
			if (_fightState == FIGHTSTATE_END) {
				for (var i:int = 0; i < _roleNumArr.length ; i++ ) {
					if (_roleNumArr[i] == 0) {
						//trace("第" + i + "阵营战败了")
						//changeFightState(FIGHTSTATE_END);
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
		
		public function get allRoleArr():Vector.<FightRoleShow> 
		{
			return _allRoleArr;
		}
		
		public function get allRoleDic():Dictionary 
		{
			return _allRoleDic;
		}
		
		public function get nowTime():int 
		{
			return _nowTime;
		}
		
		public function get allRolePosDic():Dictionary 
		{
			return _allRolePosDic;
		}
		
		
		
	}

}