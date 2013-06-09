package sunag.sea3d.modules
{
	import sunag.sea3d.modules.objects.SEAData;
	import sunag.sea3d.modules.objects.SEAScript;
	import sunag.sunag;

	use namespace sunag;
	
	public class MetadataModule extends ModuleBase
	{
		public function MetadataModule()
		{
			regClass(SEAData);
			regClass(SEAScript);
		}		
	}
}