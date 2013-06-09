package wshExpand.sys 
{
	import away3d.animators.AnimatorBase;
	/**
	 * ...动画管理
	 * ...
	 * @author wangshuaihua
	 */
	public class AnimationManage 
	{
		private static var _instance:AnimationManage;
		static public function getInstance():AnimationManage 
		{
			if (!_instance) {
				_instance = new AnimationManage();
			}
			return _instance;
		}
		
		private var _animationArr:Vector.<AnimatorBase> = new Vector.<AnimatorBase>();
		public function get animationArr():Vector.<AnimatorBase> 
		{
			if (!_animationArr) {
				_animationArr = new Vector.<AnimatorBase>(); 
			}
			return _animationArr;
		}
		
		
		
		
		public function AnimationManage() 
		{
			
		}
		
		//刷新函数
		public function updataFrame():void
		{
			//trace(_animationArr.length,"444444444444")
			
		}
		
		public function addAnimation(anima:AnimatorBase):void
		{
			if (_animationArr.indexOf(anima) == -1) {
				_animationArr.push(anima);
			}else {
				throw new Error("该动画已经添加过")
			}
		}
		
		public function deleteAnimation(anima:AnimatorBase):void
		{
			if (_animationArr.indexOf(anima) != -1) {
				_animationArr.splice(_animationArr.indexOf(anima), 1);
			}else {
				trace("该动画不在数组中");
				//throw new Error("该动画不在数组中")
			}
		}
		
		public function deleteMe():void
		{
			_animationArr = new Vector.<AnimatorBase>(); 
		}
		
	}

}