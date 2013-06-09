package awaybuilder.controller.clipboard
{
	import away3d.core.base.Object3D;
	import away3d.entities.Mesh;
	
	import awaybuilder.controller.clipboard.events.ClipboardEvent;
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.ObjectVO;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;

	public class CopyCommand extends Command
	{
		
		[Inject]
		public var document:DocumentModel;
		
		[Inject]
		public var assets:AssetsModel;
		
		[Inject]
		public var event:ClipboardEvent;
		
		override public function execute():void
		{
			if( !document.selectedAssets || (document.selectedAssets.length == 0))
			{
				return;
			}
			
			var copiedObjects:Vector.<AssetVO> = new Vector.<AssetVO>();
			for each( var vo:AssetVO in document.selectedAssets )
			{
				var asset:MeshVO = vo as MeshVO;
				if( asset )
				{
					var newObject:Object3D = assets.GetObject( asset ) as Object3D;
					copiedObjects.push( asset.clone() );
				}
				
			}
			document.copiedObjects = copiedObjects;
			if(event.type == ClipboardEvent.CLIPBOARD_CUT)
			{
				this.dispatch(new SceneEvent(SceneEvent.VALIDATE_DELETION, [] ));
			}
		}
	}
}