/*
*
* Copyright (c) 2012 Sunag Entertainment
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

	public class ByteArray extends flash.utils.ByteArray
	{
		public function ByteArray(bytes:flash.utils.ByteArray=null)
		{
			if (bytes)
			{
				writeBytes(bytes);
				position = 0;
			}
		}
		
		public function readVector3D():Vector3D
		{
			return new Vector3D
			(
				readFloat(),
				readFloat(),
				readFloat()
			);
		}
		
		public function readVector4D():Vector3D
		{
			var quat:Vector3D = new Vector3D
				(
					readFloat(),
					readFloat(),
					readFloat(),
					readFloat()
				);
			
			return quat;
		}
		
		public function readUnsignedInt24():uint
		{
			var r:int = readUnsignedByte();
			var g:int = readUnsignedByte();
			var b:int = readUnsignedByte();
			
			return r << 16 | g << 8 | b;
		}						
		
		public function readUTFTiny():String
		{			
			return readUTFBytes(readUnsignedByte());
		}
		
		public function readUTFLong():String
		{			
			return readUTFBytes(readUnsignedInt());
		}
		
		public function split(offset:uint=0, length:uint=0):sunag.utils.ByteArray
		{
			var bytes:sunag.utils.ByteArray = new sunag.utils.ByteArray();
			bytes.writeBytes(this, offset, length);
			bytes.position = 0;
			return bytes;
		}
	}
}