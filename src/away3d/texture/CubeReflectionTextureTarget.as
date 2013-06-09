package away3d.texture
{
	import away3d.arcane;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.events.Object3DEvent;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.CubeReflectionTexture;
	import away3d.textures.PlanarReflectionTexture;
	import away3d.tools.helpers.MeshHelper;
	
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	use namespace arcane;
	
	public class CubeReflectionTextureTarget extends CubeReflectionTexture
	{
		private var _target:ObjectContainer3D;
		private var _offset:Vector3D;		
		
		public function CubeReflectionTextureTarget(size:int, target:ObjectContainer3D=null)
		{			
			super(size);			
			this.target = target;
		}
		
		public function updateBounds():void			
		{
			_offset = new Vector3D
				(
					(_target.minX+_target.maxX)*.5,
					(_target.minY+_target.maxY)*.5,
					(_target.minZ+_target.maxZ)*.5
				);					
		}
		
		private function onChangePosition(e:Object3DEvent=null):void
		{			
			position = _target.scenePosition.add(_offset);
		}
		
		public function set target(value:ObjectContainer3D):void
		{
			if (_target == value) return;
			
			if (_target)
			{
				_target.removeEventListener(Object3DEvent.POSITION_CHANGED, onChangePosition);
			}
									
			if ((_target = value))
			{				
				_target.addEventListener(Object3DEvent.POSITION_CHANGED, onChangePosition, false, 0, true);
				
				updateBounds();
				
				onChangePosition();
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