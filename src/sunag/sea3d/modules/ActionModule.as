package sunag.sea3d.modules
{
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.IPassMaterial;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.FogMethod;
	import away3d.primitives.SkyBox;
	
	import sunag.sea3d.SEA;
	import sunag.sea3d.SEA3D;
	import sunag.sea3d.modules.objects.SEAAction;
	import sunag.sunag;

	use namespace sunag;
	
	public class ActionModule extends ActionModuleBase
	{
		sunag var sea3d:SEA3D;
		
		protected var _skyBox:SkyBox;
		protected var _container:ObjectContainer3D;
		
		public function ActionModule()
		{			
			regRead(SEAAction.TYPE, readAction);
		}
		
		override sunag function reset():void
		{
			_skyBox = null;
			_container = sea3d.config.container;				
		}
		
		protected function applyMethod(method:EffectMethodBase):void
		{
			for each(var mat:IPassMaterial in sea3d.materials)
			{
				mat.addMethod(method);
			}
		}
		
		protected function readAction(sea:SEAAction):void
		{
			for each(var act:Object in sea.action)
			{
				switch (act.type)
				{
					case SEAAction.FOG:						
						applyMethod(new FogMethod(act.min, act.max, act.color));						
						break;
					
					case SEAAction.ENVIRONMENT:
						if (_skyBox) _skyBox.dispose();
						_container.addChild(_skyBox = new SkyBox(sea3d.objects[act.texture].tag));					
						break;
				}
			}
		}
		
		public function get skyBox():SkyBox
		{
			return _skyBox;
		}
		
		override sunag function init(sea:SEA):void
		{
			this.sea = sea;
			sea3d = sea as SEA3D;
		}
	}
}