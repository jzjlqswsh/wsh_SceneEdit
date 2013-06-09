package wshExpand.load 
{
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.utils.Cast;
	import sunag.sea3d.objects.SEAMesh;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import sunag.events.SEAEvent;
	import sunag.sea3d.SEA3D;
	import sunag.sea3d.config.DefaultConfig;
	
	import wshExpand.display.ExpandMesh;
	import wshExpand.display.displayData.AssetsData;
	import wshExpand.display.displayData.MyMaterialData;
	import wshExpand.display.displayData.MyMeshData;
	import wshExpand.display.displayData.MySkeletonData;
	import wshExpand.display.displayData.MyWeaponMeshData;
	import wshExpand.skeletonExpand.ExpandMeshEvent;
	import wshExpand.skeletonExpand.SkeletonDatas;

	/**
	 * ...sea文件加载管理
	 * @author wangshuaihua
	 */
	public class LoadSeaManage 
	{
		public function LoadSeaManage():void 
		{
			
		}
		
		
		
		//
		public static var loadEventDispatch:EventDispatcher = new EventDispatcher();
		
		private static var _loadComplete:Dictionary = new Dictionary();
		public static const LOADSTATE_NO:int = 0;
		public static const LOADSTATE_ING:int = 1;
		public static const LOADSTATE_END:int = 2;
		private static function setLoadState(name:String, state:int):void
		{
			_loadComplete[name] = state;
		}
		public static function getLoadState(name:String):int
		{
			if (!_loadComplete[name]) {
				return LOADSTATE_NO;
			}
			return _loadComplete[name];
		}

		
		//=========加载一个数组
		public static function loadSeaArr(seaArr:Array,loadIndex:int = 0, con:EventDispatcher = null):void
		{
			var endCon:EventDispatcher;
			if (loadIndex == seaArr.length - 1) {
				endCon = con;
			}else {
				endCon = new EventDispatcher();
				endCon.addEventListener(ExpandMeshEvent.LOADSEA_COMPLETE,nextLoad);
			}
			function nextLoad():void
			{
				endCon.removeEventListener(ExpandMeshEvent.LOADSEA_COMPLETE,nextLoad);
				loadIndex++;
				loadSeaArr(seaArr, loadIndex, con);
			}
			var arr:Array = seaArr[loadIndex];
			loadSea(seaArr[loadIndex], endCon);
		}
		
		
		
		
		
		/**
		 * 加载一个sea文件
		 * @param	name
		 * @param	type
		 * @param	path
		 * @param	con  发侦听
		 */
		public static function loadSea(path:String,con:EventDispatcher = null):void
		{
			if (MyMeshData.getExpandMesh(path)) {
				if (con) {
					con.dispatchEvent(new ExpandMeshEvent(ExpandMeshEvent.LOADSEA_COMPLETE,MyMeshData.getExpandMesh(path)));
				}
				return;
			}
			var _sea3d:SEA3D = new SEA3D(new DefaultConfig());
			var fileName:String = path.split("/").pop().split(".")[0];
			trace(path,fileName,"777777777777777777777777")
			_sea3d.load(new URLRequest(path));
			_sea3d.addEventListener(SEAEvent.COMPLETE, onComplete);	
			function onComplete(e:SEAEvent):void 
			{
				_sea3d.removeEventListener(SEAEvent.COMPLETE, onComplete);
				unSaveLoadSea(fileName,_sea3d,con,path);
			}
		}
		
		//=========非存储加载
		private static function unSaveLoadSea(name:String,_sea3d:SEA3D,con:EventDispatcher = null,path:String = null):void
		{
			var conL:ExpandMesh = new ExpandMesh();
			conL.myName = name;
			conL.setMyType(ExpandMesh.MESHTYPE_STATIC);
			var i:int;
			if(_sea3d.meshes){
				for (i = 0; i < _sea3d.meshes.length; i++ ) {
					if (_sea3d.meshes[i].parent != conL) {
						conL.addOneMesh(_sea3d.meshes[i]);
					}
				}
			}
			MyMeshData.addExpandMesh(path, conL);
			_sea3d.disposeSEAObjects();
			if (con) {
				con.dispatchEvent(new ExpandMeshEvent(ExpandMeshEvent.LOADSEA_COMPLETE,conL));
			}
		}
		
		
		
		//=========加载文件 传回调
		public static function loadSeaByCallBack(path:String,endFun:Function,endFunArr:Array = null):void
		{
			var con:EventDispatcher = new EventDispatcher();
			con.addEventListener(ExpandMeshEvent.LOADSEA_COMPLETE, loadEnd);
			function loadEnd(e:ExpandMeshEvent):void
			{
				con.removeEventListener(ExpandMeshEvent.LOADSEA_COMPLETE, loadEnd);
				if (endFunArr) {
					endFunArr.unshift(e.infoObj);
				}else {
					endFunArr = [e.infoObj];
				}
				endFun.apply(null, endFunArr);
			}
			loadSea(path);
		}
		
		
		/**
		 * 
		 * @param	path
		 * @param	callBackFun
		 * @param	callBackFunParam
		 */
		public static function loadTextureMaterial(path:String,callBackFun:Function = null,callBackFunParam:Array = null):void
		{
			if (MyMaterialData.getMaterial(path)) {
				if (callBackFun != null) {
					callBackFun.apply(null, callBackFunParam);
				}
				return;
			}
			var loader:Loader = new Loader();
			loader.load(new URLRequest(path));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e:Event):void {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, arguments.callee);
				var material:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(loader.contentLoaderInfo.content), true, true);
				MyMaterialData.addMaterial(path, material);
				if (callBackFun != null) {
					callBackFun.apply(null, callBackFunParam);
				}
			})
		}
		
		//===========加载图片
		public static function loadBitMapData(path:String,callBackFun:Function = null,callBackFunParam:Array = null):void
		{
			var loader:Loader = new Loader();
			loader.load(new URLRequest(path));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e:Event):void {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, arguments.callee);
				//var material:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(loader.contentLoaderInfo.content), true, true);
				if (callBackFun != null) {
					if (!callBackFunParam) {
						callBackFunParam = [(loader.contentLoaderInfo.content as Bitmap).bitmapData];
					}else {
						callBackFunParam.unshift((loader.contentLoaderInfo.content as Bitmap).bitmapData);
					}
					callBackFun.apply(null, callBackFunParam);
				}
			})
		}
	}

}