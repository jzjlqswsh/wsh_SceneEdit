package sunag.sea3d.config
{
	import away3d.containers.ObjectContainer3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.shadowmaps.CascadeShadowMapper;
	import away3d.lights.shadowmaps.NearDirectionalShadowMapper;
	import away3d.lights.shadowmaps.ShadowMapperBase;
	import away3d.materials.ColorMaterial;
	import away3d.materials.IColorMaterial;
	import away3d.materials.ITextureMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.CascadeShadowMapMethod;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.materials.methods.NearShadowMapMethod;
	import away3d.materials.methods.ShadowMapMethodBase;
	import away3d.materials.methods.SimpleShadowMapMethodBase;
	import away3d.materials.methods.SoftShadowMapMethod;
	
	import sunag.animation.AnimationBlendMethod;
	
	public class DefaultConfig extends ConfigBase implements IConfig
	{
		private var _updateGlobalPose:Boolean = false;
		private var _smoothShadow:Boolean = true;
		private var _shadowMethod:String;
		private var _shadowMapper:ShadowMapperBase;
		private var _shadowMapMethod:ShadowMapMethodBase;
		private var _lightPicker:StaticLightPicker;
		private var _forceCPU:Boolean = false;
		private var _autoUpdate:Boolean = true;
		private var _enabledShadow:Boolean = true;
		private var _enabledFog:Boolean = true;			
		private var _timeLimit:int = 16;
		private var _disposePreloadedFiles:Boolean = true;
		private var _cameraNear:Number = 1;
		private var _cameraFar:Number = 6000;
		private var _animationBlendMethod:uint = AnimationBlendMethod.LINEAR;
		private var _container:ObjectContainer3D;
		private var _useContainer:Boolean = true;
		
		public function DefaultConfig()
		{
			_shadowMethod = ShadowMethod.NEAR;
		}
		
		public function get lightPicker():StaticLightPicker
		{
			return _lightPicker || (_lightPicker = new StaticLightPicker([]))
		}
		
		public function set lightPicker(val:StaticLightPicker):void
		{
			_lightPicker = val;
		}
		
		public function set animationBlendMethod(value:uint):void
		{
			_animationBlendMethod = value;
		}
		
		public function get animationBlendMethod():uint
		{
			return _animationBlendMethod;
		}
		
		public function set cameraNear(value:Number):void
		{
			_cameraNear = value;
		}
		
		public function get cameraNear():Number
		{
			return _cameraNear;
		}
		
		public function set cameraFar(value:Number):void
		{
			_cameraFar = value;
		}
		
		public function get cameraFar():Number
		{
			return _cameraFar;
		}
		
		public function set updateGlobalPose(value:Boolean):void
		{
			_updateGlobalPose = value;
		}
		
		public function get updateGlobalPose():Boolean
		{
			return _updateGlobalPose;
		}
		
		public function set autoUpdate(value:Boolean):void
		{
			_autoUpdate = value;
		}
		
		public function get autoUpdate():Boolean
		{
			return _autoUpdate;
		}
		
		public function set forceCPU(value:Boolean):void
		{
			_forceCPU = value;
		}
		
		public function get forceCPU():Boolean
		{
			return _forceCPU;
		}
		
		public function set shadowMethod(value:String):void
		{
			_shadowMethod = value;
		}
		
		public function get shadowMethod():String
		{						
			return _shadowMethod;
		}
		
		public function set enabledShadow(value:Boolean):void
		{
			_enabledShadow = value;
		}
		
		public function get enabledShadow():Boolean
		{
			return _enabledShadow;
		}
		
		public function set enabledFog(value:Boolean):void
		{
			_enabledFog = value;
		}
		
		public function get enabledFog():Boolean
		{
			return _enabledFog;
		}
		
		public function creatTextureMaterial():TextureMaterial
		{
			return new TextureMaterial();
		}
		
		public function creatColorMaterial():ColorMaterial
		{
			return new ColorMaterial();
		}
		
		public function set smoothShadow(value:Boolean):void
		{
			_smoothShadow = value;
		}
		
		public function get smoothShadow():Boolean
		{
			return _smoothShadow;
		} 
		
		public function getShadowMapper():ShadowMapperBase
		{
			if (_enabledShadow && !_shadowMapper)
			{
				if (_shadowMethod === ShadowMethod.NEAR)
					_shadowMapper = new NearDirectionalShadowMapper(.3);
				else if (_shadowMethod === ShadowMethod.CASCADE) 
					_shadowMapper = new CascadeShadowMapper(4);
			}
			
			return _shadowMapper;
		}
		
		public function getShadowMapMethod(light:DirectionalLight=null):ShadowMapMethodBase
		{
			if (_enabledShadow && !_shadowMapMethod)
			{
				var filter:SimpleShadowMapMethodBase;
				
				if (_smoothShadow) filter = new SoftShadowMapMethod(light as DirectionalLight, 6);
				else filter = new FilteredShadowMapMethod(light as DirectionalLight);
				
				if (_shadowMethod === ShadowMethod.NEAR)							
					_shadowMapMethod = new NearShadowMapMethod(filter);			
				else if (_shadowMethod === ShadowMethod.CASCADE)									
					_shadowMapMethod = new CascadeShadowMapMethod(filter);
			}
			
			return _shadowMapMethod;
		}
		
		public function set useContainer(value:Boolean):void
		{
			_useContainer = value;
		}
		
		public function get useContainer():Boolean
		{
			return _useContainer;
		}
		
		public function set container(value:ObjectContainer3D):void
		{
			_container = value;
		}
		
		/**
		 * Root of all children of the scene.
		 */
		public function get container():ObjectContainer3D
		{
			return _container || (_container = getContainer());
		}
		
		private function getContainer():ObjectContainer3D
		{
			if (!_useContainer) return null;
			
			_container = new ObjectContainer3D();
			_container.name = "root";
			
			return _container;
		}
		
		public function dispose(disposeContainer:Boolean=false):void
		{		
			if (_shadowMapper)
			{
				_shadowMapper.dispose();
				_shadowMapper = null;
			}
			
			if (_shadowMapMethod)
			{
				_shadowMapMethod.dispose();
				_shadowMapMethod = null;
			}
			
			_lightPicker = null;
						
			if (disposeContainer)
			{
				_container.dispose();
			}
		}
	}
}