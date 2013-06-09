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
	import sunag.sunag;
	import sunag.utils.DataTable;
	
	use namespace sunag;
	
	public class SEAProperties extends SEAObject
	{
		public static const TYPE:String = "prop";
		
		public function SEAProperties(name:String, sea:SEA)
		{
			super(name, TYPE, sea);
		}
		
		public override function load():void
		{	
			tag = {};
			
			var attrib:int = data.readUnsignedByte();
			
			var count:int = attrib & 1 ? data.readUnsignedShort() :  data.readUnsignedByte();
			
			for(var i:int=0;i<count;i++)
			{
				var name:String = ByteArrayUtils.readUTFTiny(data);		
				tag[name] = DataTable.readObject(data);
			}
		}		
	}
}