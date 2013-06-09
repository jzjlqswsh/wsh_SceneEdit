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
	import sunag.sunag;
	import sunag.utils.DataTable;
	
	use namespace sunag;
	
	public class SEAAnimation extends SEAAnimationBase
	{
		public static const TYPE:String = "anm";
		
		public var dataList:Array;
		
		public function SEAAnimation(name:String, sea:SEA)
		{
			super(name, TYPE, sea);
		}
		
		override protected function readBody(data:ByteArray):void			
		{
			dataList = [];
			dataList.length = data.readUnsignedByte();
						
			for(var i:int=0;i<dataList.length;i++)
			{
				var kind:int = data.readUnsignedShort();
				var type:int = data.readUnsignedByte();
				var blockSize:int = DataTable.sizeOf(type);
				var anmRaw:Vector.<Number> = new Vector.<Number>(numFrames * blockSize);
				
				DataTable.readVector(type, data, anmRaw, numFrames);
				
				dataList[i] = 
					{
						kind:kind,
						type:type,	
						blockSize:blockSize,		
						data:anmRaw
					}
			}	
		}
	}
}