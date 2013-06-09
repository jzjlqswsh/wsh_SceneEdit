package wshExpand.sys 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class KeyboardManage 
	{
		
		private static var _instance:KeyboardManage;
		static public function getInstance():KeyboardManage 
		{
			if (!_instance) {
				_instance = new KeyboardManage();
			}
			return _instance;
		}
		
		private var _keyStateDic:Dictionary = new Dictionary();
		private var _keyDownControl:Dictionary = new Dictionary();
		
		public function KeyboardManage() 
		{
			
		}
		
		public function changeKeyState(keyCode:int,down:Boolean):void
		{
			_keyStateDic[keyCode] = down;
			if (!down) {
				_keyDownControl[keyCode] = down;
			}
		}
		
		public function getKeyState(keyCode:int):Boolean
		{
			return _keyStateDic[keyCode];
		}
		
		//判断一次按键 防止连续按键
		public function checkOnePress(keyCode:int):Boolean
		{
			if (getKeyState(keyCode) && !_keyDownControl[keyCode]) {
				_keyDownControl[keyCode] = true;
				return true;
			}
			return false;
		}
		
		
		public function initKeyState():void
		{
			_keyStateDic = new Dictionary();
			_keyDownControl = new Dictionary();
		}
		
		
		
	}

}