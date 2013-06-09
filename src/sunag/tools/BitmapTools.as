package sunag.tools
{
	import away3d.textures.BitmapCubeTexture;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	
	import sunag.utils.MathHelper;

	public class BitmapTools
	{
		public static function isCubemap(bitmapData:BitmapData):Boolean
		{
			return (bitmapData.height * 6) === bitmapData.width;
		}
		
		public static function getPowerOfTwoBitmapData(bitmapData:BitmapData, limit:uint=2048):BitmapData
		{
			return powerOfTwoBitmapData(bitmapData, limit, false);
		}
		
		private static function powerOfTwoBitmapData(bitmapData:BitmapData, limit:uint=2048, dispose:Boolean=true):BitmapData
		{
			var bitmap:Bitmap = creatBitmap(bitmapData);
			
			limit = MathHelper.upperPowerOfTwo(limit);
			
			if (
				bitmapData.width != bitmapData.height || 
				MathHelper.upperPowerOfTwo(bitmapData.width) != bitmapData.width ||
				bitmapData.width > limit
			)
			{
				var msize:int = bitmapData.width;
				if (bitmapData.height > msize) msize = bitmapData.height;
				
				var size:uint = MathHelper.upperPowerOfTwo(msize);
				
				if (size > limit) size = limit;
				
				bitmap.width = bitmap.height = size;
				
				var data:BitmapData = new BitmapData(size, size, true, 0);				
				data.draw(bitmap, bitmap.transform.matrix);
				
				if (dispose) bitmapData.dispose();
				
				return data;
			}
			
			return bitmapData;
		}
		
		public static function getCubeMap(bitmapData:BitmapData, faceLimit:uint=1024):Vector.<BitmapData>
		{
			const faces:int = 6;
			
			var rootBitmap:Bitmap = creatBitmap(bitmapData);	
			var data:Vector.<BitmapData> = new Vector.<BitmapData>();
			
			var height:int = MathHelper.upperPowerOfTwo(bitmapData.height);
			var width:int = height * 6;			
			
			faceLimit = MathHelper.upperPowerOfTwo(faceLimit);			
			
			rootBitmap.width = width;
			rootBitmap.height = height;
			
			for(var i:int=0;i<faces;i++)
			{
				var bitmap:BitmapData = new BitmapData(height, height, false, 0x00);
				bitmap.draw(rootBitmap, new Matrix(rootBitmap.scaleX,0,0,rootBitmap.scaleY,-height * i));
				data[i] = powerOfTwoBitmapData(bitmap, faceLimit);
			}
			
			return data;
		}
		
		private static function creatBitmap(bitmapData:BitmapData):Bitmap
		{
			return new Bitmap(bitmapData, PixelSnapping.AUTO, true);
		}
			
	}
}