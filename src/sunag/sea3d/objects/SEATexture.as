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
	import sunag.sea3d.textures.Layer;
	import sunag.sea3d.textures.LayerBitmap;
	
	public class SEATexture extends SEAObject
	{
		public static const TYPE:String = "tex";
		
		public var layer:Vector.<Layer>; 
		public var firstLayer:LayerBitmap;
		public var multiChannel:Boolean = false;
		
		public function SEATexture(name:String, sea:SEA)
		{
			super(name, TYPE, sea);						
		}				
		
		public override function load():void
		{
			layer = new Vector.<Layer>(data.readUnsignedByte());	
			
			for(var i:int=0;i<layer.length;i++)
			{
				layer[i] = new Layer(data);	
				
				if (!multiChannel && layer[i].texture) multiChannel = layer[i].texture.channel > 0;
				if (!multiChannel && layer[i].mask) multiChannel = layer[i].mask.channel > 0;
							
				if (!firstLayer)
				{
					firstLayer = layer[i].texture;
				}
			}
		}
	}
}