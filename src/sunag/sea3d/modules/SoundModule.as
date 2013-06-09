package sunag.sea3d.modules
{
	import away3d.audio.Sound3D;
	import away3d.audio.SoundMixer3D;
	import away3d.sea3d.animation.Sound3DAnimation;
	
	import flash.media.Sound;
	
	import sunag.sea3d.SEA;
	import sunag.sea3d.SEA3D;
	import sunag.sea3d.modules.objects.SEASound;
	import sunag.sea3d.modules.objects.SEASoundPoint;
	import sunag.sea3d.objects.SEAObject3D;
	import sunag.sunag;

	use namespace sunag;
	
	public class SoundModule extends SoundModuleBase
	{
		protected var _sound:Vector.<Sound>;
		protected var _sound3d:Vector.<Sound3D>;
		protected var _soundMixer:Vector.<SoundMixer3D>;
		
		sunag var sea3d:SEA3D;
		
		public function SoundModule()
		{
			regRead(SEASound.TYPE, readSound);
			regRead(SEASoundPoint.TYPE, readSoundPoint);
		}
		
		override sunag function reset():void
		{
			_sound = null;
			_soundMixer = null;
			_soundMixer = null;
		}
		
		override public function dispose():void
		{
			for each(var snd3d:Sound3D in _sound3d)
			{
				snd3d.dispose();
			}	
		}
		
		public function get sounds():Vector.<Sound>
		{
			return _sound;
		}
		
		public function get sounds3d():Vector.<Sound3D>
		{
			return _sound3d;
		}
		
		public function getSound(name:String):Sound
		{
			return sea.object["snd/"+name];
		}	
		
		public function getSound3D(name:String):Sound3D
		{
			return sea.object["s3d/"+name];
		}
		
		public function getSoundMixer3D(name:String=""):SoundMixer3D
		{
			return sea.object["smx/"+name];
		}
		
		public function get soundMixers():Vector.<SoundMixer3D>
		{
			return _soundMixer;
		}
		
		protected function creatSoundMixer3D(name:String):SoundMixer3D
		{
			if (!getSoundMixer3D(name))
			{
				var soundMixer:SoundMixer3D = new SoundMixer3D();
				soundMixer.name = name;
				
				_soundMixer ||= new Vector.<SoundMixer3D>();
				_soundMixer.push(sea.object["smx/"+name] = soundMixer);
			}
			
			return getSoundMixer3D(name);
		}
		
		protected function readSound(sea:SEASound):void
		{
			_sound ||=  new Vector.<Sound>();
			_sound.push(this.sea.object["snd/"+sea.name] = sea.tag = sea.sound);	
		}
				
		protected function readSoundPoint(sea:SEASoundPoint):void
		{
			var snd:Sound3D;
			var mix:SoundMixer3D = creatSoundMixer3D(sea.soundNS);
						
			snd = new Sound3D(sea3d._objects[sea.sound].tag, mix);
			
			snd.volume = sea.volume;
			snd.scaleDistance = sea.distance;
			snd.position = sea.position;
								
			if (sea.useAnimation)
			{					
				sea3d.addAnimation
				(
					new Sound3DAnimation(sea3d._objects[sea.animation].tag, snd),						
					sea.name
				)	
			}
			
			if (sea.autoPlay) 
				snd.play();
			
			snd.name = sea.name;								
			
			sea3d.addSceneObject(sea, snd);
			
			_sound3d ||= new Vector.<Sound3D>();
			_sound3d.push(sea3d.object["s3d/"+sea.name] = sea.tag = snd);					
		}
		
		override sunag function init(sea:SEA):void
		{
			this.sea = sea;
			sea3d = sea as SEA3D;
		}
	}
}