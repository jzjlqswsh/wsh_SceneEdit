package sunag.sea3d.objects
{
	import sunag.sea3d.SEA;

	public class SEAGeometryBase extends SEAObject
	{
		public var attrib:uint;
		public var numVertex:uint;
		public var isBigMesh:Boolean = false;
		
		protected var readUint:Function;			
		
		public function SEAGeometryBase(name:String, type:String, sea:SEA)
		{
			super(name, type, sea);
		}	
		
		protected function readGeometryBase(data:*):void
		{
			attrib = data.readUnsignedShort();
			
			// StandardMesh or BigMesh 
			readUint = (isBigMesh = attrib & 1) ? data.readUnsignedInt : data.readUnsignedShort;
			
			numVertex = readUint();
		}
	}
}