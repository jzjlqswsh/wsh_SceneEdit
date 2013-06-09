package wshExpand.control 
{
	import away3d.animators.SkeletonAnimator;
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.events.MouseEvent3D;
	import away3d.materials.TextureMaterial;
	import away3d.utils.Cast;
	import com.Astart.AcorrsLineGrid;
	import com.Astart.Astart;
	import com.Astart.Grid;
	import com.Astart.Node;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import wshExpand.display.displayData.MyMaterialData;
	import wshExpand.display.displayData.MyMeshData;
	import wshExpand.display.displayData.MySkeletonData;
	import wshExpand.display.displayData.MyWeaponMeshData;
	import wshExpand.display.ExpandMesh;
	import wshExpand.skeletonExpand.ExpandMeshEvent;
	import wshExpand.utils.Utils_away3d;

	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class Abstract_action extends Abstract_move 
	{
		
		
		//动作名字
		protected var _currentLable:String = "root";	
		//当前帧
		protected var _currentFrame:int;
		//动作是否完成
		protected var _actionFinished:Boolean = false;
		
		//动作名称
		protected var _walkActionStr:String = "root";
		protected var _runActionStr:String = "root";
		protected var _standActionStr:String = "root";
		protected var _attackActionStr:String = "attack";
		protected var _diedActionStr:String = "died";
		
		public function Abstract_action() 
		{
			_checkHeightAble = true;
		}
		
		override public function setMyName(nameStr:String):void 
		{
			super.setMyName(nameStr);
			//根据名称设置动作名称
			trace(_myName,"5555555555555555555")
			if (_myName == "player_1") {
				_walkActionStr = "run";
			}else if (_myName == "meizi") {
				_standActionStr = "root";
				_walkActionStr = "walk";
				_attackActionStr = "root";
			}else {
				_standActionStr = "root";
				_walkActionStr = "root";
				_attackActionStr = "attack";
			}
		}
		
		
		
		//==========================设置名称====================
		protected var _nameObj:Sprite3D;
		protected var _myHeight:int = 200;		//g
		//设置名称
		protected function setNameShow():void
		{
			setNameObj("名字:" + _myName)
		}
		
		//======设置名称显示
		protected function setNameObj(str:String):void
		{
			//添加名字
			var text:TextField = new TextField();
			text.htmlText = str;
			text.width = text.textWidth;
			text.height = text.textHeight;
			text.autoSize = TextFieldAutoSize.CENTER;
			var changdu:int = Utils_away3d.getTwoPowerNumber(text.textWidth);
			var kuangdu:int = Utils_away3d.getTwoPowerNumber(text.textHeight);
			var textBmpData:BitmapData = new BitmapData(text.width,text.height, true, 0x0);
			textBmpData.draw(text);
			var useBmpData:BitmapData = new BitmapData(changdu, kuangdu, true, 0x0);
			useBmpData.copyPixels(textBmpData, textBmpData.rect, new Point((useBmpData.width - textBmpData.width)/2,(useBmpData.height - textBmpData.height)/2));
			
			var textMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(useBmpData));
			textMaterial.alphaBlending = true;
			_nameObj = new Sprite3D(textMaterial, changdu, kuangdu);
			updataNamePos();
			_mesh.parent.addChild(_nameObj);
		}
		//更新名称位置
		protected function updataNamePos():void
		{
			if (_nameObj) {
				_nameObj.x = _mesh.x;
				_nameObj.z = _mesh.z;
				_nameObj.y = _mesh.y + _myHeight;
			}
		}
		
		//=====================================================部件相关管理
		//部件动作  存
		protected var _bujianAnimatorDic:Dictionary = new Dictionary();
		//部件mesh 存
		protected var _bujianMeshDic:Dictionary = new Dictionary();
		//部件材质 存
		protected var _bujianMaterialDic:Dictionary = new Dictionary();
		
		protected var _bujianMeshs:Array = [];
		protected var _bujianNameToIndexDic:Dictionary = new Dictionary();	//部件类型名称 和索引对应更新
		protected var _haveBujianType:Array = [];			//拥有的部件 【type，name】
		public function setBujian(bujianType:String,bujianName:String):void
		{
			if (_bujianNameToIndexDic[bujianType] == null) {
				_haveBujianType.push([bujianType, bujianName]);
				_bujianNameToIndexDic[bujianType] = _haveBujianType.length - 1;
			}else {
				_haveBujianType[_bujianNameToIndexDic[bujianType]] = [bujianType, bujianName];
			}
		}
		
		//删除部件
		protected function deleteBujian():void
		{
			var tempMesh:ExpandMesh;
			for (var i:int = _bujianMeshs.length - 1; i >= 0; i-- ) {
				tempMesh = _bujianMeshs[i];
				if (tempMesh) {
					tempMesh.clearMe(true);
				}
			}
			_bujianMeshs = [];
			var j:*;
			for (j in _bujianAnimatorDic) {
				(_bujianAnimatorDic[j] as SkeletonAnimator).dispose();
			}
			for (j in _bujianMeshDic) {
				
				for (var k:int = 0; k < _bujianMeshDic[j].length;k++ ) {
					(_bujianMeshDic[j][k] as Mesh).dispose();
				}
			}
			for (j in _bujianMaterialDic) {
				(_bujianMaterialDic[j] as TextureMaterial).dispose();
			}
			_bujianMaterialDic = new Dictionary();
			_bujianAnimatorDic = new Dictionary();
			_bujianMeshDic = new Dictionary();
			_bujianNameToIndexDic = new Dictionary();
			_haveBujianType = [];
		}
		
		//设置武器名称
		public function setWeaponName(weaponStr:String,nowChange:Boolean = false):void
		{
			if(!weaponStr){
				clearBujian();
				return;
			}
			setBujian("weapon", weaponStr);
			if (_mesh&&nowChange) {
				showBujian();
			}
		}
		
		
		//刷新部件显示
		protected function updataBujianShow(action:String):void
		{
			if (_tempActionName != action) {
				showBujian();
			}else {
				for (var i:int = 0; i < _haveBujianType.length; i++ ) {
					if (_bujianMeshs[i] && !_bujianMeshs[i].freeze) {
						_bujianMeshs[i].play("root",_mesh.getCurrentFrame());
					}
				}
			}
		}
		
		//创建部件
		protected function creatBujian(bujianType:String = "weapon"):ExpandMesh
		{
			var resurtMesh:ExpandMesh = new ExpandMesh();
			resurtMesh.setMyType(ExpandMesh.MESHTYPE_SKELETANIMATOR);
			resurtMesh.myName = bujianType;
			resurtMesh.setIsComplete(true);
			_bujianMeshs[_bujianNameToIndexDic[bujianType]] = resurtMesh;
			return resurtMesh;
		}
		//清空部件
		protected function clearBujian(bujianType:String = "weapon"):void
		{
			var index:int = _bujianNameToIndexDic[bujianType];
			var bujianMesh:ExpandMesh = _bujianMeshs[index];
			if (bujianMesh && !bujianMesh.freeze) {
				bujianMesh.stop();
				bujianMesh.clearMe();
			}
		}
		
		protected function showBujian():void
		{
			for (var i:int = 0; i < _haveBujianType.length; i++ ) {
				if(_haveBujianType[i]){
					showBujianByType(_haveBujianType[i][0], _haveBujianType[i][1]);
				}
			}
		}
		//========显示某个部件
		protected function showBujianByType(bujianType:String,bujianName:String):void
		{
			clearBujian(bujianType);
			if(!bujianName){
				return;
			}
			var meshs:Vector.<Mesh>;
			if (_bujianMeshDic[bujianType+"_"+bujianName+"_"+_currentLable]) {
				meshs = _bujianMeshDic[bujianType+"_"+bujianName + "_" + _currentLable];
			}else {
				meshs = MyMeshData.getMeshData(_myName+"_"+bujianType, 0, bujianName + "_" + _currentLable);
				_bujianMeshDic[bujianType+"_"+bujianName + "_" + _currentLable] = meshs;
			}
			var material:TextureMaterial;
			if (_bujianMaterialDic[bujianType + "_" + bujianName]) {
				material = _bujianMaterialDic[bujianType + "_" + bujianName];
			}else {
				material = new TextureMaterial(MyMaterialData.getMaterial(_myName + "_" + bujianType + "_" + bujianName).texture,true,true);
				_bujianMaterialDic[bujianType + "_" + bujianName] = material;
			}
			
			var animator:SkeletonAnimator;
			if (_bujianAnimatorDic[bujianType + "_" + _currentLable]) {
				animator = _bujianAnimatorDic[bujianType + "_" + _currentLable];
			}else {
				animator = MySkeletonData.getSkeletonAnimatorByName(_myName+"_"+bujianType + "_" + _currentLable);
				_bujianAnimatorDic[bujianType + "_" + _currentLable] = animator;
			}
			var index:int = _bujianNameToIndexDic[bujianType];
			var bujianMesh:ExpandMesh = _bujianMeshs[index];;
			if (!bujianMesh) {
				bujianMesh = creatBujian();
			}
			bujianMesh.freeze = false;
			for (var i:int = 0; i < meshs.length; i++ ) {
				meshs[i].material = material;
			}
			bujianMesh.addMesh(meshs, 0, animator);
			if (!bujianMesh.parent) {
				_mesh.addChild(bujianMesh);
			}
			bujianMesh.play("root", _mesh.getCurrentFrame());
		}
		
		
		
		
		
		
		//========更新附加对象位置
		override protected function updataPlugPos():void 
		{
			super.updataPlugPos();
			updataNamePos();
		}
		
		override public function setV(mesh:ExpandMesh):void 
		{
			super.setV(mesh);
			mesh.addEventListener(ExpandMeshEvent.ACTION_COMPLETE, actionComplete);
			showBujian();
		}
		
		override public function initShow(ctn:*, posx:Number = 0, posy:Number = 0, posz:Number = 0):void 
		{
			super.initShow(ctn, posx, posy, posz);
			justgotoFrameAll(_standActionStr);
			setNameShow();
			
		}
		
		//动作结束
		protected function actionComplete(e:ExpandMeshEvent):void 
		{
			//trace(_currentLable,"99999999999999999999999")
			_actionFinished = true;
			if(_died){
				return;
			}
			justgotoFrameAll(e.infoObj)
		}
		
		private var _tempActionName:String;
		protected function gotoAndStop(action:String,frame:int = 0):void
		{
			_tempActionName = _currentLable
			_currentLable = action;
			_mesh.play(action, frame, null, NaN);
			_actionFinished = false;
			updataBujianShow(action);
		}
		
		//普通跳转
		public function gotoFrame(action:String,frame:int = 0):void
		{
			if (_currentLable == action) {
				return;
			}
			if (_currentLable == "attack") {
				if (!_actionFinished) {
					return;
				}
			}
			gotoAndStop(action, frame);
		}
		//强制跳转
		protected function justgotoFrame(action:String,frame:int = 0):void
		{
			if (_currentLable == action) {
				return;
			}
			gotoAndStop(action, frame);
		}
		//强制跳转 包括自己
		protected function justgotoFrameAll(action:String,frame:int = 0):void
		{
			gotoAndStop(action, frame);
		}
		
		protected function stop():void
		{
			_mesh.stop();
		}
		protected function start():void
		{
			_mesh.start();
		}
		
		
		override public function deleteMe():void 
		{
			if (_mesh) {
				_mesh.removeEventListener(ExpandMeshEvent.ACTION_COMPLETE, actionComplete);
			}
			//清楚名称
			if (_nameObj) {
				_nameObj.dispose();
				_nameObj = null;
			}
			//清楚部件
			deleteBujian();
			super.deleteMe();
		}
		
		
		public function get currentLable():String 
		{
			return _currentLable;
		}
		
		public function get currentFrame():int 
		{
			return _currentFrame;
		}
		
	}

}