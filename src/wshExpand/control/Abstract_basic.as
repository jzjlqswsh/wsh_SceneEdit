package wshExpand.control 
{
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import com.Astart.AcorrsLineGrid;
	import com.Astart.Astart;
	import com.Astart.Grid;
	import com.Astart.Node;
	import flash.geom.Point;
	import wshExpand.display.ExpandMesh;
	import wshExpand.sys.SceneManage;

	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class Abstract_basic 
	{
		
		protected var _myNode:Node;
		
		public static var CONST_ID:int = 0;
		//=================ID 唯一标示符
		protected var _myID:int = 0;
		
		protected var _myName:String;
		
		//==========虚拟pos 
		protected var _myX:Number;
		protected var _myY:Number;
		protected var _myZ:Number;
		
		protected var _updataByTime:Boolean = true;		//是否按时间刷新
		protected var _checkHeightAble:Boolean;		//是否检测高度
		
		protected var _mesh:ExpandMesh;		//g
		
		protected var _died:Boolean;		// g死亡
		
		
		public function Abstract_basic() 
		{
			CONST_ID++;
			_myID = CONST_ID;
			SceneManage.getInstance().allObjectArr.push(this);
		}
		
		
		//设置视图
		public function setV(mesh:ExpandMesh):void
		{
			_mesh = mesh;
			mesh.myDepthType = 1;
		}
		
		//设置名称
		public function setMyName(nameStr:String):void
		{
			_myName = nameStr;
		}
		
		//设置数据
		public function setM(data:*):void
		{
		}
		
		//显示
		public function initShow(ctn:*, posx:Number = 0, posy:Number = 0,posz:Number = 0 ):void
		{
			ctn.addChild(_mesh);
			initPos(posx, posy, posz);
			realPos();
		}
		
		protected function initPos(posx:Number = 0, posy:Number = 0,posz:Number = 0):void
		{
			_myX = posx;
			_myY = posy;
			_myZ = posz;
		}
		
		
		protected var _runTime:int;	//运行时间
		
		public function updataFrame():void
		{
			if (_died) {
				return;
			}
			updataByTimeFun();
			
			checkHeight();
			realPos();
			
			endLoopDied();
		}
		
		//按时间刷新
		private function updataByTimeFun():void
		{
			if (!_updataByTime) {
				countEvent();	//计数
			
				controlEvent();	//控制
				
				hitTest();
				
				move();
				return;
			}
			var time:int = 0;
			do {
				if (_died) {
					return;
				}
				time += SceneManage.getInstance().oneFrameTime;
				if (time < SceneManage.getInstance().nowTime) {
					_runTime = SceneManage.getInstance().oneFrameTime;
				}else {
					_runTime = SceneManage.getInstance().nowTime - time + SceneManage.getInstance().oneFrameTime;
				}
				countEvent();	//计数
			
				controlEvent();	//控制
				
				hitTest();
				
				move();
				
			}while (time < SceneManage.getInstance().nowTime)
		}
		
		
		
		//计数
		protected function countEvent():void 
		{
			
		}
		
		//控制
		protected function controlEvent():void 
		{
			
		}
		
		
		
		
		protected function hitTest():void
		{
			
		}
		
		//检查高度
		protected function checkHeight():void 
		{
			if (!_checkHeightAble) {
				return;
			}
			var height:int = getGaoduByPos(_myX, _myZ);
			_myY = height;
		}
		
		
		/**
		 * 
		 * @param	posx  相对地形的位置
		 * @param	posy
		 * @return
		 */
		public static function getGaoduByPos(posx:int,posy:int):Number
		{
			if (!SceneManage.dixingInfoArr) {
				return 0;
			}
			//得到相对位置
			var xDis:Number = (SceneManage.dixingInfoArr[3] - SceneManage.dixingInfoArr[0])*SceneManage.dixingInfoArr[6];
			var yDis:Number = (SceneManage.dixingInfoArr[4] - SceneManage.dixingInfoArr[1])*SceneManage.dixingInfoArr[6];
			var zDis:Number = (SceneManage.dixingInfoArr[5] - SceneManage.dixingInfoArr[2])*SceneManage.dixingInfoArr[6];
			posx -= SceneManage.dixingInfoArr[7];
			posy -= SceneManage.dixingInfoArr[9];
			var bmdX:int = (SceneManage.getInstance().heightBitMap.width-1) * (posx+xDis/2) / xDis;
			var bmdZ:int = (SceneManage.getInstance().heightBitMap.height-1) * (zDis/2 - posy) / zDis;
			
			var color:uint = SceneManage.getInstance().heightBitMap.getPixel32(bmdX, bmdZ);
			//trace(color.toString(16),"777777777777777")
			color &= 0x00ffffff;
			//trace(color.toString(16),"888888888888888")
			color >>= 16;
			//trace(color.toString(16),"99999999999999999")
			var height:Number = color * yDis / 255 + (SceneManage.dixingInfoArr[1])*SceneManage.dixingInfoArr[6];
			//trace(height,"10101010")
			return height+SceneManage.dixingInfoArr[8];
		}
		
		
		public function behit(who:Abstract_basic):void
		{
			
		}
		
		
		
		protected function move():void
		{
			
			
		}
		
		protected function realPos():void
		{
			_mesh.x = _myX;
			_mesh.y = _myY;
			_mesh.z = _myZ;
		}
		
		protected function endLoopDied():void
		{
			if (_endDied) {
				deleteMe();
			}
		}
		
		private var _endDied:Boolean;
		protected function setEndLoopDied():void
		{
			_endDied = true;
		}
		
		
		public function deleteMe():void
		{
			if (_died) {
				return;
			}
			SceneManage.getInstance().deleteFromObjectArr(this);
			_died = true;
			if (_mesh) {
				_mesh.deleteMe();
				_mesh = null;
			}
			
		}
		
		
		
		public function get mesh():ExpandMesh 
		{
			return _mesh;
		}
		
		public function get died():Boolean 
		{
			return _died;
		}
		
		public function get myX():Number 
		{
			return _myX;
		}
		
		public function get myY():Number 
		{
			return _myY;
		}
		
		public function get myZ():Number 
		{
			return _myZ;
		}
		
		public function get myID():int 
		{
			return _myID;
		}
		
		public function get myName():String 
		{
			return _myName;
		}
		
		
		
	}

}