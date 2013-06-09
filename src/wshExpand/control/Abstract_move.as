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
	public class Abstract_move extends Abstract_basic 
	{
		
		//==========speed
		protected var _speedX:Number = 0;		//g
		protected var _speedY:Number = 0;		//g
		protected var _speedZ:Number = 0;		//g
		
		public static var MOVESTATE_STAND:String = "stand";
		public static var MOVESTATE_WALK:String = "walk";
		public static var MOVESTATE_JUMP:String = "jump";
		
		//==========hittest
		protected var _blockX:Boolean;
		protected var _blockY:Boolean;
		protected var _blockZ:Boolean;
		protected function initBlock(bl:Boolean = false):void
		{
			_blockX = _blockY = _blockZ = bl;
		}
		
		public function Abstract_move() 
		{
			
		}
		
		override public function initShow(ctn:*, posx:Number = 0, posy:Number = 0, posz:Number = 0):void 
		{
			super.initShow(ctn, posx, posy, posz);
			initStand();
		}
		
		
		
		protected var _moveState:String
		//=============运动相关
		protected function initStand():void
		{
			_speedX = 0;
			_speedZ = 0;
			_speedY = 0;
			_moveState = MOVESTATE_STAND;
		}
		
		protected function initWalk(Xspeed:Number,Zspeed:Number):void
		{
			_speedX = Xspeed;
			_speedZ = Zspeed;
			
			_moveState = MOVESTATE_WALK;
			
		}
		
		protected function initJump(Yspeed:Number):void
		{
			_speedY = Yspeed;
			_moveState = MOVESTATE_JUMP;
		}
		
		
		protected function updataPlugPos():void
		{
			
		}
		
		private var _speedRate:Number = 1;
		//=====更新速度
		protected function updataSpeedByTime():void
		{
			if (_updataByTime) {
				_speedRate = _runTime / SceneManage.getInstance().oneFrameTime;
			}else {
				_speedRate = 1;
			}
		}
		
		override protected function move():void
		{
			updataSpeedByTime();
			if (_moveState != MOVESTATE_STAND) {
				if (!_blockX) {
					_myX += _speedX*_speedRate;
				}
				if (!_blockZ) {
					_myZ += _speedZ*_speedRate;
				}
			}
			if (!_blockY) {
				_myY += _speedY*_speedRate;
			}
			updataPlugPos();
		}
		
		public function get speedX():Number 
		{
			return _speedX;
		}
		
		public function get speedY():Number 
		{
			return _speedY;
		}
		
		public function get speedZ():Number 
		{
			return _speedZ;
		}
		
		public function set speedX(value:Number):void 
		{
			_speedX = value;
		}
		
		public function set speedY(value:Number):void 
		{
			_speedY = value;
		}
		
		public function set speedZ(value:Number):void 
		{
			_speedZ = value;
		}
		
		
		
		
	}

}