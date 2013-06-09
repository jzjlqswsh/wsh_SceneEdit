package awaybuilder.controller.scene
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.utils.scene.Scene3DManager;

	public class AddNewMeshCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var assets:AssetsModel;
		
		override public function execute():void
		{
			var oldValue:MeshVO = event.oldValue as MeshVO;
			var newValue:MeshVO = event.newValue as MeshVO;
			
			if( event.isUndoAction )
			{
				document.removeAsset( document.scene, oldValue );
				Scene3DManager.removeMesh( assets.GetObject(oldValue) as Mesh );
			}
			else 
			{
				document.scene.addItemAt( newValue, 0 );
				Scene3DManager.addObject( assets.GetObject(newValue) as ObjectContainer3D );
			}
			
			commitHistoryEvent( event );
		}
		
	}
}