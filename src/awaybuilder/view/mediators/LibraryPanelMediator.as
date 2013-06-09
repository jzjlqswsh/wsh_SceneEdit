package awaybuilder.view.mediators
{
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.VertexAnimationSet;
	import away3d.animators.VertexAnimator;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.lights.DirectionalLight;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.SkyBox;
	import awaybuilder.model.vo.scene.ExpandMeshVO;
	
	import awaybuilder.controller.document.events.ImportTextureEvent;
	import awaybuilder.controller.events.DocumentEvent;
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.events.DocumentRequestEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.DeleteStateVO;
	import awaybuilder.model.vo.DocumentVO;
	import awaybuilder.model.vo.DroppedTreeItemVO;
	import awaybuilder.model.vo.LibraryItemVO;
	import awaybuilder.model.vo.scene.AnimationSetVO;
	import awaybuilder.model.vo.scene.AnimatorVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.CameraVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.CubeTextureVO;
	import awaybuilder.model.vo.scene.EffectMethodVO;
	import awaybuilder.model.vo.scene.GeometryVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.ObjectVO;
	import awaybuilder.model.vo.scene.ShadowMapperVO;
	import awaybuilder.model.vo.scene.ShadowMethodVO;
	import awaybuilder.model.vo.scene.SkeletonVO;
	import awaybuilder.model.vo.scene.SkyBoxVO;
	import awaybuilder.model.vo.scene.TextureProjectorVO;
	import awaybuilder.utils.AssetUtil;
	import awaybuilder.utils.DataMerger;
	import awaybuilder.utils.ScenegraphFactory;
	import awaybuilder.utils.scene.Scene3DManager;
	import awaybuilder.view.components.LibraryPanel;
	import awaybuilder.view.components.controls.tree.TreeDataProvider;
	import awaybuilder.view.components.editors.events.PropertyEditorEvent;
	import awaybuilder.view.components.events.LibraryPanelEvent;
	
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.utils.ObjectUtil;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.collections.Sort;

	public class LibraryPanelMediator extends Mediator
	{
		
		private var _animations:ArrayCollection;
		private var _geometry:ArrayCollection;
		private var _materials:ArrayCollection;
		private var _scene:ArrayCollection;
		private var _skeletons:ArrayCollection;
		private var _textures:ArrayCollection;
		private var _lights:ArrayCollection;
		private var _methods:ArrayCollection;
		
		[Inject]
		public var view:LibraryPanel;
		
		[Inject]
		public var document:DocumentModel;
		
		[Inject]
		public var assets:AssetsModel;
		
		private var _model:DocumentVO;
		
		private var _selectedSceneItems:Vector.<Object> = new Vector.<Object>();
		private var _selectedMaterialsItems:Vector.<Object> = new Vector.<Object>();
		private var _selectedTexturesItems:Vector.<Object> = new Vector.<Object>();
		private var _selectedGeometryItems:Vector.<Object> = new Vector.<Object>();
		private var _selectedMethodsItems:Vector.<Object> = new Vector.<Object>();
		private var _selectedAnimationsItems:Vector.<Object> = new Vector.<Object>();
		private var _selectedLightsItems:Vector.<Object> = new Vector.<Object>();
		
		override public function onRegister():void
		{
			addViewListener(LibraryPanelEvent.TREE_CHANGE, view_treeChangeHandler);
			
			addViewListener(LibraryPanelEvent.ADD_GEOMETRY, view_addGeometryHandler);
			addViewListener(LibraryPanelEvent.ADD_MESH, view_addMeshHandler);
			//addViewListener(LibraryPanelEvent.ADD_CONTAINER, view_addContainerHandler);
			addViewListener(LibraryPanelEvent.ADD_EXPANDMESH, view_addExpandMeshHandler);
			
			addViewListener(LibraryPanelEvent.ADD_SKYBOX, view_addSkyBoxHandler);
			
			addViewListener(LibraryPanelEvent.SCENEOBJECT_DROPPED, view_sceneObjectDroppedHandler);
			
			addContextListener(DocumentModelEvent.OBJECTS_UPDATED, eventDispatcher_documentUpdatedHandler);
			addContextListener(DocumentModelEvent.DOCUMENT_CREATED, eventDispatcher_documentCreatedHandler);
			addContextListener(DocumentModelEvent.OBJECTS_FILLED, eventDispatcher_objectsFilledHandler);
			addContextListener(SceneEvent.CHANGE_LIGHTPICKER, eventDispatcher_changeHandler);
			
			addContextListener(SceneEvent.VALIDATE_DELETION, context_validateDeletionHandler);
			
			addContextListener(SceneEvent.SELECT, context_itemsSelectHandler);
			
		}
		
		//----------------------------------------------------------------------
		//
		//	view handlers
		//
		//----------------------------------------------------------------------
		
		
		private function view_sceneObjectDroppedHandler(event:LibraryPanelEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.REPARENT_OBJECTS,[], event.data));		
		}
		
		private function itemIsInList( collection:ArrayCollection, asset:AssetVO ):Boolean
		{
			for each( var a:AssetVO in collection )
			{
				if( a.equals( asset ) ) return true;
			}
			return false;
		}
		
		private function view_addGeometryHandler(event:LibraryPanelEvent):void
		{
			var asset:GeometryVO = assets.CreateGeometry( event.data as String );
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_GEOMETRY,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		
		private function view_addSkyBoxHandler(event:LibraryPanelEvent):void
		{
			var asset:SkyBoxVO = assets.CreateSkyBox();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_SKYBOX,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		
		private function view_addExpandMeshHandler(event:LibraryPanelEvent):void
		{
			var asset:ExpandMeshVO = assets.CreateExpandMesh("../assets/meiz_mesh_1.sea");
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_EXPANDMESH,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}
		/*private function view_addContainerHandler(event:LibraryPanelEvent):void
		{
			var asset:ContainerVO = assets.CreateContainer();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_CONTAINER,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}*/
		private function view_addMeshHandler(event:LibraryPanelEvent):void
		{
			if( !document.geometry.length )
			{
				var asset1:GeometryVO = assets.CreateGeometry( "CubeGeometry" );
				this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_GEOMETRY,null,asset1));
				this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset1]));
				/*Alert.show( "To create a Mesh, you need Geometry", "Cancelled" );
				return;*/
			}
			var asset:MeshVO = assets.CreateMesh( document.geometry.getItemAt(0) as GeometryVO );
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_MESH,null,asset));
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[asset]));
		}


		
		
		private var _doNotUpdate:Boolean = false;
		private function view_treeChangeHandler(event:LibraryPanelEvent):void
		{
			var items:Array = [];
			var selectedItems:Vector.<Object> = event.data as Vector.<Object>;
			
			for (var i:int=0;i<selectedItems.length;i++)
			{
				items.push(LibraryItemVO(selectedItems[i]).asset);
			}
			_doNotUpdate = true;
			this.dispatch(new SceneEvent(SceneEvent.SELECT,items));
			
		}
		
		//----------------------------------------------------------------------
		//
		//	context handlers
		//
		//----------------------------------------------------------------------
		
		private function context_validateDeletionHandler(event:SceneEvent):void
		{
			var states:Vector.<DeleteStateVO> = new Vector.<DeleteStateVO>();
			var item:LibraryItemVO;
			for each( item in view.sceneTree.selectedItems )
			{
				states.push( new DeleteStateVO( item.asset, item.parent?item.parent.asset:null ) );
			}
			for each( item in view.geometryTree.selectedItems )
			{
				states.push( new DeleteStateVO( item.asset, item.parent?item.parent.asset:null ) );
			}
			
			var additionalStates:Vector.<DeleteStateVO> = new Vector.<DeleteStateVO>();
			var assetsList:Vector.<AssetVO>;
			var asset:AssetVO;
			for each( var state:DeleteStateVO in states )
			{
				if( state.asset is ShadowMethodVO )
				{
					assetsList = document.getAssetsByType( MaterialVO, materialsWithShadowMethodFilterFunciton, state.asset );
					for each( asset in assetsList )
					{
						additionalStates.push( new DeleteStateVO( state.asset, asset ) );
					}
					
				}
				if( state.asset is LightVO )
				{
					assetsList = document.getAssetsByType( LightPickerVO, lightPickersWithLightFilterFunciton, state.asset );
					for each( asset in assetsList )
					{
						additionalStates.push( new DeleteStateVO( state.asset, asset ) );
					}
					assetsList = document.getAssetsByType( MaterialVO, materialsWithLightFilterFunciton, state.asset );
					for each( asset in assetsList )
					{
						additionalStates.push( new DeleteStateVO( state.asset, asset ) );
					}
					
				}
			}
			
			
			this.dispatch(new SceneEvent(SceneEvent.DELETE, null, states.concat( additionalStates )));
			
		}
		
		private function materialsWithShadowMethodFilterFunciton( asset:MaterialVO, filter:AssetVO ):Boolean
		{
			return (asset.shadowMethod == filter);
		}
		private function materialsWithLightFilterFunciton( asset:MaterialVO, filter:AssetVO ):Boolean
		{
			return (asset.light == filter);
		}
		private function lightPickersWithLightFilterFunciton( asset:LightPickerVO, filter:AssetVO ):Boolean
		{
			for each( var light:LightVO in asset.lights )
			{
				if( light.equals( filter ) )  return true;
			}
			return false;
		}
		
		public function removeAsset( source:ArrayCollection, oddItem:AssetVO ):void
		{
			for (var i:int = 0; i < source.length; i++) 
			{
				if( source[i].id == oddItem.id )
				{
					source.removeItemAt( i );
					i--;
				}
			}
		}
		private function eventDispatcher_changeHandler(event:SceneEvent):void
		{
			updateScenegraph();
		}
		
		private function eventDispatcher_objectsFilledHandler(event:DocumentModelEvent):void
		{
			view.sceneTree.expandAll();
		}
		private function eventDispatcher_documentCreatedHandler(event:DocumentModelEvent):void
		{
			updateScenegraph();
		}
		
		private function eventDispatcher_documentUpdatedHandler(event:DocumentModelEvent):void
		{
			updateScenegraph();
		}
		
		private function context_itemsSelectHandler(event:SceneEvent):void
		{
			if( _doNotUpdate ) 
			{
				_doNotUpdate = false;
				return;
			}
			
			_selectedSceneItems = new Vector.<Object>();
			_selectedMaterialsItems = new Vector.<Object>();
			_selectedTexturesItems = new Vector.<Object>();
			_selectedGeometryItems = new Vector.<Object>();
			_selectedMethodsItems = new Vector.<Object>();
			_selectedAnimationsItems = new Vector.<Object>();
			_selectedLightsItems = new Vector.<Object>();
			updateAllSelectedItems( view.model.scene, event.items.concat(), _selectedSceneItems  );
			updateAllSelectedItems( view.model.materials, event.items.concat(), _selectedMaterialsItems );
			updateAllSelectedItems( view.model.textures, event.items.concat(), _selectedTexturesItems );
			updateAllSelectedItems( view.model.geometry, event.items.concat(), _selectedGeometryItems );
			updateAllSelectedItems( view.model.methods, event.items.concat(), _selectedMethodsItems );
			updateAllSelectedItems( view.model.animations, event.items.concat(), _selectedAnimationsItems );
			view.selectedSceneItems = _selectedSceneItems;
			view.selectedMaterialsItems = _selectedMaterialsItems;
			view.selectedTexturesItems = _selectedTexturesItems;
			view.selectedGeometryItems = _selectedGeometryItems;
			view.selectedMethodsItems = _selectedMethodsItems;
			view.selectedAnimationsItems = _selectedAnimationsItems;
			view.selectedLightsItems = _selectedLightsItems;
			view.callLater( ensureIndexIsVisible );
		}
		
		//----------------------------------------------------------------------
		//
		//	private methods
		//
		//----------------------------------------------------------------------
		
		private function ensureIndexIsVisible():void 
		{
			if( view.sceneTree.selectedIndex )
			{
				view.callLater( view.sceneTree.ensureIndexIsVisible, [view.sceneTree.selectedIndex] );	
			}
			
		}
		private function updateAllSelectedItems( children:ArrayCollection, selectedItems:Array, currentSelcted:Vector.<Object>, alreadySelected:Vector.<Object>=null ):void
		{
			if( alreadySelected )
			{
				
				for each( var alreadySelectedItem:LibraryItemVO in alreadySelected )
				{
					for( var i:int = 0; i < selectedItems.length; i++ )
					{
						if( AssetVO(selectedItems[i]).equals( alreadySelectedItem.asset ) )
						{
							currentSelcted.push( alreadySelectedItem );
							selectedItems.splice( i, 1 );
							i--;
						}
					}
				}
			}
			for each( var item:LibraryItemVO in children )
			{
				if( item.asset )
				{
					if( getItemIsSelected( item.asset.id, selectedItems ) )
					{
						currentSelcted.push( item );
					}
				}
				if( item.children ) 
				{
					updateAllSelectedItems( item.children, selectedItems, currentSelcted );
				}
			}
		}
		private function getItemIsSelected( id:String, selectedItems:Array ):Boolean
		{
			for each( var object:AssetVO in selectedItems )
			{
				if( object.id == id )
				{
					return true;
				}
			}
			return false;
		}
		private function updateScenegraph():void
		{
			view.model.scene = DataMerger.syncArrayCollections( view.model.scene, ScenegraphFactory.CreateBranch( document.scene, null ), "asset" );
			view.model.materials = DataMerger.syncArrayCollections( view.model.materials, ScenegraphFactory.CreateBranch( document.materials, null ), "asset" );
			view.model.animations = DataMerger.syncArrayCollections( view.model.animations, ScenegraphFactory.CreateBranch( document.animations, null ), "asset" );
			view.model.methods = DataMerger.syncArrayCollections( view.model.methods,  ScenegraphFactory.CreateBranch( document.methods, null ), "asset" );
			view.model.textures = DataMerger.syncArrayCollections( view.model.textures,  ScenegraphFactory.CreateBranch( document.textures, null ), "asset" );
			view.model.geometry = DataMerger.syncArrayCollections( view.model.geometry, ScenegraphFactory.CreateBranch( document.geometry, null ), "asset" );
			view.model.lights = DataMerger.syncArrayCollections( view.model.lights, ScenegraphFactory.CreateLightsBranch( document.lights ), "asset" );
		}
		
	}
}