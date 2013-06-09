package sunag.sea3d.modules
{
	import away3d.primitives.WireframeCube;
	
	import sunag.sea3d.modules.objects.SEADummy;

	public class HelperModuleDebug extends HelperModule
	{
		override protected function readDummyObject(sea:SEADummy):WireframeCube
		{
			var dummy:WireframeCube = super.readDummyObject(sea);
			dummy.visible = true;
			return dummy;
		}
	}
}