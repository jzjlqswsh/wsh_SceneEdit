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

package sunag.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	
	public class BitmapUtils
	{ 
		public static function powerOfTwoBitmapData(bitmapData:BitmapData, limit:uint=2048):BitmapData
		{
			if (
				MathHelper.nearestPowerOfTwo(bitmapData.height) != bitmapData.height || 
				MathHelper.nearestPowerOfTwo(bitmapData.width) != bitmapData.width ||
				bitmapData.width > limit
			)
			{
				var bitmap:Bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
				
				var msize:int = bitmapData.width;
				if (bitmapData.height > msize) msize = bitmapData.height;
				
				var size:uint = MathHelper.nearestPowerOfTwo(msize);
				
				if (size > limit) size = limit;
				
				bitmap.width = bitmap.height = size;
				
				var data:BitmapData = new BitmapData(size, size, bitmapData.transparent, 0);								
				data.draw(bitmap, bitmap.transform.matrix); 
				
				return data;
			}
			
			return bitmapData;
		}
	}
}