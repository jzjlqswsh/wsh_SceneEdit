package wshExpand.data 
{
	import wshExpand.utils.Equation;
	/**
	 * ...人物属性数据
	 * @author wangshuaihua
	 */
	public class RoleProData 
	{
		public function RoleProData() 
		{
			myCd = Math.random() * 1 +2;
			mySpeed = Math.random()*4+2;
		}
		
		private var _mySpeed:Number = 5;//移动速度		
		
		private var _myCd:Number = 3;		//CD 秒
		
		private var _health:int = 100;	//血量
		
		private var _attackHurt:int = 10;	//伤害
		
		private var _attackDis:int = 1;		//攻击距离
		
		private var _attackType:int = 1;	//攻击类型 1普通 2直线 3横排 4周围 5全部  
		
		private var _yingzhi:int = 1;		//硬直 帧数
		
		//血量改变
		public function changeHealth(value:int):void 
		{
			_health += value;
			if (_health < 0) {
				_health = 0;
				//发侦听 空血
			}
		}
		
		
		
		//=======根据OBJ得到属性
		public static function getProDataByObj(proObj:Object = null):RoleProData
		{
			var rolePro:RoleProData = new RoleProData();
			if (proObj) {
				for (var i:String in proObj) {
					rolePro[i] = proObj[i];
				}
			}
			return rolePro;
		}
		
		
		
		public function get mySpeed():Number 
		{
			return _mySpeed;
		}
		
		public function set mySpeed(value:Number):void 
		{
			_mySpeed = Equation.getNumByDecimal(value,4);
		}
		
		public function get myCd():Number 
		{
			return _myCd;
		}
		
		public function set myCd(value:Number):void 
		{
			_myCd = Equation.getNumByDecimal(value,4);
		}
		
		public function get health():int 
		{
			return _health;
		}
		
		
		
		public function get attackHurt():int 
		{
			return _attackHurt;
		}
		
		public function set attackHurt(value:int):void 
		{
			_attackHurt = value;
		}
		
		public function get attackDis():int 
		{
			return _attackDis;
		}
		
		public function set attackDis(value:int):void 
		{
			_attackDis = value;
		}
		
		public function get attackType():int 
		{
			return _attackType;
		}
		
		public function set attackType(value:int):void 
		{
			_attackType = value;
		}
		
		public function get yingzhi():int 
		{
			return _yingzhi;
		}
		
		
	}

}