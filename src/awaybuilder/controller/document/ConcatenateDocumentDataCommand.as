package awaybuilder.controller.document
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.lights.LightBase;
	import away3d.primitives.SkyBox;
	
	import awaybuilder.controller.events.DocumentDataOperationEvent;
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.DocumentVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.SkyBoxVO;
	import awaybuilder.utils.scene.CameraManager;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	
	import spark.components.Application;

	public class ConcatenateDocumentDataCommand extends HistoryCommandBase
	{
		[Inject]
		public var assets:AssetsModel;
		
		[Inject]
		public var event:DocumentDataOperationEvent;
		
		private var _sceneObjects:Array;
		
		override public function execute():void
		{
			if( event.isUndoAction )
			{
				undo(); 
				return;
			}
			var data:DocumentVO = event.newValue as DocumentVO;
			addObjects( data.scene.source.concat() );
			addLights( data.lights.source.concat() );
			document.animations = new ArrayCollection(document.animations.source.concat( data.animations.source ));
			document.geometry = new ArrayCollection(document.geometry.source.concat( data.geometry.source ));
			document.materials = new ArrayCollection(document.materials.source.concat( data.materials.source ));
			document.scene = new ArrayCollection(document.scene.source.concat( data.scene.source ));
//			document.skeletons = new ArrayCollection(document.skeletons.source.concat( data.skeletons.source ));
			document.textures = new ArrayCollection(document.textures.source.concat( data.textures.source ));
			document.lights = new ArrayCollection(document.lights.source.concat( data.lights.source ));
			
			document.methods = new ArrayCollection(document.methods.source.concat( data.methods.source ));
			
			document.empty = false;
			
			if( event.canUndo ) 
			{
				addToHistory( event );
			}
			else
			{
				document.name = data.name;
			}
			
			CursorManager.setBusyCursor();
			Application(FlexGlobals.topLevelApplication).mouseEnabled = false;
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.OBJECTS_UPDATED));
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.OBJECTS_FILLED));
			
		}
		
		private function undo():void
		{
			var data:DocumentVO = event.oldValue as DocumentVO;
			for each( var vo:AssetVO in data.scene ) {
				if( vo is MeshVO ) {
					Scene3DManager.removeMesh( assets.GetObject(vo) as Mesh );
				}
			}
			removeItems( document.animations, data.animations );
			removeItems( document.geometry, data.geometry );
			removeItems( document.materials, data.materials );
			removeItems( document.scene, data.scene );
//			removeItems( document.skeletons, data.skeletons );
			removeItems( document.textures, data.textures );
			removeItems( document.lights, data.lights );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.OBJECTS_UPDATED));
		}
		
		private function removeItems( source:ArrayCollection, items:ArrayCollection ):void
		{
			for (var i:int = 0; i < source.length; i++) 
			{
				var item:AssetVO = source[i] as AssetVO;
				for each( var oddItem:AssetVO in items ) 
				{
					if( item.equals( oddItem ) )
					{
						source.removeItemAt( i );
						i--;
					}
				}
			}
		}
		
		private function addLights( objects:Array ):void 
		{
			for (var i:int = 0; i < objects.length; i++) 
			{
				addLight( objects.shift() );
				i--;
			}
		}
		private function addObjects( objects:Array ):void 
		{
			_sceneObjects = objects.concat();
			DisplayObject(FlexGlobals.topLevelApplication).addEventListener( Event.ENTER_FRAME, addNextObject_enterFrameHandler );
		}
		private function addNextObject_enterFrameHandler( event:Event ):void 
		{
			if( _sceneObjects.length == 0 )
			{
				CursorManager.removeBusyCursor();			
				DisplayObject(FlexGlobals.topLevelApplication).removeEventListener( Event.ENTER_FRAME, addNextObject_enterFrameHandler );
				
				Application(FlexGlobals.topLevelApplication).mouseEnabled = true;
				CameraManager.focusTarget();
				
				return;
			}
			for (var i:int = 0; i < 10; i++) 
			{
				addObject( _sceneObjects.shift() );
			}
			
		}
		private function addObject( value:Object ):void
		{
			var o:ContainerVO = value as ContainerVO;
			if( o ) 
			{
				Scene3DManager.addObject( assets.GetObject(o) as ObjectContainer3D );
			}
			var skyBox:SkyBoxVO = value as SkyBoxVO;
			if( skyBox ) 
			{
				Scene3DManager.addSkybox( assets.GetObject(skyBox) as SkyBox );
			}
		}
		private function addLight( value:Object ):void
		{
			var light:LightVO = value as LightVO;
			if( light ) 
			{
				Scene3DManager.addLight( assets.GetObject(light) as LightBase );
			}
		}
//		private function addTextureProjector( value:Object ):void
//		{
//			var textureProjector:TextureProjectorVO = value as TextureProjectorVO;
//			if( TextureProjectorVO ) 
//			{
//				var projectorBitmap:BitmapData = textureProjector.texture.bitmapData;
//				Scene3DManager.addTextureProjector( assets.GetObject(textureProjector) as TextureProjector, projectorBitmap );
//			}
//		}
		
	}
}