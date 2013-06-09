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
	import sunag.sea3d.environment.Background;
	import sunag.sea3d.environment.BackgroundColor;
	import sunag.sea3d.environment.CubeMapBackground;
	import sunag.sea3d.environment.Fog;
	import sunag.sea3d.environment.TextureBackground;
	import sunag.utils.ByteArray;
	import sunag.sea3d.SEA3D;
	
	public class SEAEnvironment extends SEANode
	{
		public static const TYPE:String = "env";
		
		public var background:Background;
		public var fog:Fog;
		
		public function SEAEnvironment(name:String, sea:SEA3D)
		{
			super(name, TYPE, sea);					
		}
		
		protected override function read(data:ByteArray):void
		{
			super.read(data);
		}
		
		protected override function readToken(name:String, data:ByteArray):Boolean
		{
			if (super.readToken(name, data))
				return true;
			
			switch(name)
			{
				case "background":
					readBackground(data);
					break;
				case "fog":
					readFog(data);
					break;
			}
			
			return true;
		}
		
		private function readFog(data:ByteArray):void
		{
			fog = new Fog(data.readFloat(), data.readFloat(), data.readUnsignedInt24());
		}
		
		private function readBackground(data:ByteArray):void
		{
			var type:String = data.readUTFTiny();
			
			switch(type)
			{
				case "color":
					background = new BackgroundColor(data.readUnsignedInt24());
					break;
				
				case "background":
					background = new TextureBackground(data.readUTFTiny());
					break;
				
				case "cubemap":
					background = new CubeMapBackground(data.readUTFTiny());
					break;
			}
			
			var bg:Background = new Background();
			
			//background = new Background(data.readUTFTiny(), data.readUTFTiny());
		}
	}
}