package away3d.texture
{
	import away3d.arcane;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.events.Object3DEvent;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.PlanarReflectionTexture;
	
	import flash.geom.Matrix;
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