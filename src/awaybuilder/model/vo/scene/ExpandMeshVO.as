package awaybuilder.model.vo.scene
{

    import away3d.core.base.SubMesh;
    import away3d.entities.Mesh;
    import away3d.materials.MaterialBase;
    
    import awaybuilder.utils.AssetUtil;
    
    import mx.collections.ArrayCollection;

	[Bindable]
    public class ExpandMeshVO extends ContainerVO
    {
			
		public var path:String;
		
		
		override public function clone():ObjectVO
        {
			var m:ExpandMeshVO = new ExpandMeshVO();
			m.fillFromMesh( this );
            return m;
        }
		
		public function fillFromMesh( asset:ExpandMeshVO ):void
		{
			this.fillFromObject( asset );
			this.path = asset.path;
		}
		
		
    }
}
