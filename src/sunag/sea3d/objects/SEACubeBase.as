package sunag.sea3d.objects
{
	import sunag.sea3d.SEA;
	
	public class SEACubeBase extends SEAObject
	{
		public static const TYPE:String = "cube";
		
		public function SEACubeBase(name:String, type:String, sea:SEA)
		{
			super(name, type, sea);
		}
	}
}