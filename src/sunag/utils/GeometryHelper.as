package sunag.utils
{
	import away3d.core.base.Geometry;
	import away3d.core.base.SubGeometry;

	public class GeometryHelper
	{
		public static function unifyFaces(geometry:Geometry):Geometry 
		{
			var i:int,
				vertexOffset:uint = 0,				
				sub:SubGeometry;
			
			var vertex:Vector.<Number> = new Vector.<Number>();
			var indexes:Vector.<uint> = new Vector.<uint>();
						
			for each(sub in geometry.subGeometries)
			{
				var vertexData:Vector.<Number> = sub.vertexData;				
				var indexData:Vector.<uint> = sub.indexData;
				
				for (i = 0; i < vertexData.length; i++)
					vertex.push(vertexData[i]);
				
				for (i = 0; i < indexData.length; i++)
					indexes.push(indexData[i]+vertexOffset);
												
				vertexOffset += vertexData.length/3;
			}
			
			var geo:Geometry = new Geometry();
			
			sub = new SubGeometry();
			sub.updateVertexData(vertex);
			sub.updateIndexData(indexes);
			
			geo.addSubGeometry(sub);
			
			return geo;
		}
	}
}