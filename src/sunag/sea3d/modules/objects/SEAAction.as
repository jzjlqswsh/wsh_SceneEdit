/*
*
* Copyright (c) 2013 Sunag Entertainment
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of
* this software and associated documentation files (the "Software"), to deal in
* the Software without restriction, including without limitation the rights to
* use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
* the Software, and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
* FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
* IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
*/

package sunag.sea3d.modules.objects
{
	import flash.utils.ByteArray;
	
	import sunag.sea3d.SEA;
	import sunag.sea3d.objects.SEAObject;
	import sunag.utils.ByteArrayUtils;
	import sunag.sunag;
	
	use namespace sunag;
	
	public class SEAAction extends SEAObject
	{
		public static const TYPE:String = "act";
		
		public var action:Array = [];
				
		public static const BACKGROUND:uint = 0;
		public static const ENVIRONMENT:uint = 1;
		public static const ENVIRONMENT_TEXTURE:uint = 2;
		public static const FOG:uint = 3;
		public static const PLAY_ANIMATION:uint = 4;
		public static const PLAY_SOUND:uint = 5;
		public static const ANIMATION_AUDIO_SYNC:uint = 6;		
		
		public function SEAAction(name:String, sea:SEA)
		{
			super(name, TYPE, sea);
		}
		
		public override function load():void
		{
			var count:uint = data.readUnsignedInt();
			
			for(var i:uint = 0; i < count; i++)
			{				
				var flag:uint = data.readUnsignedByte();
				var type:uint = data.readUnsignedInt();
				var size:uint = data.readUnsignedInt();
				
				var act:Object = action[i] = {type:type};
				
				// range of animation
				if (flag & 1)
				{
					// start and count in frames
					act.range = [data.readUnsignedInt(), data.readUnsignedInt()];
				}
				
				switch (type)
				{					
					case PLAY_SOUND, ANIMATION_AUDIO_SYNC:
						act.sound = data.readUnsignedInt();
						act.offset = data.readUnsignedInt();
						break;
					
					case PLAY_ANIMATION:
						act.object = data.readUnsignedInt();
						act.name = ByteArrayUtils.readUTFTiny(data);
						break;
					
					case FOG:
						act.min = data.readFloat();
						act.max = data.readFloat();
						act.color = ByteArrayUtils.readUnsignedInt24(data);
						break;
					
					case ENVIRONMENT_TEXTURE, ENVIRONMENT:
						act.texture = data.readUnsignedInt();
						break;
					
					case BACKGROUND:
						act.color = ByteArrayUtils.readUnsignedInt24(data);
						break;
					
					default:
						trace("Action \"" + type.toString(16) + "\" not found.");
						data.position += size;
						break;
				}
			}
		}		
	}
}