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
	import away3d.audio.Sound3D;
	
	import sunag.animation.Animation;
	import sunag.animation.AnimationSet;
	import sunag.animation.data.AnimationFrame;
	import sunag.sunag;
	import sunag.utils.MathHelper;

	use namespace sunag;
	
	public class Sound3DAnimation extends Animation
	{
		protected var _sound3d:Sound3D;		
		
		public function Sound3DAnimation(animationSet:AnimationSet, sound3d:Sound3D)
		{
			super(animationSet);			
			_sound3d = sound3d;			
		}			
		
		public function set sound3d(value:Sound3D):void
		{
			_sound3d = value;
		}
		
		public function get sound3d():Sound3D
		{
			return _sound3d;
		}
		
		override protected function updateAnimationFrame(frame:AnimationFrame, kind:Object):void	
		{
			switch(kind)					
			{
				case Animation.VOLUME:						
					_sound3d.volume = frame.x;
					break;							
			}
		}				
	}
}