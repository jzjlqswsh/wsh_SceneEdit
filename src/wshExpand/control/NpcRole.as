package wshExpand.control 
{
	import away3d.core.pick.PickingColliderType;
	import away3d.events.MouseEvent3D;
	import com.Astart.Astart;
	import com.Astart.Node;
	import wshExpand.display.ExpandMesh;
	import wshExpand.sys.SceneManage;
	import wshExpand.utils.Functions;

	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class NpcRole extends Abstract_action
	{
		
		public function NpcRole() 
		{
			
		}
		
		override public function setV(mesh:ExpandMesh):void 
		{
			super.setV(mesh);
		}
		
		override public function initShow(ctn:*, posx:Number = 0, posy:Number = 0, posz:Number = 0):void 
		{
			super.initShow(ctn, posx, posy, posz);
			_myNode = Astart.myGrid.getNodeByXY(_myX, _myZ);
			//mesh.mouseChildren = true;
			mesh.mouseEnabled = true;
			
			mesh.pickingCollider = PickingColliderType.BOUNDS_ONLY;
			mesh.addEventListener(MouseEvent3D.CLICK, clickNpc);
			trace(mesh.mouseEnabled, "9999999999999999")
			gotoFrame("root");
		}
		
		private function clickNpc(e:MouseEvent3D):void 
		{
			trace("点击NPC");
			//得到附近最近的点
			var nodesArr:Array = getNodesByDis(_myNode, 1);
			var node:Node;
			var dis:Number;
			var minDis:Number = -1;
			var endNode:Node;
			for (var i:int = 0; i < nodesArr.length; i++ ) {
				node = nodesArr[i];
				if (node.walkAble) {
					dis = Functions.checkDisSQRT(node.x, node.y, 0, SceneManage.getInstance().player.myNode.x, SceneManage.getInstance().player.myNode.y, 0);
					if (minDis == -1 || dis < minDis) {
						endNode = node;
						minDis = dis;
						trace(dis,"9999999999999")
					}
				}
			}
			if(endNode){
				SceneManage.getInstance().enterToFight();
				//FightMainManage.getInstance().player.searchRodeFun(endNode);
			}
		}
		
		
		
		//根据攻击距离得到周围的格子
		public static function getNodesByDis(node:Node,dis:int = 1):Array
		{
			var attackDis:int = dis;
			//获取敌人目标
			var minHang:int = node.x - attackDis;
			var maxHang:int = node.x + attackDis;
			if (minHang < 0) {
				minHang = 0;
			}
			if (maxHang >= Astart.myGrid.row ) {
				maxHang = Astart.myGrid.row - 1;
			}
			var minLie:int = node.y - attackDis;
			var maxLie:int = node.y + attackDis;
			if (minLie < 0) {
				minLie = 0;
			}
			if (maxLie >= Astart.myGrid.col ) {
				maxLie = Astart.myGrid.col - 1;
			}
			var nodesArr:Array = [];
			var tempNode:Node;
			var i:int;
			var j:int;
			for ( i = minLie; i <= maxLie; i++ ) {
				for ( j = minHang; j <= maxHang; j++ ) {
					if ( Math.abs(j - node.x)<=attackDis && Math.abs(i - node.y) <= attackDis) {
						if (i != node.y || j != node.x) {
							tempNode = Astart.myGrid.nodes[i][j];
							nodesArr.push(tempNode);
						}
					}
				}
			}
			return nodesArr;
		}
		
		
		
		override public function deleteMe():void 
		{
			if (mesh) {
				mesh.removeEventListener(MouseEvent3D.CLICK, clickNpc);
			}
			super.deleteMe();
		}
		
		
		
		
	}

}