package away3d.morph
{
	import away3d.arcane;
	import away3d.core.base.Geometry;
	
	use namespace arcane;
	
	public class MorphRootNode extends MorphNode
	{
		public function MorphRootNode(geometry:Geometry)
		{
			super("root", geometry);
			_invalid = false;
		}
		
		override public function set name(value:String):void
		{
			throw new Error("Root node does not allow change name.");
		}
	}
}