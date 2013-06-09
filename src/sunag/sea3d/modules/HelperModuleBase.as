package sunag.sea3d.modules
{
	import sunag.sea3d.modules.objects.SEADummy;
	import sunag.sea3d.modules.objects.SEALine;
	import sunag.sea3d.modules.objects.SEATarget;
	import sunag.sunag;

	use namespace sunag;
	
	public class HelperModuleBase extends ModuleBase
	{
		public function HelperModuleBase()
		{			
			regClass(SEALine);			
			regClass(SEATarget);			
			regClass(SEADummy);
		}		
	}
}