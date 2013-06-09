package sunag.sea3d.animation
{
	public class AnimationSequence3D
	{
		public var name:String;
		public var start:int;
		public var end:int;
		public var repeat:Boolean;
		
		public function AnimationSequence3D(name:String, start:int, end:int, repeat:Boolean=true)
		{
			this.name = name;
			this.start = start;
			this.end = end;
			this.repeat = repeat;
		}
		
		public function get numFrames():uint
		{
			return (end - start) + 1;
		}
	}
}