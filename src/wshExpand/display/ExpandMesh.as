package wshExpand.display 
{
	import away3d.animators.AnimatorBase;
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.VertexAnimationSet;
	import away3d.animators.VertexAnimator;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.animators.states.AnimationClipState;
	import away3d.animators.transitions.IAnimationTransition;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.Object3D;
	import away3d.core.pick.IPickingCollider;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.events.AnimationStateEvent;
	import away3d.events.MouseEvent3D;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.utils.Cast;
	

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import wshExpand.control.Abstract_basic;
	import wshExpand.display.displayData.AssetsData;
	import wshExpand.display.displayData.MyMaterialData;
	import wshExpand.display.displayData.MyMeshData;
	import wshExpand.display.displayData.MySkeletonData;
	import wshExpand.load.LoadSeaManage;
	import wshExpand.load.LoadXmlData;
	import wshExpand.skeletonExpand.ExpandMeshEvent;
	import wshExpand.skeletonExpand.SkeletonDatas;
	import wshExpand.sys.AnimationManage;
	import wshExpand.utils.Utils_away3d;
	
	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class ExpandMesh extends ObjectContainer3D 
	{
		public static const MESHTYPE_SKELETANIMATOR:int = 1;	//带骨骼动画的
		public static const MESHTYPE_STATIC:int = 2;	//静态的
		private var _myType:int = 2;		//类型 默认是静态的	gs

		

		public function get myType():int {	return _myType; }
		
		private var _myDepthType:int = 0;		//响应鼠标深度 gs 越大越先检测
		public function get myDepthType():int
		{
			return _myDepthType;
		}
		
		public function set myDepthType(value:int):void
		{
			_myDepthType = value;
		}
		
		public function get meshVector():Vector.<Vector.<Mesh>> 
		{
			return _meshVector;
		}
		
		public var myPath:String;		//路径
		
		public function get myName():String 
		{
			return _myName;
		}
		
		public function set myName(value:String):void 
		{
			_myName = value;
		}
		
		public function get isComplete():Boolean 
		{
			return _isComplete;
		}
		
		public function get actionNames():Vector.<String> 
		{
			return (MySkeletonData.getSkeletonAnimatorByName(_myName, 0,false).animationSet as SkeletonAnimationSet).animationNames;
		}
		
		public function setIsComplete(value:Boolean):void 
		{
			_isComplete = value;
			if (_isComplete) {
				if (LoadSeaManage.loadEventDispatch.hasEventListener(ExpandMeshEvent.LOADSEA_COMPLETE)) {
					LoadSeaManage.loadEventDispatch.removeEventListener(ExpandMeshEvent.LOADSEA_COMPLETE, onCompelete);
				}
			}
		}
		
		
		
		
		public function setMyType(value:int):void 
		{
			_myType = value;
			if (_myType == ExpandMesh.MESHTYPE_STATIC) {
				_isComplete = true;
			}
		}
		
		private var _myName:String;				//对象名称 
		
		private var _surfaceName:String;		//外观名称
		
		private var _isComplete:Boolean = false;		//加载完成的
		
		private var _actionNames:Vector.<String>	//动作名称
		
		private var _meshVector:Vector.<Vector.<Mesh>>;	//子对象 集合  根据骨骼 来分
		
		
		
		
		
		public function ExpandMesh() 
		{
			_meshVector = new Vector.<Vector.<Mesh>>();
			LoadSeaManage.loadEventDispatch.addEventListener(ExpandMeshEvent.LOADSEA_COMPLETE, onCompelete);
		}
		
		//
		private function onCompelete(e:ExpandMeshEvent):void 
		{
			if (e.infoObj == _myName) {
				//显示
				this.removeChild(this.getChildAt(0));
				//updataShow(this);
			}
		}
		
		
		private var _currentLable:String;	//当前动作标签
		public function play(name: String,beginFrame:int = 0,transition : IAnimationTransition = null, offset : Number = NaN):void
		{
			if (_myType == MESHTYPE_STATIC) {
				return;
			}
			//stop();
			if (!_isComplete) {
				return;
			}
			var mesh:Mesh;
			var j:int;
			mesh = _meshVector[0][0];
			(mesh.animator as SkeletonAnimator).play(name, transition, offset, beginFrame);
			(mesh.animator as SkeletonAnimator).addEventListener(AnimationStateEvent.PLAYBACK_COMPLETE, onPlaybackComplete);
			/*if (_currentLable != name) {
				updataDIYShow(name);
			}*/
			for (j = 1; j < _meshVector.length; j++ ) {
				mesh = _meshVector[j][0];
				(mesh.animator as SkeletonAnimator).play(name, transition, offset,beginFrame);
			}
			_currentLable = name;
		}
		
		//======得到当前帧
		public function getCurrentFrame():int
		{
			if (_myType == MESHTYPE_STATIC) {
				return 0;
			}
			if (!_isComplete) {
				return 0;
			}
			var mesh:Mesh;
			var j:int;
			mesh = _meshVector[0][0];
			if(!(mesh.animator as SkeletonAnimator).activeState){
				return 0;
			}
			return ((mesh.animator as SkeletonAnimator).activeState as AnimationClipState).currentFrame;
		}
		
		
		private function onPlaybackComplete(e:AnimationStateEvent):void 
		{
			this.dispatchEvent(new ExpandMeshEvent(ExpandMeshEvent.ACTION_COMPLETE, e.animationNode.name));
		}
		
		public function stop():void
		{
			if (_myType == MESHTYPE_STATIC) {
				return;
			}
			if (!_isComplete) {
				return;
			}
			var mesh:Mesh;
			mesh = _meshVector[0][0];
			(mesh.animator as SkeletonAnimator).removeEventListener(AnimationStateEvent.PLAYBACK_COMPLETE, onPlaybackComplete);
			
			for (var j:int = 0; j < _meshVector.length; j++ ) {
				mesh = _meshVector[j][0];
				(mesh.animator as SkeletonAnimator).stop();
			}
			
		}
		public function start():void
		{
			if (_myType == MESHTYPE_STATIC) {
				return;
			}
			if (!_isComplete) {
				return;
			}
			var mesh:Mesh;
			for (var j:int = 0; j < _meshVector.length; j++ ) {
				mesh = _meshVector[j][0];
				(mesh.animator as SkeletonAnimator).start();
			}
		}
		
		//设置快慢动作  1为正常
		public function setPlayBackSpeed(playSpeed:Number = 1):void
		{
			if (!_isComplete) {
				return;
			}
			var i:int = 0;
			for (i = 0; i < numChildren; i++ ) {
				((getChildAt(i) as Mesh).animator as SkeletonAnimator).playbackSpeed = playSpeed;
			}
		}
		
		
		public function addOneMesh(mesh:Mesh,type:int = 0,animator:SkeletonAnimator = null):void
		{
			if (!_isComplete) {
				return;
			}
			if (_meshVector.length<type+1) {
				_meshVector.length = type+1;
			}
			if (!_meshVector[type]) {
				_meshVector[type] = new Vector.<Mesh>;
			}
			_meshVector[type].push(mesh);
			if (animator) {
				mesh.animator = animator;
			}
			addChild(mesh);
		}
		
		
		public function addMesh(meshs:Vector.<Mesh>,type:int = 0,animator:SkeletonAnimator = null):void
		{
			if (!_isComplete) {
				return;
			}
			for (var i:int = 0; i < meshs.length; i++ ) {
				if (meshs[i].parent !== this) {
					addOneMesh(meshs[i],type,animator);
				}
			}
		}
		
		//删除一个mesh
		public function deleteMesh(mesh:Mesh,type:int = 0):void
		{
			if (_meshVector[type].indexOf(mesh) != -1) {
				_meshVector[type].splice(_meshVector[type].indexOf(mesh), 1);
			}
			mesh.dispose();
		}
		
		//冷冻
		private var _freeze:Boolean
		//清空自己
		public function clearMe(remove:Boolean = false):void
		{
			var mesh:Mesh;
			for (var j:int = 0; j < _meshVector.length; j++ ) {
				for (var i:int = _meshVector[j].length - 1; i >= 0; i-- ) {
					mesh = _meshVector[j][i];
					mesh.material = null;
					if (mesh.animator) {
						mesh.animator = null;
					}
					if (mesh.parent) mesh.parent.removeChild(mesh);
					_meshVector[j].splice(i, 1);
				}
			}
			_meshVector = new Vector.<Vector.<Mesh>>();
			_freeze = true;
			if (remove) {
				dispose();
			}
		}
		
		
		
		private static var _defaultMesh:Mesh;
		private static function getDefaultMesh():Mesh
		{
			if (!_defaultMesh) {
				_defaultMesh = new Mesh(new CubeGeometry(20,20,20), null);
			}
			return _defaultMesh;
		}
		

		
		
		
		
		
		
		//拷贝ExpandMesh
		public static function cloneMe(sourceMesh:ExpandMesh):ExpandMesh
		{
			var resurtMesh:ExpandMesh = new ExpandMesh();
			resurtMesh.setMyType(sourceMesh.myType);
			resurtMesh.setIsComplete(true);
			var tagetMesh:Mesh;
			var tempMesh:Mesh;
			var animator:SkeletonAnimator;
			for (var j:int = 0; j < sourceMesh.meshVector.length; j++ ) {
				if (sourceMesh.meshVector[j][0].animator) {
					animator = (sourceMesh.meshVector[j][0].animator as SkeletonAnimator).clone() as SkeletonAnimator;
					animator.autoUpdate = false;
					AnimationManage.getInstance().addAnimation(animator);
				}
				
				for (var i:int = 0; i < sourceMesh.meshVector[j].length; i++ ) {
					tagetMesh = sourceMesh.meshVector[j][i];
					tempMesh = tagetMesh.cloneNoAimaator();
					resurtMesh.addOneMesh(tempMesh, j,animator);
				}
			}
			return resurtMesh;
		}
		
		
		//删除自定义骨骼
		private function updataDIYShow(actionName:String):void
		{
			var mesh:Mesh;
			for (var j:int = 1; j < _meshVector.length; j++ ) {
				var animator:SkeletonAnimator = MySkeletonData.getSkeletonAnimatorByName(_myName, j).clone() as SkeletonAnimator;
				for (var i:int = 0; i < _meshVector[j].length; i++ ) {
					mesh = _meshVector[j][i];
					if (mesh.animator) {
						(mesh.animator as SkeletonAnimator).dispose();
						mesh.animator = null;
					}
					mesh.animator = animator;
				}
			}
		}
		
		
		//=============载入信息
		public function loadMeshInfo(dataArr:Array):void
		{
			this.x = dataArr[1][0];
			this.y = dataArr[1][1];
			this.z = dataArr[1][2];
			this.rotationX = dataArr[2][0]; 
			this.rotationY = dataArr[2][1];
			this.rotationZ = dataArr[2][2];
			this.scaleX = dataArr[3][0];
			this.scaleY = dataArr[3][1];
			this.scaleZ = dataArr[3][2];
			
			//材质
			//loadTexture(dataArr[4]);
			//得到地形的信息
		}
		
		
		//==============载入材质
		public function loadTexture(textureArr:Array):void
		{
			var mesh:Mesh;
			var bmdName:String;
			for (var j:int = 0; j < _meshVector.length; j++ ) {
				for (var i:int = 0; i < _meshVector[j].length; i++ ) {
					mesh = _meshVector[j][i];
					//trace(mesh.name, "sdasdhaslkdhalskjdlkj", mesh.material)
					//setZhentiTexture(mesh);
					
					if (mesh.material is TextureMaterial) {
						(mesh.material as TextureMaterial).alphaPremultiplied = true;
						(mesh.material as TextureMaterial).alphaThreshold = 0.9;
					}else if (textureArr[j][i] != -1) {
						bmdName = LoadXmlData.textureArr[textureArr[j][i]];
						loadTextureBmd(mesh, bmdName);
					}
				}
			}
		}
		
		//=======处理整体材质
		private function setZhentiTexture(mesh:Mesh):void
		{
			var chlid:Mesh;
			for (var i:int = 0; i < mesh.numChildren; i++ ) {
				if (mesh.getChildAt(i) is Mesh) {
					chlid = mesh.getChildAt(i) as Mesh;
					if (chlid.material is TextureMaterial) {
						(chlid.material as TextureMaterial).alphaPremultiplied = true;
						(chlid.material as TextureMaterial).alphaThreshold = 0.9;
					}
				}
			}
		}
		
		
		private var _pathStr:String = "d3d/res/assets/textures/scene/";
		//========加载材质
		private function loadTextureBmd(mesh:Mesh,bmdName:String):void
		{
			//return;
			var loader:Loader = new Loader();
			var str:String = _pathStr + bmdName + ".png";
			loader.load(new URLRequest(str));
			//将XML转换为数组形式
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e:Event):void {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, arguments.callee);
				mesh.material = new TextureMaterial(Cast.bitmapTexture(loader.contentLoaderInfo.content), true, true);
				(mesh.material as TextureMaterial).alphaPremultiplied = true;
				(mesh.material as TextureMaterial).alphaThreshold = 0.9;
				(mesh.material as TextureMaterial).animateUVs = true;
			})
		}
		
		//======冻结
		public function pauseMe():void
		{
			stop();
			if (parent) {
				parent.removeChild(this);
			}
		}
		
		
		
		//删除自己
		public function deleteMe():void
		{
			var mesh:Mesh;
			stop();
			for (var j:int = 0; j < _meshVector.length; j++ ) {
				for (var i:int = 0; i < _meshVector[j].length; i++ ) {
					mesh = _meshVector[j][i];
					mesh.dispose();
					if (mesh.animator) {
						(mesh.animator as SkeletonAnimator).dispose();
						mesh.animator = null;
					}
				}
			}
			_meshVector = new Vector.<Vector.<Mesh>>();
			dispose();
		}
		
		override public function set mouseEnabled(value : Boolean) : void
		{
			_mouseEnabled = value;
			updateMouseChildren();
			for (var i:int = 0; i < numChildren; i++ ) {
				getChildAt(i).mouseEnabled = value;
			}
		}
		
		public function set pickingCollider(valueL:IPickingCollider):void
		{
			for (var i:int = 0; i < numChildren; i++ ) {
				Mesh(getChildAt(i)).pickingCollider = valueL;
			}
		}
		
		
		public function get freeze():Boolean 
		{
			return _freeze;
		}
		
		public function set freeze(value:Boolean):void 
		{
			_freeze = value;
		}
		
	}

}