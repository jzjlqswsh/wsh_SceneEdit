package wshExpand.display.displayData 
{
	import away3d.materials.TextureMaterial;
	import flash.utils.Dictionary;
	/**
	 * ...材质
	 * @author wangshuaihua
	 */
	public class MyMaterialData 
	{
		
		public function MyMaterialData() 
		{
			
		}
		
		private static var _materialDic:Dictionary = new Dictionary();
		public static function getMaterial(path:String):TextureMaterial
		{
			return _materialDic[path];
		}
		public static function addMaterial(path:String,material:TextureMaterial):void
		{
			_materialDic[path] = material;
		}
		
		
		
		
		
	}

}