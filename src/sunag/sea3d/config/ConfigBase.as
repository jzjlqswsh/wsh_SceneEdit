package sunag.sea3d.config
{
	public class ConfigBase implements IConfigBase
	{
		private var _timeLimit:int;
		
		public function ConfigBase(timeLimit:int=100):void
		{
			_timeLimit = timeLimit;
		}
		
		public function set timeLimit(value:int):void
		{
			_timeLimit = value;
		}
		
		public function get timeLimit():int
		{
			return _timeLimit;
		}
	}
}