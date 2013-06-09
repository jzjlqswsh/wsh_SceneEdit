package wshExpand.effect 
{
	import away3d.containers.View3D;
	import away3d.entities.Sprite3D;
	import away3d.materials.TextureMaterial;
	import away3d.utils.Cast;
	import caurina.transitions.Tweener;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import wshExpand.utils.Utils_away3d;
	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class Effect_sprite3D 
	{
		
		public function Effect_sprite3D() 
		{
			
		}
		
		
		public static function creatSprite3DEff():void
		{
			
		}
		
		
		public static function creatTextEff(ctn:*,textStr:String,initPos:Vector3D,endPos:Vector3D,showTime:Number = 1):void
		{
			//添加名字
			var text:TextField = new TextField();
			text.htmlText = textStr;
			text.width = text.textWidth;
			text.height = text.textHeight;
			text.autoSize = TextFieldAutoSize.CENTER;
			var changdu:int = Utils_away3d.getTwoPowerNumber(text.textWidth);
			var kuangdu:int = Utils_away3d.getTwoPowerNumber(text.textHeight);
			var textBmpData:BitmapData = new BitmapData(text.width,text.height, true, 0x0);
			textBmpData.draw(text);
			var useBmpData:BitmapData = new BitmapData(changdu, kuangdu, true, 0x0);
			useBmpData.copyPixels(textBmpData, textBmpData.rect, new Point((useBmpData.width - textBmpData.width)/2,(useBmpData.height - textBmpData.height)/2));
			
			var textMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(useBmpData));
			textMaterial.alphaBlending = true;
			var effObj:Sprite3D = new Sprite3D(textMaterial, changdu, kuangdu);
			effObj.position = initPos;
			ctn.addChild(effObj);
			Tweener.addTween(effObj, { time:1, x:endPos.x, y:endPos.y, z:endPos.z, onComplete:function():void { effObj.dispose() }} );
			//Tweener.addCaller(effObj, {onUpdate: function warn():void{trace("触发")}, time:5, count:10});
		}
		
		
	}

}