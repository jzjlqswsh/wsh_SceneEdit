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
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.animators.transitions.CrossfadeTransition;
	
	import sunag.animation.Animation;
	import sunag.sunag;

	use namespace sunag;
	
	public class SkeletonAnimation extends Animation
	{
		protected var _animator:SkeletonAnimator;
		
		public function SkeletonAnimation(animator:SkeletonAnimator)
		{								
			_animator = animator;					
		}
			
		protected override function setAnimation(name:String, blendSpeed:Number):void
		{
			_animator.play(_currentAnimation=name, new CrossfadeTransition(_blendSpeed=blendSpeed));
		}
		
		override public function get currentDuration():Number
		{			
			return SkeletonClipNode( _animator.activeAnimation ).totalDuration;
		}
		
		public function set animator(value:SkeletonAnimator):void
		{
			_animator = value;
		}
		
		public function get animator():SkeletonAnimator
		{
			return _animator;
		}			
		
		override public function updateState():void 
		{
			// todo
		}
		
		override public function updateAnimation():void
		{
			_animator.update(_time);						
		}
	}
}