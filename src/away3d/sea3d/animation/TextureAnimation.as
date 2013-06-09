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
	import away3d.core.base.SubMesh;
	import away3d.core.math.MathConsts;
	
	import sunag.animation.Animation;
	import sunag.animation.AnimationSet;
	import sunag.animation.data.AnimationFrame;
	import sunag.sunag;
	import sunag.utils.MathHelper;
	
	use namespace sunag;
	
	public class TextureAnimation extends Animation
	{
		protected var _subMesh:SubMesh;
		
		public function TextureAnimation(animationSet:AnimationSet, subMesh:SubMesh)
		{
			super(animationSet);			
			_subMesh = subMesh;
		}
		
		public function set subMesh(value:SubMesh):void
		{
			_subMesh = value;
		}
		
		public function get subMesh():SubMesh
		{
			return _subMesh;
		}
		
		override protected function updateAnimationFrame(frame:AnimationFrame, kind:Object):void		
		{
			switch(kind)					
			{
				case Animation.OFFSET_U:						
					_subMesh.offsetU = frame.x;					
					break;							
				case Animation.OFFSET_V:
					_subMesh.offsetV = frame.x;
					break;					
				case Animation.SCALE_U:						
					_subMesh.scaleU = frame.x;		
					break;
				case Animation.SCALE_V:						
					_subMesh.scaleV = frame.x;
					break;
				case Animation.ANGLE:					
					_subMesh.uvRotation = frame.x * MathConsts.DEGREES_TO_RADIANS;
					break;
			}
		}				
	}
}