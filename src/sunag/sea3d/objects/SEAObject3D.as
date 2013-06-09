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
	import sunag.sunag;
	
	use namespace sunag;
	
	public class SEAObject3D extends SEAObject
	{
		public static const TYPE:String = "o3d";
				
		public var attrib:uint;	
		public var parent:Object;		
		
		public var useAnimation:Boolean;
		public var animation:uint;		
		
		public var useProperties:Boolean;
		public var properties:uint;
		
		public var scripts:Vector.<uint>;
		
		public var lookAt:Object;
			
		public var isStatic:Boolean;
		
		public var castShadows:Boolean = true;
		public var receiveShadows:Boolean = true;
		public var receiveLights:Boolean = true;
		
		public function SEAObject3D(name:String, type:String, sea:SEA)
		{						
			super(name, type, sea);
		}
		
		override public function load():void
		{
			attrib = data.readUnsignedShort();
			
			read(data);
			
			var numTag:int = data.readUnsignedByte();
			
			for (var i:int=0;i<numTag;++i)
			{
				var kind:uint = data.readUnsignedShort();
				var size:uint = data.readUnsignedInt();				
				var pos:uint = data.position;
				
				if (!readTag(kind, data, size))				
					trace("Tag 0x" + kind.toString(16) + " was not found in the object \"" + filename + "\".");				
				
				data.position = pos += size; 
			}
		}
		
		protected function read(data:ByteArray):void
		{
			if (attrib & 1)
			{
				switch(data.readUnsignedByte())
				{
					case 0:
						parent = 
							{
								index:data.readUnsignedInt()
							}						
						break;
					
					case 1:
						parent = 
							{
								index:data.readUnsignedInt(),
								joint:data.readUnsignedShort()
							}
						break;
				}
			}
			
			if (useAnimation = attrib & 2)
				animation = data.readUnsignedInt();			
			
			if (useProperties = attrib & 4)
				properties = data.readUnsignedInt();
			
			if (attrib & 8)
			{
				var count:uint = data.readUnsignedByte(),
					i:int = 0;
				
				scripts = new Vector.<uint>(count);
				
				while ( i < count )
					scripts[i++] = data.readUnsignedInt(); 
			}
			
			if (attrib & 16)
			{
				var objectType:uint = data.readUnsignedByte();
				isStatic = objectType & 1;
			}
			
			if (attrib & 32)
			{
				var lightType:int = data.readUnsignedByte();
				castShadows = lightType & 1;
				receiveShadows = lightType & 2;
				receiveLights = lightType & 4;
			}
			
			if (attrib & 64)
			{
				var flag:int = data.readUnsignedByte();
				lookAt = 
					{
						index:data.readUnsignedInt()
					};				
			}
		}
		
		protected function readTag(kind:uint, data:*, size:uint):Boolean
		{
			return false;		
		}
	}
}