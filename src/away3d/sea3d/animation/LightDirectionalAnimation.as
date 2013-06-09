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

package away3d.sea3d.animation
{
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	
	import sunag.animation.AnimationSet;
	import sunag.animation.data.AnimationFrame;
	import sunag.sunag;
	import sunag.utils.MathHelper;
	
	use namespace sunag;
	
	public class LightDirectionalAnimation extends LightAnimationBase
	{				
		public static const POSITION:String = "position";
		public static const ROTATION:String = "rotation";
	
		public static const COLOR:String = "color";
		public static const MULTIPLIER:String = "multiplier";
		
		public function LightDirectionalAnimation(animationSet:AnimationSet, light:DirectionalLight)
		{
			super(animationSet, light);
		}
		
		public override function set light(value:LightBase):void
		{			
			super.light = value as DirectionalLight;
		}
		
		override protected function updateAnimationFrame(frame:AnimationFrame, name:String):void			
		{
			switch(name)					
			{
				case POSITION:						
					_light.position = frame.toVector3D();
					break;							
				case ROTATION:
					_light.setRotationV3(MathHelper.quatToEuler(frame.toVector4D()));
					break;
				
				case COLOR:						
					_light.color = frame.x;				
					break;
				case MULTIPLIER:						
					_light.diffuse = frame.x;				
			}
		}				
	}
}