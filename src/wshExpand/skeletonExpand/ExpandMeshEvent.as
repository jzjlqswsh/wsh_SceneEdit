package wshExpand.skeletonExpand 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class ExpandMeshEvent extends Event 
	{
		
		//加载sea完成
		public static const LOADSEA_COMPLETE:String = "loadsea_complete";
		
		
		
		//==========动作结束
		public static var ACTION_COMPLETE:String = "action_complete";
		
		
		
		
		
		
		
		
		
		
		
		public var infoObj:*;
		public function ExpandMeshEvent(type:String,obj:* = null) 
		{
			super(type);
			infoObj = obj;
		}
		
	}

}