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

package sunag.sea3d.objects
{
	import sunag.utils.ByteArray;
	import sunag.sea3d.SEA3D;
	
	public class SEANode extends SEAObject
	{
		private var _sea3d:SEA3D;
		
		public function SEANode(name:String, type:String, sea:SEA3D)
		{
			super(name, type, _sea3d=sea);										
		}
		
		override public function load(data:ByteArray):void
		{
			read(data);			
			
			var numTag:int = data.readUnsignedByte();
			
			for (var i:int=0;i<numTag;++i)
			{
				var name:String = data.readUTFTiny();
				var size:uint = data.readUnsignedInt();				
				var position:uint = data.position;
				
				if (!readToken(name, data))
					trace("Token not found:", name, "Object:", this.name);
				
				data.position = position += size; 
			}	
		}
		
		public function get sea3d():SEA3D
		{
			return _sea3d;
		}
		
		protected function read(data:ByteArray):void
		{
			
		}
		
		protected function readToken(name:String, data:ByteArray):Boolean
		{
			return false;
		}
	}
}