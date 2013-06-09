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

package sunag.sea3d.object3d
{
	import flash.geom.Vector3D;
	
	import sunag.utils.ByteArray;

	public class LookAt
	{		
		public var object3d:String;
		public var upAxis:Vector3D;
		public var offset:Vector3D;
		
		public static function fromBytes(bytes:ByteArray):LookAt
		{
			var lookAt:LookAt = new LookAt(); 
			
			var type:int = bytes.readUnsignedByte();			
			
			lookAt.object3d = bytes.readUTFTiny();			
			
			if ((type & 8) != 0)
			{
				lookAt.offset = bytes.readVector3D();
				type -= 8;
			}									
			
			lookAt.upAxis = typeToAxis(type);
			
			return lookAt;
		}
		
		public static function typeToAxis(type:int):Vector3D
		{
			switch(type)
			{
				case 1:
					return Vector3D.X_AXIS;
					break;
				
				case 2:
					return Vector3D.Y_AXIS;
					break;
				
				case 3:
					return Vector3D.Z_AXIS;
					break;
			}
			
			return null;
		}
	}
}