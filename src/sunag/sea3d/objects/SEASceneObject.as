/*
*
* Copyright (c) 2012 Sunag Entertainment
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
	import flash.geom.Vector3D;
	
	import sunag.sea3d.SEA3D;
	import sunag.sea3d.object3d.LookAt;
	import sunag.sunag;
	import sunag.utils.ByteArray;
	
	use namespace sunag;
	
	public class SEASceneObject extends SEANode
	{
		public static const TYPE:String = "scene-object";
						
		public var parent:String;			
		public var animation:String;		
		public var instance:String;		
		public var color:int;
		public var position:Vector3D;		
		public var lookAt:LookAt;
		public var objectType:int = 0;
		
		public var properties:String;
		
		public function SEASceneObject(name:String, type:String, sea:SEA3D)
		{						
			super(name, type, sea);
		}
		
		protected override function read(data:ByteArray):void
		{
			super.read(data);
			
			parent = data.readUTFTiny();
			animation = data.readUTFTiny();	
			instance = data.readUTFTiny();	
			
			color = data.readUnsignedInt24();
			position = data.readVector3D();
		}
		
		public function get isStatic():Boolean
		{
			return (objectType & 1) != 0;
		}
		
		public function get instanceObj():SEASceneObject
		{
			return sea3d.getSEASceneObject(instance);
		}
		
		protected override function readToken(name:String, data:ByteArray):Boolean
		{
			if (super.readToken(name, data)) return true;
			
			switch(name)
			{
				case "properties":
					properties = data.readUTFTiny();
					return true;
					break;
				
				case "look-at":
					lookAt = LookAt.fromBytes(data);
					return true;
					break;	
				
				case "type":
					objectType = data.readUnsignedByte();
					return true;
					break;
				
				default:
					return false;
			}
			
			return true;
		}
	}
}