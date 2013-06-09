package sunag.sea3d.config
{
	import away3d.materials.ColorMultiPassMaterial;
	import away3d.materials.IColorMaterial;
	import away3d.materials.ITextureMaterial;
	import away3d.materials.TextureMultiPassMaterial;

	public class MultiPassConfig extends DefaultConfig
	{		
		override public function creatTextureMaterial():ITextureMaterial
		{
			return new TextureMultiPassMaterial();
		}
		
		override public function creatColorMaterial():IColorMaterial
		{
			return new ColorMultiPassMaterial();
		}		
	}
}