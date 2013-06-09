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

package sunag.sea3d.modules.objects
{
	import flash.utils.ByteArray;
	
	import sunag.sea3d.SEA;
	import sunag.sea3d.objects.SEAObject3D;
	import sunag.utils.ByteArrayUtils;
	import sunag.sunag;
	
	use namespace sunag;
	
	public class SEASound3DBase extends SEAObject3D
	{
		public static const TYPE:String = "s3d";
		
		public var soundNS:String = "";
		public var autoPlay:Boolean;
		
		public var sound:uint;
		public var volume:Number;
		
		public function SEASound3DBase(name:String, type:String, sea:SEA)
		{
			super(name, type, sea);
		}
		
		protected override function read(data:ByteArray):void
		{
			super.read(data);
			
			var type:uint;
			
			autoPlay = (attrib & 256) != 0;
			
			if (attrib & 512) soundNS = ByteArrayUtils.readUTFTiny(data);
			
			sound = data.readUnsignedInt();
			volume = data.readFloat();
		}		
	}
}