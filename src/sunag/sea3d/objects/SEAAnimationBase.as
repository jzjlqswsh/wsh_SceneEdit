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

	use namespace sunag;
	
	public class SEAAnimationBase extends SEAObject
	{
		public var frameRate:int;
		public var numFrames:int;
		public var sequence:uint;	
		public var useSequence:Boolean;
		
		public function SEAAnimationBase(name:String, type:String, sea:SEA)
		{
			super(name, type, sea);
		}
		
		public function get duration():uint
		{
			return numFrames * frameRate;
		}
		
		public override function load():void
		{
			var flag:int = data.readUnsignedByte();			
			
			if (useSequence = flag & 1)
				sequence = data.readUnsignedInt();
			
			frameRate = data.readUnsignedByte();
			numFrames = data.readUnsignedInt();		
			
			readBody(data);
		}
		
		public function getRootSequence():Object
		{
			return {name:"root",start:0,count:numFrames,repeat:true,intrpl:true};
		}
		
		protected function readBody(data:ByteArray):void{};
		
		/*
		public function get intTimeScale():Number
		{	
			return int(1000 / frameRate) / (1000 / frameRate);
		}
		*/
	}
}