package wshExpand.display.displayData 
{
	import flash.utils.Dictionary;
	import wshExpand.display.ExpandMesh;
	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class MyWeaponMeshData 
	{
		
		public function MyWeaponMeshData() 
		{
			
		}
		
		
		private static var _weaponMeshDic:Dictionary = new Dictionary();
		
		public static function addWeaponMesh(name:String,weaponName:String,actionName:String,mesh:ExpandMesh):void
		{
			if (!_weaponMeshDic[name]) {
				_weaponMeshDic[name] = new Dictionary();
			}
			if (!_weaponMeshDic[name][weaponName]) {
				_weaponMeshDic[name][weaponName] = new Dictionary();
			}
			_weaponMeshDic[name][weaponName][actionName] = mesh;
		}
		
		public static function getWeaponMesh(name:String,weaponName:String,actionName:String):ExpandMesh
		{
			if (!_weaponMeshDic[name]) {
				throw new Error(name + "武器的资源文件尚未加载!");
			}
			if (!_weaponMeshDic[name][weaponName]) {
				throw new Error(name + "的"+weaponName+"武器的资源文件尚未加载!");
			}
			return _weaponMeshDic[name][weaponName][actionName];
		}
		
		
	}

}