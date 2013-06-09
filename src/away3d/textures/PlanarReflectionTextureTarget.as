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

package away3d.textures
{
	import away3d.arcane;
	import away3d.containers.ObjectContainer3D;
	import away3d.events.Object3DEvent;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	use namespace arcane;
	
	public class PlanarReflectionTextureTarget extends PlanarReflectionTexture
	{
		private var _target:ObjectContainer3D;
		private var _yUp:Boolean = false;
		private var _yUpMatrix:Matrix3D;
		
		public function PlanarReflectionTextureTarget(target:ObjectContainer3D=null, yUp:Boolean=true)
		{			
			super();
			
			this.yUp = yUp;
			this.target = target;
		}
		
		public function set yUp(value:Boolean):void
		{
			if (_yUp == value) return;
			
			if ((_yUp = value))
			{
				_yUpMatrix = new Matrix3D();
				_yUpMatrix.appendRotation(90, Vector3D.X_AXIS);
			}
			else _yUpMatrix = null;
		}
		
		public function get yUp():Boolean
		{
			return _yUp;
		}
		
		private function onChangeTransform(e:Object3DEvent):void
		{
			_applyTransform();		
		}
		
		private function _applyTransform():void
		{
			if (_yUp)
			{
				var matrix:Matrix3D = _target.transform.clone();				
				matrix.prepend(_yUpMatrix);								
				
				if (_target.parent && !_target.parent._isRoot)
					matrix.prepend(_target.parent.sceneTransform);
				
				applyTransform(matrix);
			}
			else
			{
				applyTransform(_target.sceneTransform);
			}						
		}
		
		public function set target(value:ObjectContainer3D):void
		{
			if (_target == value) return;
			
			if (_target)
			{
				_target.removeEventListener(Object3DEvent.POSITION_CHANGED, onChangeTransform);
				_target.removeEventListener(Object3DEvent.ROTATION_CHANGED, onChangeTransform);
			}
									
			if ((_target = value))
			{								
				_target.addEventListener(Object3DEvent.POSITION_CHANGED, onChangeTransform, false, 0, true);
				_target.addEventListener(Object3DEvent.ROTATION_CHANGED, onChangeTransform, false, 0, true);
				
				_applyTransform();
			}
		}
		
		public function get target():ObjectContainer3D			
		{
			return _target;
		}
		
		public override function dispose():void
		{
			this.target = null;
			super.dispose();
			
		}
	}
}