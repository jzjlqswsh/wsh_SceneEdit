package sunag.utils
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.getQualifiedClassName;
	

	public class ByteArrayUtils
	{
		//
		//	READER
		//
		
		public static function readUnsignedInt24(data:IDataInput):uint
		{
			return data.readUnsignedByte() | 
				data.readUnsignedByte() << 8 | 
				data.readUnsignedByte() << 16;
		}
		
		public static function readUTFTiny(data:IDataInput):String
		{
			return data.readUTFBytes(data.readUnsignedByte());
		}
		
		public static function readUTFLong(data:IDataInput):String
		{
			return data.readUTFBytes(data.readUnsignedInt());
		}
		
		public static function readVector3D(data:IDataInput):Vector3D
		{
			return new Vector3D
			(
				data.readFloat(),
				data.readFloat(),
				data.readFloat()
			);
		}
		
		public static function readVector4D(data:IDataInput):Vector3D
		{
			return new Vector3D
			(
				data.readFloat(),
				data.readFloat(),
				data.readFloat(),
				data.readFloat()
			);
		}
		
		public static function readMatrix3DVector(data:IDataInput):Vector.<Number>
		{
			var v:Vector.<Number> = new Vector.<Number>(16, true);
			
			v[0] = data.readFloat();
			v[1] = data.readFloat();
			v[2] = data.readFloat();
			v[3] = 0;
			v[4] = data.readFloat();
			v[5] = data.readFloat();
			v[6] = data.readFloat();
			v[7] = 0;
			v[8] = data.readFloat();
			v[9] = data.readFloat();
			v[10] = data.readFloat();
			v[11] = 0;
			v[12] = data.readFloat();
			v[13] = data.readFloat();
			v[14] = data.readFloat();
			v[15] = 1;
			
			return v;
		}
		
		public static function readMatrix3D(data:IDataInput):Matrix3D
		{
			return new Matrix3D(readMatrix3DVector(data));
		}
		
		public static function readBlendMode(data:IDataInput):String
		{
			return DataTable.BLEND_MODE[data.readUnsignedByte()];
		}
		
		public static function typeInt(type:String):uint
		{
			var bytes:flash.utils.ByteArray = new flash.utils.ByteArray();
			trace(getQualifiedClassName(bytes),"88888888888888")
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.writeUnsignedInt(0x00000000);
			bytes.position = 0;
			bytes.writeUTFBytes(type);
			bytes.position = 0;
			return bytes.readUnsignedInt();
		}
		
		//
		//	WRITER
		//
		
		public static function writeUnsignedInt24(data:IDataOutput, val:uint):void
		{
			data.writeByte(0xFF & val);
			data.writeByte(0xFF & (val >> 8));
			data.writeByte(0xFF & (val >> 16));		
		}
		
		public static function writeUTFTiny(data:IDataOutput, val:String):void
		{
			var bytes:flash.utils.ByteArray = new flash.utils.ByteArray();
			trace(getQualifiedClassName(bytes),"88888888888888")
			bytes.writeUTFBytes(val);
			
			data.writeByte(bytes.length);
			data.writeBytes(bytes);	
		}
	}
}