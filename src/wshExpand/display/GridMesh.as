package wshExpand.display 
{
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.TextureMultiPassMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class GridMesh extends Mesh 
	{
		
		private var _row:int;
		private var _col:int;
		private var _nodeWidth:int;
		private var _nodeHeight:int;
		private var _myId:int = 0;
		
		private var _nodes:Array = [];
		
		private var _bmdWidth:int = 1024;
		private var _bmdHeight:int = 1024;
		
		
		private var _myAlpha:Number = 0;
		
		public function GridMesh(rowNum:int,colNum:int,wid:int,hei:int) 
		{
			changeRowCol(rowNum, colNum);
			changeNodeSize(wid,hei);
			var material:TextureMaterial = getMyMaterial();
			material.alpha = _myAlpha;
			var geometry:PlaneGeometry =new PlaneGeometry(wid*colNum,hei*rowNum)
			super(geometry, material);
			initNodes();
		}
		
		public function updataUv():void
		{
			
		}
		
		//改变 网格大小
		public function changeNodeSize(wid:int,hei:int):void
		{
			_nodeWidth = wid;
			_nodeHeight = hei;
		}
		
		//改变 行 列 数量
		public function changeRowCol(rowNum:int,colNum:int):void
		{
			_row = rowNum;
			_col = colNum;
		}
		
		//设置网格信息
		public function changeNodesInfo(info:Array): void
		{
			_nodes = info;
			updataNodeShow();
		}
		
		//初始化网格
		private function initNodes():void
		{
			for (var i:int = 0; i < _row; i++ ) {
				_nodes[i] = [];
				for (var j:int = 0; j < _col; j++ ) {
					_nodes[i][j] = [0];
				}
			}
		}
		
		private function getMyMaterial():TextureMaterial
		{
			var wid:int = _bmdWidth / _col;
			var hei:int = _bmdHeight / _row;
			
			var bitmapData:BitmapData = new BitmapData(_bmdWidth, _bmdHeight, false, 0xffffff);
			for (var i:int = 0; i <= _row; i++ ) {
				bitmapData.fillRect(new Rectangle(0, i * hei - 1, bitmapData.width, 2), 0x000000);
				for (var j:int = 0; j <= _col; j++ ) {
					bitmapData.fillRect(new Rectangle(j * wid - 1, 0, 2, bitmapData.height), 0x000000);
				}
			}
			var planeMaterial:TextureMaterial = new TextureMaterial(new BitmapTexture(bitmapData));
			return planeMaterial;
		}
		
		//刷新网格信息
		private function updataNodeInfo():void
		{
			var tNodes:Array = [];
			var i:int;
			var j:int;
			for (i = 0; i < _row; i++ ) {
				if (!tNodes[i]) {
					tNodes[i] = [];
				}
				for (j = 0; j < _col; j++ ) {
					if (!tNodes[i][j]) {
						tNodes[i][j] = [0];
					}
				}
			}
			var offX:int = (_col - _nodes[0].length)/2;
			var offY:int = (_row - _nodes.length)/2;
			
			
			for (i = 0; i < _nodes.length; i++ ) {
				for (j = 0; j < _nodes[i].length; j++ ) {
					if (i + offY >= 0 && j + offX >= 0&&i+offY<_row&&j + offX <_col) {
						tNodes[i + offY][j + offX] = _nodes[i][j];
					}
				}
			}
			_nodes = tNodes;
		}
		
		//刷新网格显示
		public function updataNodeShow():void
		{
			updataNodeInfo();
			
			this.geometry = new PlaneGeometry(_nodeWidth * _col, _nodeHeight * _row);
			/*var myGeometry:PlaneGeometry = this.geometry as PlaneGeometry;
			myGeometry.width = _nodeWidth * _col;
			myGeometry.height = _nodeHeight * _row;*/
			
			var wid:Number = _bmdWidth / _col;
			var hei:Number = _bmdHeight / _row;
			
			var bitmapData:BitmapData = new BitmapData(_bmdWidth, _bmdHeight, false, 0xffffff);
			for (var i:int = 0; i <= _row; i++ ) {
				bitmapData.fillRect(new Rectangle(0, i * hei - 1, bitmapData.width, 2), 0x000000);
				for (var j:int = 0; j <= _col; j++ ) {
					bitmapData.fillRect(new Rectangle(j * wid - 1, 0, 2, bitmapData.height), 0x000000);
					if (_nodes[i] && _nodes[i][j] && _nodes[i][j][0] != 0) {
						bitmapData.fillRect(new Rectangle(j * wid+1, i * hei+1, wid-2, hei-2), nodeColorArr[_nodes[i][j][0]]);
					}
				}
			}
			var planeMaterial:TextureMaterial = new TextureMaterial(new BitmapTexture(bitmapData));
			(this.material as TextureMaterial).texture.dispose();
			planeMaterial.alpha = _myAlpha;
			this.material = planeMaterial;
		}
		
		public function setNodeState(hang:int,lie:int):void
		{
			_nodes[hang][lie] = [1];
			changeNodesInfo(_nodes);
			
			/*var wid:Number = _bmdWidth / _col;
			var hei:Number = _bmdHeight / _row;
			var bitmapData:BitmapData = ((this.material as TextureMultiPassMaterial).texture as BitmapTexture).bitmapData;
			bitmapData.fillRect(new Rectangle(lie * wid + 1, hang * hei + 1, wid - 2, hei - 2), 0xff0000);
			var planeMaterial:TextureMultiPassMaterial = new TextureMultiPassMaterial(new BitmapTexture(bitmapData));
			(this.material as TextureMultiPassMaterial).texture.dispose();
			this.material = planeMaterial;*/
		}
		
		
	
		
		
		
		private var nodeColorArr:Array = 
		[
			//白、红、橙、黄、绿、青、蓝、紫
			0xffffff,0xff0000,0xFF8000,0xFFFF00,0x00FF00,0x400000,0x0000FF,0x800080
		]
		
		
		
		public function getNodeInfoArr():Array
		{
			var arr:Array = [];
			arr[0] = [_row, _col, _nodeWidth, _nodeHeight];
			arr[1] = _nodes;
			return arr;
		}
		
		
		private function changeTexture():void
		{
			
		}
		
		public function get row():int 
		{
			return _row;
		}
		
		public function get col():int 
		{
			return _col;
		}
		
		public function get nodeWidth():int 
		{
			return _nodeWidth;
		}
		
		public function get nodeHeight():int 
		{
			return _nodeHeight;
		}
		
		
		
		
		
		
		
	}

}