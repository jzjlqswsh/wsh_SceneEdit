package wshExpand.sys 
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.controllers.HoverController;
	
	import gameCode.ui.FirstLayer.FightLayerGroup;
	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class CameraManage 
	{
		private static var _instance:CameraManage;
		static public function getInstance():CameraManage 
		{
			if (!_instance) {
				_instance = new CameraManage();
			}
			return _instance;
		}
		public function CameraManage() 
		{
			
		}
		
		
		public static const CAMERATYPE_FOLLOWTRAGET:String = "cameratype_followTarget";
		
		public static const CAMERATYPE_STATIC:String = "cameratype_static";
		
		
		
		
		private var _myTarger:ObjectContainer3D;		//需要跟随的目标
		private var _tagerVector3D:Vector3D = new Vector3D();	
		
		private var _camera:Camera3D;
		private var _cameraType:String;
		private var _cameraController_1:HoverController;		//g
		
		private var _coefficientXZ:Number = 0.1;	//缓动系数
		private var _coefficientY:Number = 0.05;	//缓动系数
		
		//=======================================设置
		//设置舞台
		private var _stage:Stage;
		public function setStage(myStage:Stage):void
		{
			_stage = myStage;
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelPress)
		}
		
		private function mouseWheelPress(e:MouseEvent):void 
		{
			if (_cameraController_1) {
				_cameraController_1.distance -= e.delta * 5;
			}
		}
		
		//设置相机
		public function setCamera(tagetCamera:Camera3D):void
		{
			_camera = tagetCamera;
		}
		public function setMyTaget(taget:ObjectContainer3D):void
		{
			_myTarger = taget;
			if (_cameraType == CAMERATYPE_FOLLOWTRAGET) {
				followTarget(_myTarger);
			}
		}
		//=======跟随对象
		private function followTarget(target:ObjectContainer3D):void
		{
			_tagerVector3D = target.position.clone();
			if (!_cameraController_1) {
				_cameraController_1 = new HoverController(_camera, null,180,15,900,-90,90);
			}
			_cameraController_1.lookAtPosition = _tagerVector3D;
		}
		
		//设置类型 相机
		public function setCameraType(type:String):void
		{
			_cameraType = type;	
		}
		
		//====================================刷新
		public function updataFrame():void
		{
			cameraMove();
			
			cameraAngleMove();
		}
		
		//相机移动
		private function cameraMove():void 
		{
			if (_cameraType == CAMERATYPE_FOLLOWTRAGET) {
				cameraMoveToTarget();
			}
		}
		
		//========相机移动
		private function cameraMoveToTarget():void
		{
			if (!_myTarger||!_myTarger.position) {
				return;
			}
			_tagerVector3D.x += (_myTarger.position.x - _tagerVector3D.x) * _coefficientXZ;
			_tagerVector3D.y += (_myTarger.position.y - _tagerVector3D.y) * _coefficientY;
			_tagerVector3D.z += (_myTarger.position.z - _tagerVector3D.z) * _coefficientXZ;
			_cameraController_1.lookAtPosition = _tagerVector3D;
		}
		
		
		//=========角度变化
		public function cameraAngleMove():void
		{
			if (!_cameraController_1) {
				return;
			}
			if (FightLayerGroup.mouseDown) {
				_cameraController_1.panAngle = 0.3*(_stage.mouseX - FightLayerGroup.lastMouseX) + FightLayerGroup.lastPanAngle;
				_cameraController_1.tiltAngle = 0.3 * (_stage.mouseY - FightLayerGroup.lastMouseY) + FightLayerGroup.lastTiltAngle;
				if (_cameraController_1.tiltAngle > 45) {
					_cameraController_1.tiltAngle = 45;
				}
				if (_cameraController_1.tiltAngle < 10) {
					_cameraController_1.tiltAngle = 10;
				}
			}
		}
		
		
		public function get cameraController_1():HoverController 
		{
			return _cameraController_1;
		}
		
	}

}