package sunag.sea3d.config
{
	import away3d.lights.DirectionalLight;
	import away3d.lights.shadowmaps.CascadeShadowMapper;
	import away3d.lights.shadowmaps.NearDirectionalShadowMapper;
	import away3d.lights.shadowmaps.ShadowMapperBase;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.CascadeShadowMapMethod;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.materials.methods.FogMethod;
	import away3d.materials.methods.NearShadowMapMethod;
	import away3d.materials.methods.ShadowMapMethodBase;
	import away3d.materials.methods.SimpleShadowMapMethodBase;
	import away3d.materials.methods.SoftShadowMapMethod;
	
	import sunag.animation.AnimationBlendMethod;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	
	public class DefaultConfigBase implements IConfig
	{
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
		private var _cameraNear:Number = 1;
		private var _cameraFar:Number = 6000;
		private var _textureLimit:uint = 2048;
		private var _cubemapLimit:uint = 1024;
		private var _animationBlendMethod:uint = AnimationBlendMethod.LINEAR;
		
		public function DefaultConfigBase()
		{
			_shadowMethod = ShadowMethod.NEAR;
		}
		
		public function get lightPicker():StaticLightPicker
		{
			return _lightPicker || (_lightPicker = new StaticLightPicker([]))
		}
		
		public function set animationBlendMethod(value:uint):void
		{
			_animationBlendMethod = value;
		}
		
		public function get animationBlendMethod():uint
		{
			return _animationBlendMethod;
		}
		
		public function set cubemapLimit(value:uint):void
		{
			_cubemapLimit = value;
		}
		
		public function get cubemapLimit():uint
		{
			return _cubemapLimit;
		}
		
		public function set textureLimit(value:uint):void
		{
			_textureLimit = value;
		}
		
		public function get textureLimit():uint
		{
			return _textureLimit;
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
			return null;
		}
		
		public function creatColorMaterial():ColorMaterial
		{
			return null;
		}
		
		public function set smoothShadow(value:Boolean):void
		{
			_smoothShadow = value;
		}
		
		public function get smoothShadow():Boolean
		{
			return _smoothShadow;
		} 
		
		public function creatFog(min:Number, max:Number, color:uint):EffectMethodBase
		{
			return new FogMethod(min, max, color);
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
		
		public function set timeLimit(value:int):void
		{
			_timeLimit = value;
		}
		
		public function get timeLimit():int
		{
			return _timeLimit;
		}
	}
}