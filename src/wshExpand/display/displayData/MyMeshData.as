package wshExpand.display.displayData 
{
	import away3d.entities.Mesh;
	import wshExpand.display.ExpandMesh;
	import wshExpand.load.LoadSeaManage;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class MyMeshData 
	{
		
		public function MyMeshData() 
		{
		}
		private static var _expandMeshDic:Dictionary = new Dictionary();
		public static function getExpandMesh(path:String):ExpandMesh
		{
			if(!_expandMeshDic[path]){
				return null;
			}
			return ExpandMesh.cloneMe(_expandMeshDic[path]);
		}
		public static function addExpandMesh(path:String,mesh:ExpandMesh):void
		{
			_expandMeshDic[path] = mesh;
		}
		
		
		
		private static var _meshDataDic:Dictionary = new Dictionary();
		
		//存储mesh
		public static function addMeshData(name:String,index:int,meshName:String,mesh:Mesh):void
		{
			if (LoadSeaManage.getLoadState(name) == LoadSeaManage.LOADSTATE_NO) {
				return;
			}
			if (!_meshDataDic[name]) {
				_meshDataDic[name] = new Array();
			}
			if (!_meshDataDic[name][index]) {
				_meshDataDic[name][index] = new Dictionary();
			}
			if (!_meshDataDic[name][index][meshName]) {
				_meshDataDic[name][index][meshName] = new Vector.<Mesh>();
			}
			_meshDataDic[name][index][meshName].push(mesh)
		}
		//取mesh
		public static function getMeshData(name:String, index:int, meshName:String):Vector.<Mesh>
		{
			if (!_meshDataDic[name]) {
				throw new Error(name + "模型的资源文件尚未加载!");
			}
			if (!_meshDataDic[name][index]) {
				throw new Error(name + "第" + index + "套模型" + "的资源文件尚未加载!");
			}
			if (!_meshDataDic[name][index][meshName]) {
				throw new Error(name + "第" + index + "套模型 " + meshName + " 的资源文件尚未加载!");
			}
			var resurtMeshs:Vector.<Mesh> = new Vector.<Mesh>();
			for (var i:int = 0 ; i < _meshDataDic[name][index][meshName].length; i++ ) {
				resurtMeshs.push(_meshDataDic[name][index][meshName][i].clone());
			}
			return resurtMeshs;
		}
		
		
		//删除某对象
		public static function deleteMeshData(name:String):void
		{
			var arr:Array = _meshDataDic[name];
			if (!arr) {
				return;
			}
			for (var i:int = 0; i < arr.length; i++ ) {
				clearDicData(arr[i]);
			}
		}
		
		private static function clearDicData(dic:Dictionary):void
		{
			for (var i:* in dic) {
				if (dic[i] is Dictionary) {
					clearDicData(dic[i]);
				}else if(dic[i] is Mesh){
					(dic[i] as Mesh).dispose();
				}
				delete dic[i];
				dic[i] = null;
			}
			dic = null;
		}
		
	}

}