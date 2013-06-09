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
	import flash.utils.Endian;
	
	import sunag.sea3d.SEA;
	import sunag.sea3d.objects.SEAObject;
	import sunag.sunag;
	
	use namespace sunag;
	
	public class SEAScript extends SEAObject
	{
		public static const TYPE:String = "src";
		
		public static const UNKNOWN:int = 0;
		public static const STRING:int = 1;
		public static const BYTECODE:int = 2;
		
		public var language:String;
		
		public var format:int; 
		
		public function SEAScript(name:String, sea:SEA)
		{
			super(name, TYPE, sea);
		}
		
		public override function load():void
		{
			format = data.readUnsignedByte();
			language = data.readUTFBytes(3);					
			
			var length:uint = data.readUnsignedInt();
			
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			bytes.writeBytes(data, data.position, length);
			
			data = bytes;
		}		
	}
}