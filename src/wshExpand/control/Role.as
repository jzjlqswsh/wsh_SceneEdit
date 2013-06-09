package wshExpand.control 
{
	import away3d.animators.SkeletonAnimator;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import com.Astart.AcorrsLineGrid;
	import com.Astart.Astart;
	import com.Astart.Grid;
	import com.Astart.Node;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import gameCode.model.ServerInfoModel;
	import wshExpand.data.RoleProData;
	import wshExpand.display.ExpandMesh;
	import wshExpand.load.LoadSeaManage;
	import wshExpand.skeletonExpand.ExpandMeshEvent;
	import wshExpand.sys.SceneManage;

	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class Role extends Abstract_action
	{
		
		//==========数据
		private var _myProData:RoleProData;
		
		
		private var _leader:Boolean;	//gs 自动AI	
		
		private var _camp:int;			// 阵营
		
		private var _mySpeed:Number = 10;
		
		
		public function Role() 
		{
			
		}
		
		//设置数据
		override public function setM(data:*):void
		{
			_myProData = data as RoleProData;
		}
		
		override public function initShow(ctn:*, posx:Number = 0, posy:Number = 0, posz:Number = 0):void 
		{
			super.initShow(ctn, posx, posy, posz);
			gotoFrame(_standActionStr);
		}
		
		
		//人物角度
		private function updataRoleRotation():void
		{
			_mesh.rotationY = 180 * Math.atan2(-_speedZ, _speedX) / Math.PI - 90;
		}
		
		private var _walkArr:Array;
		private var _walkStep:int = 0;	//寻路步骤
		private var _walkPoint:Point;
		private var _nextPointAble:Boolean = false;
		//寻路
		public function searchRode(posX:int,posZ:int):void 
		{
			var node:Node = Astart.myGrid.getNodeByXY(posX, posZ);
			searchRodeFun(node);
			trace(posX, posZ,"4444444444")
		}
		
		public function searchRodeFun(node:Node):void 
		{
			_myNode = Astart.myGrid.getNodeByXY(_myX, _myZ);
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
		
		private function moveByRode():void
		{
			if (!_walkArr) {
				return;
			}
			if (_walkStep >= _walkArr.length) {
				_walkArr = null;
				_walkStep = 0;
				return;
			}
			if (!_nextPointAble) {
				return;
			}
			_nextPointAble = false;
			_walkPoint = Astart.myGrid.getXYByNode(_walkArr[_walkStep]);
			var ang:Number = Math.atan2(_walkPoint.y - _myZ, _walkPoint.x - _myX);
			initWalk( Math.cos(ang) * _mySpeed, Math.sin(ang) * _mySpeed);
			gotoFrame(_walkActionStr)
			updataRoleRotation();
		}
		
		//判断是否到达
		private function checkArrive():void
		{
			if (!_walkArr) {
				return;
			}
			if (!_walkPoint) {
				return;
			}
			if (Math.abs(_myX + _speedX - _walkPoint.x) < _mySpeed && Math.abs(_myZ + _speedZ - _walkPoint.y) < _mySpeed) {
				_walkPoint = null;
				_nextPointAble = true;
				_myNode = _walkArr[_walkStep];
				initStand();
				gotoFrame(_standActionStr);
				_walkStep++;
			}
		}
		
		
		//控制
		override protected function controlEvent():void 
		{
			if (_leader) {
				autoAiEvent();
			}
			
			moveByRode();
			
			checkArrive();
			
		}
		
		
		
		//自动AI
		private function autoAiEvent():void
		{
			return;
			if (_walkArr) {
				return;
			}
			var node:Node = Astart.myGrid.nodes[int(Math.random() * Astart.myGrid.nodes.length)][int(Math.random() * Astart.myGrid.nodes[0].length)];
			_myNode = Astart.myGrid.getNodeByXY(_myX, _myZ);
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
		
		
		/**
		 * 
		 * @param	info  信息
		 * @param	leader是否主角
		 * @return
		 */
		public static function creatRole(info:Object,leader:Boolean = false):Role
		{
			var roleName:String = info.myName;		//角色名 确定骨骼
			var roleShowIndex:int = info.showIndex;//角色模型名  时装
			var weaponName:String = info.weaponName;//武器模型名
			var roleData:RoleProData = RoleProData.getProDataByObj(info.proObj);
			//===创建主角
			var player:Role = new Role();
			player.leader = leader;
			player.setMyName(roleName);
			player.setWeaponName(weaponName)
			player.setM(roleData);
			player.setV(ExpandMesh.creatObj(roleName));
			return player;
			//player.initShow(_scene3D);
		}
		
		
		
		
		
		override protected function move():void 
		{
			super.move();
		}
		
		public function get leader():Boolean 
		{
			return _leader;
		}
		
		public function set leader(value:Boolean):void 
		{
			_leader = value;
		}
		
		public function get myNode():Node 
		{
			_myNode = Astart.myGrid.getNodeByXY(_myX, _myZ);
			return _myNode;
		}
		
		
	}

}