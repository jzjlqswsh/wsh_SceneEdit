package awaybuilder.desktop.controller
{
	import awaybuilder.controller.events.DocumentRequestEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.desktop.view.components.EditedDocumentWarningWindow;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.WindowModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class DocumentRequestCommand extends Command
	{
		[Inject]
		public var event:DocumentRequestEvent;
		
		[Inject]
		public var documentModel:DocumentModel;
		
		[Inject]
		public var windowModel:WindowModel;
		
		[Inject]
		public var mainWindow:AwayBuilderApplication;
		
		override public function execute():void
		{
			if(event.type == DocumentRequestEvent.REQUEST_CLOSE_DOCUMENT)
			{
				if(this.windowModel.isWaitingForClose)
				{
					//we're already asking the user to do something
					return;
				}
				this.windowModel.isWaitingForClose = true;
			}
			
			if(this.documentModel.edited)
			{
				//deselect all so that the window doesn't interfere
				this.dispatch(new SceneEvent(SceneEvent.SELECT_NONE));
				
				this.windowModel.savedNextEvent = this.event.nextEvent;
				
				var window:EditedDocumentWarningWindow = new EditedDocumentWarningWindow();
				this.mediatorMap.createMediator(window);
				
				window.open();
				window.nativeWindow.x = mainWindow.nativeWindow.x + (mainWindow.nativeWindow.width - window.nativeWindow.width) / 2;
				window.nativeWindow.y = mainWindow.nativeWindow.y + (mainWindow.nativeWindow.height - window.nativeWindow.height) / 2;
				return;
			}
			
			this.dispatch(this.event.nextEvent);
		}
	}
}