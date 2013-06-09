package wshExpand.load 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import wshExpand.utils.Functions;
	import wshExpand.display.ExpandMesh;

	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class LoadXmlData 
	{
		
		public function LoadXmlData() 
		{
			
		}
		
		private static var _pathArr:Array = [];
		private static var _nameArr:Array = [];
		private static var _textureArr:Array = [];
		private static var _gridArr:Array = [];
		
		private static var exportArr:Array = [];
		
		private static var _ctn:*;
		
		private static var _loaderXml:XML;     			//导入的XML
		public static function readXml(str:String, ctn:*,callBack:Function = null,callBackP:Array = null):void {
			_ctn = ctn;
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest(str));
			//将XML转换为数组形式
			loader.addEventListener(Event.COMPLETE, function (e:Event):void {
				loader.removeEventListener(Event.COMPLETE,arguments.callee);
				_loaderXml = new XML(e.target.data);
				loadComplete();
				if (callBack != null) {
					callBack.apply(null, callBackP);
				}
			})
		}
		
		//加载完成
		private static function loadComplete():void
		{
			_nameArr = Functions.stringToObject(_loaderXml["nameDatas"]) as Array;
			_pathArr = Functions.stringToObject(_loaderXml["pathDatas"]) as Array;
			_textureArr = Functions.stringToObject(_loaderXml["textureDatas"]) as Array;
			_gridArr = Functions.stringToObject(_loaderXml["nodeDatas"]) as Array;
			exportArr = Functions.stringToObject(_loaderXml["screenDatas"]) as Array;
			//return;
			for (var i:int = 0; i < exportArr.length; i++ ) {
				creatMeshByData(exportArr[i]);
			}
			
			
		}
		
		
		//====根据信息创建一个mesh对象
		private static function creatMeshByData(dataArr:Array):void
		{
			var name:String = _nameArr[dataArr[0][0]];
			var path:String = _pathArr[dataArr[0][1]];
			path = "d3d/res/assets/sea/scene/" + name;
			
			LoadSeaManage.loadSeaByCallBack(path, addSeaObj, [dataArr]);
		}
		
		//=============场景对象
		public static var sceneMeshArr:Vector.<ExpandMesh> = new Vector.<ExpandMesh>();
		public static function clearSceneMesh():void
		{
			for (var i:int = 0; i < sceneMeshArr.length; i++  ) {
				sceneMeshArr[i].deleteMe();
			}
			sceneMeshArr = new Vector.<ExpandMesh>();
		}
		
		private static function addSeaObj(m:ExpandMesh,dataArr:Array):void
		{
			m.loadMeshInfo(dataArr);
			trace(m.myName,m.name,"99999999999999999999999999999999999")
			_ctn.addChild(m);
			sceneMeshArr.push(m);
		}
		
		
		
		static public function get textureArr():Array 
		{
			return _textureArr;
		}
		
		static public function get gridArr():Array 
		{
			return _gridArr;
		}
		
	}

}