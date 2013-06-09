/*
*
* Copyright (c) 2013 Sunag Entertainment
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of
* this software and associated documentation files (the "Software"), to deal in
* the Software without restriction, including without limitation the rights to
* use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
* the Software, and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
* FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
* IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
*/

package sunag.utils
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	public class DataTable
	{		
		public static const NONE:int = 0;
		
		// 1D = 0 at 31
		public static const BOOLEAN:int = 1;
		
		public static const BYTE:int = 2;
		public static const UBYTE:int = 3;
		
		public static const SHORT:int = 4;
		public static const USHORT:int = 5;
		
		//public static const INT24:int = 6;
		public static const UINT24:int = 7;
		
		public static const INT:int = 8;
		public static const UINT:int = 9;
		
		public static const FLOAT:int = 10;
		public static const DOUBLE:int = 11;
		//public static const DECIMAL:int = 12;
		
		// 2D = 32 at 63
		
		// 3D = 64 at 95
		public static const VECTOR3D:int = 74;					
		
		// 4D = 96 at 127
		public static const VECTOR4D:int = 106;
		
		// Undefined Values = 128 at 256
		public static const STRING_TINY:int = 128;
		public static const STRING_SHORT:int = 129;
		public static const STRING_LONG:int = 130;
		
		// Max Size No Attributes
		public static const MAX_SIZE:uint = 4;
		
		public static const BLEND_MODE:Vector.<String> = Vector.<String>
			([
				"normal","add","multiply","alpha","screen","difference","darken",
				"colorburn","linearburn","lighten","colordodge","lineardodge","spotlight",
				"spotlightblend","overlay","softlight","hardlight","pinlight",
				"hardmix","difference","exclusion","average","hue","saturation","color","value","mix"
			]);
		
		public static function readObject(data:flash.utils.ByteArray):*
		{			
			return readToken(data.readUnsignedByte(), data);
		}
		
		public static function readToken(kind:int, data:flash.utils.ByteArray):*
		{						
			var size:int = sizeOf(kind);
						
			// 1D
			if (size == 1)
			{
				switch(kind)
				{
					case BOOLEAN:
						return data.readBoolean();
						break;
					
					case BYTE:
						return data.readByte();
						break;
					case UBYTE:
						return data.readUnsignedByte();
						break;
					
					case SHORT:
						return data.readShort();
						break;
					case USHORT:
						return data.readUnsignedShort();
						break;
					
					case UINT24:
						return ByteArrayUtils.readUnsignedInt24(data);
						break;	
					
					case INT:
						return data.readInt();
						break;
					case UINT:
						return data.readUnsignedInt();
						break;
					
					case FLOAT:
						return data.readFloat();
						break;
					case DOUBLE:
						return data.readDouble();
						break;					
				}
			}
			// 3D
			else if (size == 3)
			{
				switch(kind)
				{
					case VECTOR3D:
						return ByteArrayUtils.readVector3D(data);						
						break;											
				}
			}
			// 4D
			else if (size == 4)
			{
				switch(kind)
				{
					case VECTOR4D:
						return ByteArrayUtils.readVector4D(data);						
						break;
				}							
			}
			// Undefined Values
			else if (size == -1)
			{
				switch(kind)
				{
					case STRING_TINY:
						return ByteArrayUtils.readUTFTiny(data);						
						break;
					case STRING_SHORT:
						return data.readUTF();
						break;
					case STRING_LONG:
						return ByteArrayUtils.readUTFLong(data);						
						break;
				}
			}			
			
			return null;
		}
				
		public static function readVector(kind:int, data:flash.utils.ByteArray, out:Vector.<Number>, length:uint, offset:uint=0):void
		{			
			var size:int = sizeOf(kind);
		
			var i:uint = offset * size;
			var count:uint = i + (length * size);
			
			// 1D
			if (size == 1)
			{
				switch(kind)
				{
					case BOOLEAN:
						while (i < count) out[i++] = data.readBoolean() ? 1 : 0;						
						break;
					
					case BYTE:
						while (i < count) out[i++] = data.readByte();
						break;
					case UBYTE:
						while (i < count) out[i++] = data.readUnsignedByte();						
						break;
					
					case SHORT:
						while (i < count) out[i++] = data.readShort();						
						break;
					case USHORT:
						while (i < count) out[i++] = data.readUnsignedShort();							
						break;
					
					case UINT24:
						while (i < count) out[i++] = ByteArrayUtils.readUnsignedInt24(data);						
						break;	
					
					case INT:
						while (i < count) out[i++] = data.readInt();						
						break;
					case UINT:
						while (i < count) out[i++] = data.readUnsignedInt();						
						break;
					
					case FLOAT:
						while (i < count) out[i++] = data.readFloat();						
						break;
					case DOUBLE:
						while (i < count) out[i++] = data.readDouble();						
						break;
				}
			}
			// 3D
			else if (size == 3)
			{
				switch(kind)
				{
					case VECTOR3D:
						while (i < count) 		
						{
							out[i++] = data.readFloat();
							out[i++] = data.readFloat();
							out[i++] = data.readFloat();							
						}
						break;											
				}
			}
			// 4D
			else if (size == 4)
			{
				switch(kind)
				{
					case VECTOR4D:
						while (i < count) 	
						{
							out[i++] = data.readFloat();
							out[i++] = data.readFloat();
							out[i++] = data.readFloat();
							out[i++] = data.readFloat();
						}
						break;
				}							
			}
		}				
		
		public static function sizeOf(kind:int):int
		{
			if (kind == 0) return 0;
			else if (kind >= 1 && kind <= 31) return 1;
			else if (kind >= 32 && kind <= 63) return 2;
			else if (kind >= 64 && kind <= 95) return 3;
			else if (kind >= 96 && kind <= 125) return 4;			
			return -1;
		}
	}
}