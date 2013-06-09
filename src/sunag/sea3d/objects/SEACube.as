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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import sunag.sea3d.SEA;
	
	public class SEACube extends SEACubeBase
	{
		public static const TYPE:String = "cube";
		
		public var ext:String;
		public var faces:Vector.<ByteArray>;		
		public var facesBitmap:Vector.<BitmapData>;
		
		private var _callback:Function;
		private var facesLoader:Vector.<Loader>;
		
		public function SEACube(name:String, sea:SEA)
		{
			super(name, TYPE, sea);
		}
		
		public function loadCube(callback:Function):void
		{
			_callback = callback;
			
			facesBitmap = new Vector.<BitmapData>(6, true);
			facesLoader = new Vector.<Loader>(6, true);
			
			for(var i:int = 0; i < 6; i++)
			{
				facesLoader[i] = new Loader();
				facesLoader[i].contentLoaderInfo.addEventListener(Event.COMPLETE, onCubeBitmap);
				facesLoader[i].loadBytes(faces[i]);
			}
		}
		
		private function onCubeBitmap(e:Event):void
		{								
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, onCubeBitmap);
			
			var index:int = facesLoader.indexOf( (e.target as LoaderInfo).loader );									
			
			facesBitmap[index] = (facesLoader[index].content as Bitmap).bitmapData;			
			facesLoader[index].unload();
			
			for(var i:int = 0; i < 6; i++)
				if (!facesBitmap[i]) return;
			
			facesLoader = null;
			
			_callback(this);
			_callback = null;	
		}
		
		public override function load():void
		{
			ext = data.readUTFBytes(4);
			
			faces = new Vector.<ByteArray>(6, true);
			
			for(var i:int = 0; i < 6; i++)
			{
				var size:uint = data.readUnsignedInt();
				faces[i] = new ByteArray();			
				faces[i].writeBytes(data, data.position, size);			
				data.position += size;		
			}			
		}
	}
}