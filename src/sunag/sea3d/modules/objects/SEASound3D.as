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

package sunag.sea3d.modules.objects
{
	import sunag.sunag;
	import sunag.sea3d.sounds.Sound3DBase;
	import sunag.sea3d.sounds.SoundPoint;
	import sunag.utils.ByteArray;
	import sunag.sea3d.SEA3D;
	import sunag.sea3d.objects.SEASceneObject;
	
	use namespace sunag;
	
	public class SEASound3D extends SEASceneObject
	{
		public static const TYPE:String = "sound3d";
		
		public var soundNS:String;
		public var autoPlay:Boolean;
		
		public var sound:Sound3DBase;
		
		public function SEASound3D(name:String, sea:SEA3D)
		{
			super(name, TYPE, sea);
		}
		
		protected override function read(data:ByteArray):void
		{
			super.read(data);
			
			soundNS = data.readUTFTiny();
			autoPlay = data.readBoolean();
			
			var type:String = data.readUTFTiny();						
			
			switch(type)
			{
				case "point":
					sound = SoundPoint.fromBytes(data);
					break;
				default:
					trace("Sound type not found:", type);
					break;
			}
		}		
	}
}