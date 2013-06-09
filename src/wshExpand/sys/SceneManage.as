package wshExpand.sys 
{
	import away3d.animators.SkeletonAnimator;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapCubeTexture;
	import away3d.utils.Cast;
	import flash.utils.getTimer;
	
	import com.Astart.Astart;
	import com.Astart.Node;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.setTimeout;
	
	import gameCode.model.SceneModel;
	import gameCode.model.ServerInfoModel;
	import gameCode.ui.FirstLayer.FightLayerGroup;
	import gameCode.ui.FirstLayer.FightLayerMediator;
	
	import wshExpand.control.Abstract_basic;
	import wshExpand.control.NpcRole;
	import wshExpand.control.Role;
	import wshExpand.data.KeyDatas;
	import wshExpand.data.RoleProData;
	import wshExpand.display.ExpandMesh;
	import wshExpand.display.GridMesh;
	import wshExpand.display.displayData.MyMeshData;
	import wshExpand.display.displayData.MySkeletonData;
	import wshExpand.display.displayData.MyWeaponMeshData;
	import wshExpand.effect.Effect_bone;
	import wshExpand.fight.FightDataManage;
	import wshExpand.fight.FightShowManage;
	import wshExpand.load.LoadSeaManage;
	import wshExpand.load.LoadXmlData;
	import wshExpand.skeletonExpand.ExpandMeshEvent;
	import wshExpand.utils.Functions;
	import wshExpand.utils.Utils_away3d;
	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class SceneManage 
	{
		[Inject]
		public var scene:SceneModel;
		
		// Environment map.
		[Embed(source="/res/assets/sea/sky/snow_positive_x.jpg")]
		private var EnvPosX:Class;
		[Embed(source="/res/assets/sea/sky/snow_positive_y.jpg")]
		private var EnvPosY:Class;
		[Embed(source="/res/assets/sea/sky/snow_positive_z.jpg")]
		private var EnvPosZ:Class;
		[Embed(source="/res/assets/sea/sky/snow_negative_x.jpg")]
		private var EnvNegX:Class;
		[Embed(source="/res/assets/sea/sky/snow_negative_y.jpg")]
		private var EnvNegY:Class;
		[Embed(source="/res/assets/sea/sky/snow_negative_z.jpg")]
		private var EnvNegZ:Class;
		
		[Embed(source = "/res/assets/config/scene/HeightData.xml", mimeType = "application/octet-stream")]
		private static var _xml_1:Class;
		
		private static var _heghtXml:XML;
		private static function initXml():void
		{
			_heghtXml = XML(new _xml_1());
		}
		
		
		public static var dixingInfoArr:Array;
		
		private var _zhengxing:Array = [
										[1, 0, 0, 1], 
										[0, 0, 0, 0],
										[0, 0, 0, 0], 
										[1, 0, 0, 1],
										[0, 0, 0, 0], 
										[0, 0, 0, 0],
										[1, 0, 0, 1], 
										[1, 0, 0, 1]
										]
		
		private var _scene3D:Scene3D;
		
		//高度图
		public var heightBitMap:BitmapData;
		
		//场景信息
		public static var sceneType:String;		//场景类型  
		
		private var _cityID:int = 1;
		private var _fubenID:int = 1;
		
		//根据信息得到 加载的xml路径
		private function getXmlPath():String
		{
			var pasthStr:String = ServerInfoModel.xmlUrl+"d3d/res/assets/config/scene/" + sceneType + "/";
			var xmlName:String = "sceneData_" + _cityID + "_" + _fubenID+".xml";
			return pasthStr + xmlName;
		}
		//得到高度图路径
		private function getHeightPath():String
		{
			var pasthStr:String = ServerInfoModel.xmlUrl+"d3d/res/assets/config/scene/" + sceneType + "/";
			var xmlName:String = "height_" + _cityID + "_" + _fubenID+".png";
			return pasthStr + xmlName;
		}
		//得到高度信息
		private function getHeightInfo():void
		{
			if (!_heghtXml) {
				initXml();
			}
			dixingInfoArr = Functions.stringToObject(_heghtXml["HeightDatas"][sceneType]["height_" + _cityID + "_" + _fubenID]) as Array;
		}
		
		//加载场景  
		private function loadScene():void
		{
			//得到高度相关的数据
			getHeightInfo();
			//加载高度图
			loadHeightMap();
		}
		//加载高度图
		private function loadHeightMap():void
		{
			LoadSeaManage.loadBitMapData(getHeightPath(),nextFun );
			function nextFun(bmd:BitmapData):void
			{
				heightBitMap = bmd;
				loadSceneXml();
			}
		}
		//加载场景
		private function loadSceneXml():void
		{
			LoadXmlData.readXml(getXmlPath(), _scene3D, loadRole);
		}
		
		
		//=========所有对象数组
		private var _allObjectArr:Vector.<Abstract_basic>;
		public function get allObjectArr():Vector.<Abstract_basic> 
		{
			if (!_allObjectArr) {
				_allObjectArr = new Vector.<Abstract_basic>();
			}
			return _allObjectArr;
		}
		
		//刷新数组对象
		private function updataObjectArr():void
		{
			for (var i:int = 0; i < allObjectArr.length; i++ ) {
				_allObjectArr[i].updataFrame();
			}
		}
		
		public function deleteFromObjectArr(who:Abstract_basic):void
		{
			if (_allObjectArr.indexOf(who) != -1 ) {
				_allObjectArr.splice(_allObjectArr.indexOf(who), 1);
			}else {
				trace(who.myName,"————已经不在数组中了,还在删")
			}
		}
		//清楚所有obj
		public function deleteAllObj():void
		{
			for (var i:int = allObjectArr.length - 1; i >= 0; i-- ) {
				_allObjectArr[i].deleteMe();
			}
		}
		
		
		private static var _instance:SceneManage;
		static public function getInstance():SceneManage 
		{
			if (!_instance) {
				_instance = new SceneManage();
			}
			return _instance;
		}
		
		public function SceneManage() 
		{
			_oneFrameTime = 1000 / Game_3d_D.FRAME_RATE;
		}
		
		public var fightMediator:FightLayerMediator;
		
		
		
		//========城镇
		public function creatCity():void
		{
			sceneType = SceneModel.CITY;
			loadScene();
		}
		public var player:Role;
		
		private function initCity():void 
		{
			
			creatSky();
			//===创建主角
			creatPlayer();
			
			//===创建NPC
			creatNpc();
			
			creatTest();
		}
		
		//===========================================创建主角===================================
		public function creatPlayer():void
		{
			var infoObj:Object = new Object();
			infoObj.myName = "meizi";
			infoObj.showIndex = 1;
			infoObj.weaponName = "weapon_2";
			player = Role.creatRole(infoObj, true);
			player.mesh.scale(2)
			player.initShow(_scene3D);
			//设置镜头
			CameraManage.getInstance().setCameraType(CameraManage.CAMERATYPE_FOLLOWTRAGET);
			CameraManage.getInstance().setMyTaget(player.mesh);
		}
		
		
		//======测试
		private function creatTest():void
		{
			var infoObj:Object = new Object();
			infoObj.myName = "meizi";
			infoObj.showIndex = 1;
			infoObj.weaponName = "weapon_1";
			var testPlayer:Role;
			for (var i:int = 0; i < 10; i++ ) {
				for (var j:int = 0; j < 5; j++ ) {
					testPlayer = Role.creatRole(infoObj);
					testPlayer.mesh.scale(2)
					testPlayer.initShow(_scene3D,100*i,0,100*j);
				}
			}
		}
		
		
		//===========================================天空盒=====================================
		private var _sky:SkyBox;
		//创建天空
		private function creatSky():void
		{
			var cubeTexture:BitmapCubeTexture = new BitmapCubeTexture(Cast.bitmapData(EnvPosX), Cast.bitmapData(EnvNegX), Cast.bitmapData(EnvPosY), Cast.bitmapData(EnvNegY), Cast.bitmapData(EnvPosZ), Cast.bitmapData(EnvNegZ));
			_sky = new SkyBox(cubeTexture)
			_scene3D.addChild(_sky);
		}
		
		//清楚天空
		private function clearSky():void
		{
			_sky.dispose();
			_sky = null;
		}
		
		
		//========================================NPC========================================
		private function creatNpc():void 
		{
			var nodeArr:Vector.<Node> = Astart.myGrid.getNodesByType(LoadXmlData.gridArr[1], 3);
			for (var i:int = 0; i < nodeArr.length; i++ ) {
				var npc:NpcRole = new NpcRole();
				npc.setMyName("monster_1");
				npc.setV(ExpandMesh.creatObj(npc.myName));
				var p:Point = Astart.myGrid.getXYByNode(nodeArr[i]);
				npc.initShow(_scene3D, p.x, 0, p.y);
			}
		}
		
		private function updataWeapon():void 
		{
			if (player) {
				if (KeyboardManage.getInstance().getKeyState(KeyDatas.keyToNumsObj["e"])) {
					player.setWeaponName("weapon_1", true);
					
					//var animator:SkeletonAnimator = (player.weaponMesh.getChildAt(0) as Mesh).animator as SkeletonAnimator;
					//var mesh:Mesh = ExpandMesh.cloneMe(MyWeaponMeshData.getWeaponMesh("meizi", "weapon_1", player.currentLable)).getChildAt(0) as Mesh;
					//mesh.material = new ColorMaterial();//new TextureMaterial((mesh.material as TextureMaterial).texture);
					//mesh.animator = animator;
					//player.weaponMesh.deleteMesh(player.weaponMesh.getChildAt(0) as Mesh, 0);
					//player.weaponMesh.addOneMesh(mesh);
					
				}else if (KeyboardManage.getInstance().getKeyState(KeyDatas.keyToNumsObj["q"])) {
					player.setWeaponName("weapon_2", true);
				}
			}
		}
		
		
		
		
		//========创建战斗
		public function creatFight():void 
		{
			sceneType = SceneModel.FUBEN;
			loadScene();
		}
		
		private var eventObj:EventDispatcher = new EventDispatcher();
		//角色载入
		private function loadRole():void
		{
			LoadSeaManage.loadTextureMaterial(ServerInfoModel.xmlUrl+"d3d/res/assets/textures/role/player_1_0.png", callBack);
			function callBack():void
			{
				LoadSeaManage.initLoadSeaObjArr(["monster_1", "player_1","meizi"], endLoad, [null]);
			}
		}
		private function endLoad(e:ExpandMeshEvent):void
		{
			LoadSeaManage.loadBujian("meizi", "weapon_1","weapon",LoadSeaManage.loadBujian,["meizi", "weapon_2","weapon",endLoadWeapon]);
		}
		private function endLoadWeapon():void
		{
			trace("角色加载完成ssssssssssss")
			eventObj.addEventListener(ExpandMeshEvent.LOADSEA_COMPLETE, loadRoleCompele)
			LoadSeaManage.addActionArr("monster_1", ["attack"], null);
			LoadSeaManage.addActionArr("player_1", ["run", "attack"] );
			LoadSeaManage.addActionArr("meizi", ["walk"], eventObj);
		}
		
		private function loadRoleCompele(e:ExpandMeshEvent):void 
		{
			if (sceneType == SceneModel.FUBEN) {
				creatSky();
				Astart.initFightMyGrid();
				FightDataManage.getInstance().creatFight([_zhengxing, _zhengxing]);
			}else {
				initCity();
			}
			eventObj.removeEventListener(ExpandMeshEvent.LOADSEA_COMPLETE, loadRoleCompele);
		}
		
		//=======================================按时间刷新计算
		private var _oneFrameTime:int;		//g
		private var _beginTime:int = -1;
		private var _nowTime:int;			//当前执行到的时间		g
		private function updataTime():void
		{
			if (_beginTime == -1) {
				_beginTime = getTimer();
				_nowTime = 0;
			}else {
				_nowTime = getTimer() - _beginTime;
				_beginTime += _nowTime;
			}
		}
		
		
		//============================================刷新函数=============================
		public function updataFrame():void
		{
			updataTime();
			
			updataWeapon();
			
			//所有对象刷新
			updataObjectArr();
			
			
			FightShowManage.getInstance().updataFrame();
			
			//相机
			CameraManage.getInstance().updataFrame();
		}
		
		
		
		//=========清空场景
		public function clearScene():void
		{
			//清楚所有对象
			deleteAllObj();
			player = null;
			clearSky();	//清楚天空
			LoadXmlData.clearSceneMesh();	//清楚场景
			//重置相机
			CameraManage.getInstance().setCameraType(CameraManage.CAMERATYPE_STATIC);
			CameraManage.getInstance().setMyTaget(null);
			CameraManage.getInstance().cameraController_1.lookAtPosition = new Vector3D();
		}
		
		
		//进入战斗
		public function enterToFight():void
		{
			clearScene();
			creatFight();	//进入战斗
		}
		
		//进入城镇
		public function enterToCity():void
		{		
			clearScene();
			creatCity();	//进入战斗
		}
		
		
		
		//---------------------------------------- g s-------------------------------
		public function get scene3D():Scene3D 
		{
			return _scene3D;
		}
		
		public function set scene3D(value:Scene3D):void 
		{
			_scene3D = value;
		}
		
		public function get nowTime():int 
		{
			return _nowTime;
		}
		
		public function get oneFrameTime():int 
		{
			return _oneFrameTime;
		}
		
		
		
	}

}