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

package sunag.sea3d.modules.objects
{
	import flash.geom.Vector3D;
	
	import sunag.sea3d.SEA3D;
	import sunag.sea3d.objects.SEANode;
	import sunag.sea3d.objects.SEASceneObject;
	import sunag.utils.ByteArray;

	public class SEAPath extends SEASceneObject 
	{		
		public static const TYPE:String = "path";
		
		public var vertex:Vector.<Number>;
		public var closed:Boolean;
		
		public function SEAPath(name:String, sea:SEA3D)
		{
			super(name, TYPE, sea);
		}	
		
		protected override function read(data:ByteArray):void
		{
			position = data.readVector3D();
			vertex = new Vector.<Number>(data.readUnsignedShort() * 3);
			closed = data.readBoolean();
			
			for (var i:int=0;i<vertex.length;i++)
				vertex[i] = data.readFloat();
		}
		
		public function toVector3D():Vector.<Vector3D>
		{			
			var data:Vector.<Vector3D> = new Vector.<Vector3D>(vertex.length / 3);
			
			for (var i:int=0;i<data.length;i++)
			{
				var pos:int = i * 3;
				data[i] = new Vector3D(vertex[pos], vertex[pos+1], vertex[pos+2]);
			}
			
			if (closed)
				data.push(new Vector3D(vertex[0], vertex[1], vertex[2]));
			
			return data;
		}
	}
}
