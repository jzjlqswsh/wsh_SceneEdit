package wshExpand.display.displayData 
{
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import wshExpand.load.LoadSeaManage;
	import wshExpand.skeletonExpand.SkeletonDatas;
	import flash.utils.Dictionary;
	import wshExpand.sys.AnimationManage;
	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class MySkeletonData 
	{
		
		public function MySkeletonData() 
		{
			
		}
		
		//================================骨骼动画数据  
		private static var skeletonAnimatorDic:Dictionary = new Dictionary();
		//存骨骼动画数据
		public static function addSkeletonAnimator(name:String,index:int,animator:SkeletonAnimator,actionName:String = null):void
		{
			if (LoadSeaManage.getLoadState(name) == LoadSeaManage.LOADSTATE_NO) {
				return;
			}
			if (actionName) {
				name += "_" + actionName;
			}
			if (!skeletonAnimatorDic[name]) {
				skeletonAnimatorDic[name] = [];
			}
			animator.autoUpdate = false;
			
			skeletonAnimatorDic[name][index] = animator;
			SkeletonDatas.initSkeletonAnimator(animator);
		}
		
		
		//根据名字拿骨骼
		public static function getSkeletonAnimatorByName(name:String,index:int = 0,isClone:Boolean = true):SkeletonAnimator
		{
			//var tempSkeletonAnimator:SkeletonAnimator = skeletonAnimatorDic[name];
			if (!skeletonAnimatorDic[name]) {
				throw new Error(name+"的资源文件尚未加载!")
			}
			if (!skeletonAnimatorDic[name][index]) {
				throw new Error(name+"第"+index+"套骨骼"+"的资源文件尚未加载!")
			}
			if (isClone) {
				var anima:SkeletonAnimator = skeletonAnimatorDic[name][index] as SkeletonAnimator;
				var anima2:SkeletonAnimator = anima.clone() as SkeletonAnimator;
				anima2.autoUpdate = false;
				AnimationManage.getInstance().addAnimation(anima2);	//加入刷新
				return anima2;
			}else {
				return skeletonAnimatorDic[name][index] as SkeletonAnimator;
			}
		}
		
		
		//============================骨骼动作数据
		private static var skeletonClipNodeDic:Dictionary = new Dictionary();
		//存动作
		public static function addSkeletonClipNode(name:String,index:int,actionName:String,clipNode:SkeletonClipNode):void
		{
			if (LoadSeaManage.getLoadState(name) == LoadSeaManage.LOADSTATE_NO) {
				return;
			}
			if (!skeletonClipNodeDic[name]) {
				skeletonClipNodeDic[name] = new Array();
			}
			if (!skeletonClipNodeDic[name][index]) {
				skeletonClipNodeDic[name][index] = new Dictionary();
			}
			skeletonClipNodeDic[name][index][actionName] = clipNode;
		}
		//取动作
		public static function getSkeletonClipNode(name:String, index:int, actionName:String):SkeletonClipNode
		{
			if (!skeletonClipNodeDic[name]) {
				throw new Error(name+"的资源文件尚未加载!")
			}
			if (!skeletonClipNodeDic[name][index]) {
				throw new Error(name+"第"+index+"套动画"+"的资源文件尚未加载!")
			}
			if (!skeletonClipNodeDic[name][index][actionName]) {
				throw new Error(name+"第"+index+"套动画 "+ actionName+" 的资源文件尚未加载!")
			}
			return skeletonClipNodeDic[name][index][actionName];
		}
		
		//删除动作
		private static function deleteClipNodes(name:String):void
		{
			if (!skeletonClipNodeDic[name]) {
				return;
			}
			var dic:Dictionary;
			for (var i:int = 0; i < skeletonClipNodeDic[name].length; i++ ) {
				dic = skeletonClipNodeDic[name][i];
				if (!dic) {
					continue;
				}
				for (var j:* in dic) {
					(dic[j] as SkeletonClipNode).dispose();
				}
			}
			skeletonClipNodeDic[name] = null;
		}
		
		
		
		
		//删除动画
		public static function deleteSkeletonAnimator(name:String):void
		{
			var animator:SkeletonAnimator;
			if (skeletonAnimatorDic[name]) {
				for (var i:int = 0; i < skeletonAnimatorDic[name].length; i++ ) {
					animator = skeletonAnimatorDic[name][i] as SkeletonAnimator;
					if (animator) {
						SkeletonDatas.deleteSkeletonData(animator);
						(animator.animationSet as SkeletonAnimationSet).dispose();
						animator.dispose();
					}
				}
				skeletonAnimatorDic[name] = null;
				delete skeletonAnimatorDic[name];
			}
			
			deleteClipNodes(name);
		}
		//==========================动作pos数据
		
		
		
		
		
		
	}

}