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

package sunag.sea3d.objects
{
	import flash.utils.ByteArray;
	
	import sunag.sea3d.SEA;
	import sunag.utils.ByteArrayUtils;
	import sunag.utils.DataTable;
	
	public class SEAMaterial extends SEAObject
	{
		public static const TYPE:String = "mat";	
		
		public static const DEFAULT:uint = 0x0000;
		public static const DIFFUSE_MAP:uint = 0x0001;
		public static const SPECULAR_MAP:uint = 0x0002;
		public static const REFLECTION_MAP:uint = 0x0003;
		public static const REFRACTION_MAP:uint = 0x0004;
		public static const NORMAL_MAP:uint = 0x0005;
		public static const FRESNEL_REFLECTION:uint = 0x0006;
		public static const RIM:uint = 0x0007;
		public static const TRANSLUCENT:uint = 0x0008;
		public static const CEL:uint = 0x0009;
				
		public static const R_MIRROR:uint = 0x00;
		public static const R_ENVIRONMENT:uint = 0x01;
		
		public var animation:uint;				
		
		public var bothSides:Boolean;
		public var smooth:Boolean;
		public var mipmap:Boolean;
		
		public var alpha:Number = 1;	
		public var blendMode:String = null;
		public var alphaThreshold:Number = .5;
		
		public var diffuseMap:Object;
		
		public var technique:Array = [];	
		
		public function SEAMaterial(name:String,sea:SEA)
		{
			super(name, TYPE, sea);										
		}	
		
		override public function load():void
		{
			var attrib:uint = data.readUnsignedShort();
			
			bothSides = (attrib & 1) != 0;
			smooth = (attrib & 2) != 0;
			mipmap = (attrib & 4) != 0;
			
			if (attrib & 8)
				alpha = data.readFloat();
			
			if (attrib & 16)
				alphaThreshold = data.readFloat();
			
			if (attrib & 32)
				blendMode = ByteArrayUtils.readBlendMode(data);
			
			if (attrib & 64)
				animation = data.readUnsignedInt();		
			
			var count:int = data.readUnsignedByte();
			
			for (var i:int=0;i<count;++i)
			{
				var kind:uint = data.readUnsignedShort();
				var size:uint = data.readUnsignedShort();				
				var pos:uint = data.position;
				var tech:Object;	
					
				switch(kind)
				{
					case DEFAULT:
						tech =
							{
								ambientColor:ByteArrayUtils.readUnsignedInt24(data),
								diffuseColor:ByteArrayUtils.readUnsignedInt24(data),
								specularColor:ByteArrayUtils.readUnsignedInt24(data),
								
								specular:data.readFloat(),
								gloss:data.readFloat()
							}
						break;
					case DIFFUSE_MAP:						
						tech = diffuseMap =
							{
								texture:data.readUnsignedInt()							
							}
						break;
					case SPECULAR_MAP:
						tech =
							{
								texture:data.readUnsignedInt()							
							}
						break;
					case REFLECTION_MAP:
						tech =
							{
								alpha:data.readFloat(),
								texture:data.readUnsignedInt()						
							}
						break;
					case REFRACTION_MAP:
						tech =
							{
								alpha:data.readFloat(),
								ior:data.readFloat(),
								texture:data.readUnsignedInt()						
							}
						break;
					case NORMAL_MAP:						
						tech =
							{
								texture:data.readUnsignedInt()							
							}
						break;
					case FRESNEL_REFLECTION:
						tech =
							{
								alpha:data.readFloat(),
								texture:data.readUnsignedInt(),
								power:data.readFloat(),
								normal:data.readFloat()
							}
						break;
					case RIM:
						tech = 
							{
								strength:data.readFloat(),
								color:ByteArrayUtils.readUnsignedInt24(data),
								power:data.readFloat(),			
								blendMode:ByteArrayUtils.readBlendMode(data)
							}
						break;
					case TRANSLUCENT:
						tech = 
							{						
								color:ByteArrayUtils.readUnsignedInt24(data),
								translucency:data.readFloat(),
								scattering:data.readFloat()
							}
						break;
					case CEL:
						tech = 
							{
								color:ByteArrayUtils.readUnsignedInt24(data),
								levels:data.readUnsignedByte(),
								size:data.readFloat(),
								specularCutOff:data.readFloat(),
								smoothness:data.readFloat()						
							}
						break;				
					default:						
						trace("MaterialTechnique not found:", kind.toString(16));
						data.position = pos += size;
						continue;
						break;
				}
				
				/*if (data.position != pos + size)
					trace("MaterialTechnique invalid:", kind.toString(16));*/
				
				tech.kind = kind;
				
				technique.push(tech);								
				
				data.position = pos += size;
			}	
		}
	}
}