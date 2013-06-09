package wshExpand.utils 
{
	import away3d.animators.data.Skeleton;
	import away3d.arcane;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.ISubGeometry;
	import away3d.core.base.SkinnedSubGeometry;
	import away3d.core.base.SubGeometry;
	import away3d.core.base.SubGeometryBase;
	import away3d.core.math.Quaternion;
	import away3d.entities.Mesh;
	
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	
	import sunag.sea3d.mesh.MeshData;
	import sunag.sea3d.mesh.SubMesh;
	import sunag.sea3d.mesh.UVData;
	import sunag.sea3d.mesh.UVIndex;
	import sunag.sea3d.mesh.WeightData;
	import sunag.sea3d.objects.SEAMesh;
	import sunag.sea3d.objects.SEAVertexAnimation;
	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class Utils_away3d 
	{
		
		public function Utils_away3d() 
		{
			
		}
		
		//得到屏幕截图
		public static function getScreenshot3D(view3D:View3D):BitmapData
		{
			var bitmapData : BitmapData = new BitmapData(view3D.width, view3D.height, false, 0x000000); 
			view3D.renderer.queueSnapshot(bitmapData); 
			//var stageBitmap : Bitmap = new Bitmap(bitmapData);
			return bitmapData;
		}
		
		//将一个数处理为最接近的2的幂 
		public static function getTwoPowerNumber(sourceNum:int):int
		{
			var i:int = 0;
			while (sourceNum > Math.pow(2, i)) {
				i++;
			}
			return  Math.pow(2, i);
		}
		
		
		public static function getMeshInfoXYZ(mesh:ObjectContainer3D):Array
		{
			
			var minXArr:Array = [];
			var minYArr:Array = [];
			var minZArr:Array = [];
			var maxXArr:Array = [];
			var maxYArr:Array = [];
			var maxZArr:Array = [];
			var arr:Array = [minXArr, minYArr, minZArr, maxXArr, maxYArr, maxZArr];
			var child:Mesh;
			var i:int = 0;
			for (i = 0; i < mesh.numChildren; i++ ) {
				if (mesh.getChildAt(i) is Mesh) {
					child = mesh.getChildAt(i) as Mesh;
					minXArr.push(child.minX);
					minYArr.push(child.minY);
					minZArr.push(child.minZ);
					maxXArr.push(child.maxX);
					maxYArr.push(child.maxY);
					maxZArr.push(child.maxZ);
				}
			}
			var resurtArr:Array = [];
			for (i = 0; i < arr.length; i++ ) {
				arr[i].sort();
				if (i < 3) {
					resurtArr.push(arr[i][0]);
				}else {
					resurtArr.push(arr[i][arr[i].length-1]);
				}
				
			}
			return resurtArr;
		}
		
//		public static function buildNewGeometry(sea:SEAMesh,skeletonSea:SEAMesh):Geometry
//		{		
//			var geometry:Geometry = new Geometry();
//			
//			var i:int, j:int, u:Number, v:Number;		
//			
//			var vertex:Vector.<Number> = sea.vertex;		
//			var normal:Vector.<Number> = sea.normal;
//			var faceNormal:Vector.<Number> = sea.faceNormal;
//			var tangent:Vector.<Number> = sea.tangent; 
//			var uvData:Vector.<UVData> = sea.uv;
//			var morphData:Vector.<MeshData> = sea.morph;			
//
//			
//			for(var subMeshIndex:int=0;subMeshIndex<sea.subMesh.length;subMeshIndex++)
//			{		
//				var subMesh:sunag.sea3d.mesh.SubMesh = sea.subMesh[subMeshIndex];
//				
//				var indexData:Vector.<uint> = new Vector.<uint>();			
//				var verts:Vector.<Number> = new Vector.<Number>();
//				var norms:Vector.<Number> = normal || faceNormal ? new Vector.<Number>() : null;			
//				var tang:Vector.<Number> = tangent ? new Vector.<Number>() : null;
//				var jointWeights:Vector.<Number> = skeletonSea.skeleton ? new Vector.<Number>() : null;
//				var jointIndices:Vector.<Number> = skeletonSea.skeleton ? new Vector.<Number>() : null;
//				var uvs:Vector.<Vector.<Number>> = uvData ? new Vector.<Vector.<Number>>(uvData.length) : null;							
//				var cacheIndex:Object = {}			
//				var indexAt:uint = 0;								
//				
//				var anmVerts:Vector.<Vector.<Number>>;
//				var anmNorms:Vector.<Vector.<Number>>;
//				
//				var morphVerts:Vector.<Vector.<Number>>;
//				var morphNorms:Vector.<Vector.<Number>>;
//				
//				for(i=0;i<uvs.length;i++)							
//					uvs[i] = new Vector.<Number>();				
//				
//				
//				if (morphData)
//				{
//					morphVerts = new Vector.<Vector.<Number>>(morphData.length);
//					
//					for(i=0;i<morphVerts.length;i++)								
//						morphVerts[i] = new Vector.<Number>();	
//					
//					if (norms)
//					{
//						morphNorms = new Vector.<Vector.<Number>>(morphData.length);
//						
//						for(i=0;i<morphVerts.length;i++)								
//							morphNorms[i] = new Vector.<Number>();	
//					}									
//				}																							
//				
//				var vertexIndex:Vector.<uint> = subMesh.vertexIndex;		
//				var uvIndex:Vector.<UVIndex> = subMesh.uvIndex;	
//				var normalIndex:Vector.<uint> = subMesh.normalIndex;
//				
//				for(i=0;i<vertexIndex.length;i++)
//				{							
//					// BuildID
//					var id:String = vertexIndex[i].toString();
//					
//					for(j=0;j<uvIndex.length;j++)
//						id += "/" + uvIndex[j].data[i];					
//				
//					if (normalIndex)
//						id += "/" + normalIndex[i];
//					
//					if (!cacheIndex[id])
//					{
//						// AddInCache <SharedIndex>
//						cacheIndex[id] = indexAt;
//						
//						// Vertex
//						var index:uint = vertexIndex[i] * 3, nIndex:uint, indexUV:uint;										
//						verts.push(vertex[index], vertex[index+1], vertex[index+2]);
//						
//						// UVs
//						for(j=0;j<uvs.length;j++) {
//							indexUV = uvIndex[j].data[i] * 2;									
//							uvs[j].push(uvData[j].data[indexUV], uvData[j].data[indexUV+1]);	
//						}
//						
//						// Face Normal
//						if (faceNormal)
//						{
//							nIndex = normalIndex[i] * 3;
//							norms.push(faceNormal[nIndex], faceNormal[nIndex+1], faceNormal[nIndex+2]);
//						}
//						// Vertex Normal
//						else if (normal) 
//						{
//							norms.push(normal[index], normal[index+1], normal[index+2]);					
//						}
//						
//						// Tangent
//						if (tang)
//						{
//							tang.push(tangent[index], tangent[index+1], tangent[index+2]);
//						}
//						
//						// Joint/Weight
//						if (skeletonSea.skeleton)
//						{
//							var ske:Skeleton;
//							
//							var weightData:WeightData = skeletonSea.weight[vertexIndex[i]];
//							var weightCount:int = weightData.count;						
//							
//							for(j=0;j<weightCount;j++) {
//								jointIndices.push(weightData.joint[j] * 3);
//								jointWeights.push(weightData.bias[j]);							
//							}
//							
//							for(;j<sea.maxJointCount;j++) {
//								jointIndices.push(0);
//								jointWeights.push(0);
//							}
//						}
//						
//						
//						// Morpher Vertex
//						if (morphVerts)	
//						{
//							for(j=0;j<morphVerts.length;j++) {
//								morphVerts[j].push
//									(
//										morphData[j].vertex[index], 
//										morphData[j].vertex[index+1], 
//										morphData[j].vertex[index+2]
//									);		
//							}											
//											
//							// Custom Normal
//							if (morphNorms)
//							{
//								if (faceNormal)
//								{
//									for(j=0;j<morphNorms.length;j++) {
//										morphNorms[j].push
//											(
//												morphData[j].normal[nIndex], 
//												morphData[j].normal[nIndex+1], 
//												morphData[j].normal[nIndex+2]
//											);
//									}
//								}
//								else
//								{							
//									for(j=0;j<morphNorms.length;j++) {
//										morphNorms[j].push
//											(
//												morphData[j].normal[index], 
//												morphData[j].normal[index+1], 
//												morphData[j].normal[index+2]
//											);	
//									}
//								}
//							}
//						}
//						// Index					
//						indexData.push(indexAt++);			
//					}
//					else
//					{
//						indexData.push(cacheIndex[id]);
//					}
//				}
//				
//				var containsNormal:Boolean = norms != null;
//				var containsTangent:Boolean = tang != null;
//				var containsUV:Boolean =  uvs.length > 0;				
//				
//				var uv:Vector.<Number> = containsUV ? uvs[0] : null;
//				var subGeo:SubGeometryBase;
//				
//				if (skeletonSea.skeleton)
//				{
//					var skinSubGeo:SkinnedSubGeometry = new SkinnedSubGeometry(skeletonSea.maxJointCount);
//					
//					skinSubGeo.updateIndexData(indexData);					
//					skinSubGeo.fromVectors(verts, uv, norms, tang);										
//					
//					skinSubGeo.arcane::updateJointIndexData(jointIndices);
//					skinSubGeo.arcane::updateJointWeightsData(jointWeights);
//					
//					subGeo = skinSubGeo;
//				}
//				else
//				{
//					var stdSubGeo:SubGeometry;
//					
//					stdSubGeo = new SubGeometry();
//					
//					stdSubGeo.updateVertexData(verts);
//					stdSubGeo.updateIndexData(indexData);
//					
//					if (containsUV)
//					{
//						stdSubGeo.updateUVData(uv);
//						
//						if (uvs.length > 1) 
//							stdSubGeo.updateSecondaryUVData(uvs[1]);
//					}
//					
//					if (norms) 
//					{
//						stdSubGeo.updateVertexNormalData(norms);
//						
//					}
//					
//					if (tang) 
//						stdSubGeo.updateVertexTangentData(tang);	
//					
//					subGeo = stdSubGeo;
//				}
//				
//				subGeo.autoGenerateDummyUVs = !containsUV;
//				subGeo.autoDeriveVertexNormals = !containsNormal;
//				subGeo.autoDeriveVertexTangents = !containsTangent;
//				
//				geometry.addSubGeometry(subGeo as ISubGeometry);
//			}
//			return geometry;
//		}
		
		
	}

}