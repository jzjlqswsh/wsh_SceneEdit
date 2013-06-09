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

package sunag.sea3d.objects
{
	import flash.utils.ByteArray;
	
	import sunag.sea3d.SEA;
	import sunag.utils.ByteArrayUtils;
	
	public class SEALight extends SEAObject3D
	{
		public static const TYPE:String = "lht";
		
		public var color:uint;
		public var multiplier:Number;
		public var shadow:Object;
		public var ambient:Number = 1;
		public var ambientColor:int = 0xFFFFFF;		
		public var attenStart:Number = Number.MAX_VALUE;
		public var attenEnd:Number = Number.MAX_VALUE;
		
		public function SEALight(name:String, type:String, sea:SEA)
		{
			super(name, type, sea);
		}
		
		protected override function read(data:ByteArray):void
		{
			super.read(data);	
			
			if (attrib & 256)		
			{
				var shadowHeader:uint = data.readUnsignedByte();
												
				shadow = {};
				
				if (shadowHeader & 1)			
					shadow.opacity = data.readFloat(); // opacity
				
				if (shadowHeader & 2)			
					shadow.color = ByteArrayUtils.readUnsignedInt24(data); // color
				
			}		
			
			if (attrib & 512)
			{
				attenStart = data.readFloat();
				attenEnd = data.readFloat();
			}
						
			color = ByteArrayUtils.readUnsignedInt24(data);
			multiplier = data.readFloat();						
		}
	}
}