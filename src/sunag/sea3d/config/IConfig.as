package sunag.sea3d.config
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.shadowmaps.ShadowMapperBase;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.ShadowMapMethodBase;

	public interface IConfig extends IConfigBase
	{
		function set updateGlobalPose(value:Boolean):void;
		function get updateGlobalPose():Boolean;
		
		function set cameraNear(value:Number):void;
		function get cameraNear():Number;
		
		function set cameraFar(value:Number):void;
		function get cameraFar():Number;
		
		function set forceCPU(value:Boolean):void;
		function get forceCPU():Boolean;		
		
		function set enabledShadow(value:Boolean):void;
		function get enabledShadow():Boolean;	
		
		function set enabledFog(value:Boolean):void;
		function get enabledFog():Boolean;	
		
		function set autoUpdate(value:Boolean):void;
		function get autoUpdate():Boolean;	
		
		function set animationBlendMethod(value:uint):void;
		function get animationBlendMethod():uint;
		
		function creatTextureMaterial():TextureMaterial;
		function creatColorMaterial():ColorMaterial;
		
		function getShadowMapper():ShadowMapperBase;
		function getShadowMapMethod(light:DirectionalLight=null):ShadowMapMethodBase;
		
		function set lightPicker(val:StaticLightPicker):void;
		function get lightPicker():StaticLightPicker;	
						
		function set container(value:ObjectContainer3D):void;	
		function get container():ObjectContainer3D;
	}
}