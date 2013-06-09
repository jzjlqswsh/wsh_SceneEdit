package wshExpand.display.displayData 
{
	import flash.utils.Dictionary;
	import wshExpand.utils.Functions;
	/**
	 * ...资源数据   角色 和 武器 等部件
	 * @author wangshuaihua
	 */
	public class AssetsData 
	{
		//[Embed(source = "/res/assets/config/assetsPath.xml", mimeType = "application/octet-stream")]
		private static var _xml_1:Class;
		
		public function AssetsData() 
		{
			
		}
		public static var defaultMeshName:String = "defaultSurface"
		
		private static function initXml():void
		{
			var configXml:XML = XML(new _xml_1());
			_assetsPathDic = Functions.stringToObject(configXml["nameDatas"]);
		}
		
		private static var _initHave:Boolean;
		static public function get assetsPathDic():Object 
		{
			if (!_initHave) {
				_initHave = true;
				initXml();
			}
			return _assetsPathDic;
		}
		
		private static var _assetsPathDic:Object = 
		{
			player_1	: {index_0:	{
								animator: ["man_10.sea"],
								mesh	: ["defaultSurface.sea"],
								clip	: ["player_1_attack.sea", "player_1_run.sea"]
							}
						}		
		}
		
		//======得到武器的动作数组
		public static function getWeaponActionArr(name:String,bujianType:String,bujianName:String):Array
		{
			var path:String = "d3d/res/assets/sea/" + name + "/"+bujianType+"/"+bujianName+"/";
			var arr:Array = assetsPathDic[name][bujianType][bujianName];
			return [path, arr];
		}
		
		
		//根据序号 得到mesh名称
		public static function getMeshNameByIndex(name:String,index:int,meshIndex:int):String
		{
			var arr:Array = getAssetsArrOneSkeletonByType(name, index, ASSETSTYPE_MESH)[1];
			var str:String = arr[meshIndex - 1];
			return str.slice(0, str.length - 4);
		}
		
		
		//得到一个角色的必须加载数组
		public static function getNeedAssetsArr(name:String):Array
		{
			var arr:Array = [];
			var obj:Object = assetsPathDic[name];
			var objInfo:Object;
			var index:int;
			for (var i:String in obj) {
				if (i != "weapon") {
					index = i.split("_").pop();
					arr[index]= getNeedAssetsArrOneSkeleton(name, index);
				}
			}
			return arr;
		}
		
		//得到一套骨骼的必须加载数据
		private static function getNeedAssetsArrOneSkeleton(name:String,index:int):Array
		{
			var obj:Object = assetsPathDic[name]["index_"+index];
			var path:String = "d3d/res/assets/sea/" + name + "/index_" + index+"/";
			var animatorArr:Array = [path + "animator/", [obj["animator"]]];
			var meshArr:Array = [path + "mesh/", obj["mesh"][0]];
			var clipArr:Array = [path + "clip/", obj["clip"]];
			return [animatorArr, meshArr, clipArr];
		}
		
		public static const ASSETSTYPE_MESH:String = "mesh";
		public static const ASSETSTYPE_ANIMATOP:String = "animator";
		public static const ASSETSTYPE_CLIP:String = "clip";
		
		
		//得到某套骨骼的某类的所有文件
		private static function getAssetsArrOneSkeletonByType(name:String,index:int,type:String):Array
		{
			var obj:Object = assetsPathDic[name]["index_"+index];
			var path:String = "d3d/res/assets/sea/" + name + "/index_" + index + "/";
			if (type == ASSETSTYPE_MESH) {
				return [path + "mesh/", obj["mesh"]];
			}else if (type == ASSETSTYPE_ANIMATOP) {
				return [path + "animator/", obj["animator"]];
			}else if (type == ASSETSTYPE_CLIP) {
				return [path + "clip/", obj["clip"]];
			}
			return null;
		}
		
		//得到一个动作需要加载的文件
		public static function getActionAssets(name:String,actionName:String):Array
		{
			var arr:Array = [];
			var obj:Object = assetsPathDic[name];
			var index:int;
			var path:String;
			var actionArr:Array;
			var fileName:String;
			for (var i:String in obj) {
				if (i != "weapon") {
					index = i.split("_").pop();
					actionArr = getAssetsArrOneSkeletonByType(name, index, ASSETSTYPE_CLIP);
					for (var j:int = 0; j < actionArr[1].length; j++ ) {
						fileName = actionArr[1][j];
						fileName = fileName.slice(0, fileName.length - 4);
						if (fileName.split("_").pop() == actionName) {
							path = actionArr[0] + actionArr[1][j];
							arr.push([index,path]);
						}
					}
				}
				
			}
			return arr;
		}
		
		//得到骨骼套数
		public static function getSkeletonNum(name:String):int
		{
			var num:int = 0;
			var obj:Object = assetsPathDic[name];
			for (var i:String in obj) {
				if (i == "weapon") {
					continue;
				}
				num++;
			}
			return num;
		}
		
	}

}