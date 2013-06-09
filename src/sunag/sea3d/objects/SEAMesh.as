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
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import sunag.sea3d.SEA;
	import sunag.utils.ByteArrayUtils;
	import sunag.sunag;
	
	use namespace sunag;
	
	public class SEAMesh extends SEAObject3D
	{
		public static const TYPE:String = "m3d";				
		
		public static const SKELETON:uint = 0x01;
		public static const SKELETON_ANIMATION:uint = 0x02;
		public static const VERTEX_ANIMATION:uint = 0x03;
		
		public static const MORPH:uint = 0x01;
		public static const MORPH_ANIMATION:uint = 0x02;
		
		public var transform:Matrix3D;		
		
		public var geometry:uint;
		public var material:Vector.<uint>;
		
		public var meshType:uint = 0;
		public var skeleton:uint;		
		public var skeletonAnimation:uint;
		public var vertexAnimation:uint;
		
		public var morphType:uint = 0;
		public var morph:uint;		
		public var morphAnimation:uint;
				
		public var useVertexColor:Boolean;
		public var vertexColor:uint;						
		
		public var min:Vector3D;
		public var max:Vector3D;
		
		public function SEAMesh(name:String, sea:SEA)
		{
			super(name, TYPE, sea);
		}			
		
		protected override function read(data:ByteArray):void
		{
			super.read(data);
						
			// MATERIAL
			if (attrib & 256)
			{
				material = new Vector.<uint>( data.readUnsignedByte() );					
				for (var i:int=0;i<material.length;i++)					
					material[i] = data.readUnsignedInt();	
			}
			
			// 1 = SKELETON
			// 2 = SKELETON_ANIMATION
			// 3 = VERTEX_ANIMATION
			switch(meshType = (attrib & 512) >> 9 | (attrib & 1024) >> 9)
			{
				case SKELETON:
					skeleton = data.readUnsignedInt();
					break;
				
				case SKELETON_ANIMATION:
					skeleton = data.readUnsignedInt();
					skeletonAnimation = data.readUnsignedInt();
					break;
				
				case VERTEX_ANIMATION:
					vertexAnimation = data.readUnsignedInt();
					break;
			}
			
			// 1 = MORPH
			// 2 = MORPH_ANIMATION			
			switch(morphType = (attrib & 2048) >> 11 | (attrib & 4096) >> 11)
			{
				case MORPH:
					morph = data.readUnsignedInt();
					break;
				
				case MORPH_ANIMATION:
					morph = data.readUnsignedInt();
					morphAnimation = data.readUnsignedInt();
					break;
			}
				
			// VERTEX_COLOR
			if (attrib & 8192)
			{
				useVertexColor = true;
				vertexColor = data.readUnsignedInt();
			}
			
			// BOUNDING_BOX
			if (attrib & 16384)
			{				
				min = ByteArrayUtils.readVector3D(data);
				max = ByteArrayUtils.readVector3D(data);	
			}
			
			transform = ByteArrayUtils.readMatrix3D(data);
			
			geometry = data.readUnsignedInt();
		}
	}
}
