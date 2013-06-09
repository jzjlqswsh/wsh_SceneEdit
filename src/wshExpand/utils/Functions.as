package wshExpand.utils
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	

	
	/**
	 * ...
	 * @author star 静态方法类
	 */
	public class Functions 
	{
		public function Functions() 
		{
			throw new Error("Functions 是一个静态类 无法实例化");
		}
		
		
		
		//==========================================================================================
		//								复制
		//==========================================================================================	
		
		
		
		// 深度复制
		public static function deepClone(source:Object):*
		{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return(myBA.readObject());
		}
		
		
		
		//==========================================================================================
		//								创建view
		//==========================================================================================	
		
		
		
		//==========================================================================================
		//								系统工具
		//==========================================================================================	
		
		
		
		// 本地转化为全局坐标
		public static function globalXY( who:DisplayObject ):Point
		{
			if ( who == null ) {
				throw new Error("Functions - globalXY 没有who");
			}
			
			var point:Point = new Point( who.x , who.y );
			var targetPoint:Point;
			if ( who.parent != null )  {
				targetPoint = who.parent.localToGlobal( point );
			} else {
				throw new Error("globalXY 传进的对象 不在现实列表哦");
			}
			return targetPoint;
		}
		
		// 得到相对坐标
		public static function localXY( who:DisplayObject, targetContainer:DisplayObjectContainer ):Point
		{
			var point1:Point = globalXY( who );
			var point2:Point = targetContainer.globalToLocal( point1 );
			return point2;
		}
		
		//得到相对坐标
		public static function localXYbyPoint(p:Point, targetContainer:DisplayObjectContainer ):Point
		{
			var point2:Point = targetContainer.globalToLocal( p );
			return point2;
		}
		
		//==========================================================================================
		//								 设置右键菜单
		//==========================================================================================
		/**
		 * 
		 * @param	arr     [ [  标题1名称,点击触发函数    ]  ,  [  标题2名称,点击触发函数    ]    ]
		 * @param	enjoinCheck  true 是 禁止一些默认显示的菜单 
		 * @return
		 */
		public static function setRightKeyMenu(arr:Array,enjoinCheck:Boolean=true):ContextMenu
		{
			
			var menu:ContextMenu = new ContextMenu();
			if (enjoinCheck) {
				menu.hideBuiltInItems();
			}
			//var addMenuItems:ContextMenuItem;
			
			var infoArr:Array;
			
			for (var i:int = 0 ; i < arr.length; i++ ) {
				infoArr = arr[i];
				var addMenuItems:ContextMenuItem = new ContextMenuItem(infoArr[0]);
				if (infoArr[1]) {
					addMenuItems.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, 
					function(e:Event):void {
						infoArr[1](e.currentTarget.caption);
						}
					);
				}
				
				menu.customItems.push(addMenuItems);
			}
			
			return menu;
			
		}
		
		
		///=================超链接
		public static function myGetURL():void
		{
            var myRequest:URLRequest = new URLRequest("http://www.sinyougame.com");
			navigateToURL(myRequest, "_blank");
		}
		
		//==========================================================================================
		//								文本工具
		//==========================================================================================	
		//给view添加一个text框
		//给view添加一个text框
		public static function addTextForView(view:MovieClip,str:String):void
		{
			if (!view.numText) {
				//设置View的数量
				var textNum:TextField = new TextField();
				view.numText = textNum;
				
				textNum.autoSize  = TextFieldAutoSize.LEFT;	//默认左对其
				textNum.width = 100;				//默认宽高
				
				textNum.selectable = false;			//不可选
				textNum.border = false;
				textNum.multiline = true;			//多行
				
				
				var textFormat:TextFormat = new TextFormat();
				textFormat.color = 0xffffff;
				textFormat.size = 12;
				
				textNum.defaultTextFormat = textFormat;
				
				
				//view.num = textNum;
				view.addChild(textNum);
			}
			view.numText.text = str;
			view.numText.mouseEnabled = false;
			view.numText.x = view.width - view.numText.width;
			view.numText.y = view.height - view.numText.height;
		}
		
		
		public static function addTextForView2(view:MovieClip,showCtn:Sprite,str:String):void
		{
			if (!view.numText) {
				//设置View的数量
				var textNum:TextField = new TextField();
				view.numText = textNum;
				
				textNum.autoSize  = TextFieldAutoSize.LEFT;	//默认左对其
				textNum.width = 100;				//默认宽高
				
				textNum.selectable = false;			//不可选
				textNum.border = false;
				textNum.multiline = true;			//多行
				
				
				
				
				var textFormat:TextFormat = new TextFormat();
				textFormat.color = 0xffffff;
				textFormat.size = 12;
				
				textNum.defaultTextFormat = textFormat;
				textNum.setTextFormat(textFormat);
				
				//view.num = textNum;
				showCtn.addChild(textNum);
			}
			view.numText.text = str;
			view.numText.mouseEnabled = false;
			view.numText.x = view.x /*- view.numText.width*/+view.width/2;
			view.numText.y = view.y - view.numText.height+view.height;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		//==========================================================================================
		//								数学工具
		//==========================================================================================	
		
		
		
		/**  2点之间的弧度
		 * 
		 * @param p1    以p1点为 (0, 0) 坐标
		 * @param p2	   目标点
		 * @return      弧度
		 * 
		 */		
		public static function checkRadian( p1:Array, p2:Array ):Number
		{
			var xdis:Number = p2[0] - p1[0];
			var ydis:Number = p2[1] - p1[1];
			return Math.atan2( ydis, xdis );
		}
		
		/**  三维 二维 通用检测距离
		 * 
		 * @param arr1  我的点 ( xyz )
		 * @param arr2  目标点 ( xyz )
		 * @return 距离
		 * 
		 */		
		public static function checkDis(pos1x:Number = 0, pos1y:Number = 0,pos1z:Number = 0,pos2x:Number = 0, pos2y:Number = 0,pos2z:Number = 0 ):Number
		{
			var disX:Number = pos1x - pos2x;
			var disY:Number = pos1y - pos2y;
			var disZ:Number = pos1z - pos2z;
			var disQ:Number = disX * disX + disY * disY + disZ * disZ;
			return Math.sqrt(disQ);
		}
		
		public static function checkDisSQRT(pos1x:Number = 0, pos1y:Number = 0,pos1z:Number = 0,pos2x:Number = 0, pos2y:Number = 0,pos2z:Number = 0 ):Number
		{
			var disX:Number = pos1x - pos2x;
			var disY:Number = pos1y - pos2y;
			var disZ:Number = pos1z - pos2z;
			var disQ:Number = disX * disX + disY * disY + disZ * disZ;
			return disQ;
		}
		
		// 返回和速度
		public static function checkAllSpeed( xS:Number, yS:Number, zS:Number ):Number
		{
			var all:Number = xS * xS + yS * yS + zS * zS;
			return Math.sqrt(all);
		}
		
		// 三维空间的速度分解
		public static function analyzeSpeed( speed:Number, pBegin:Array, pEnd:Array ):Array
		{
			// 以起始点为坐标系
			var disX:Number = pEnd[0] - pBegin[0];
			var disY:Number = pEnd[1] - pBegin[1];
			var disZ:Number = pEnd[2] - pBegin[2];
			
			// 计算xy的合长度
			var disXY:Number = Math.sqrt( disX * disX + disY * disY );
			
			// 计算 xy 与 z 的合角度
			if ( disXY == 0 ) disXY += 0.001;
			var radianXY_Z:Number = Math.atan( Math.abs(disZ) / Math.abs(disXY) );
			
			// 分解出 xy 与 z 的速度
			var z_speed:Number = speed * Math.sin(radianXY_Z);
			var xy_speed:Number = speed * Math.cos(radianXY_Z);
			
			// 分解出 x 与 y 的速度
			if ( disX == 0 ) disX += 0.001;
			var radianX_Y:Number = Math.atan( Math.abs(disY) / Math.abs(disX) );
			var y_speed:Number = xy_speed * Math.sin(radianX_Y);
			var x_speed:Number = xy_speed * Math.cos(radianX_Y);
			
			// 赋予3个方向的速度方向
			if ( disX < 0 ) x_speed *= -1;
			if ( disY < 0 ) y_speed *= -1;
			if ( disZ < 0 ) z_speed *= -1;
				
			return [x_speed, y_speed, z_speed];
		}
		
		
		//把第一个字母 转化为大写或者小写		0是转化为小写  1是转化为大写
		public static function turnFirstStrToUp(str:String,type:int = 0):String
		{
			var firstStr:String = str.slice(0, 1);
			var lastStr:String = str.slice(1);
			var newStr:String;
			if (type == 0) {
				return (firstStr.toLowerCase() + lastStr);
			} else {
				return (firstStr.toUpperCase() + lastStr);
			}
		}
		
		
		//把字符串解析为 数组
		public static function parseString(outPut:String):Array
		{
			if (outPut == "") {
				return [];
			}
			var allArr:Array = [];
			
			var index1:int = outPut.indexOf("[");
			var index2:int = outPut.indexOf("]");			
			
			while (outPut.indexOf("[") != -1) {
				
				index1 = outPut.indexOf("[");
				index2 = outPut.indexOf("]");
				
				var str:String = outPut.substring(index1 +1, index2 );
				allArr.push(parseString_2(str));
				
				if (index2 + 2 < outPut.length) {
					outPut = outPut.substring(index2 +2 );
				} else {
					outPut = ",";
				}				
			}					
			return  allArr;
		}
		
		
		//二次拆分							要拆分的字符				通过什么拆分		//是否转化为数字 默认为false
		public static  function parseString_2(str:String,splitByStr:String = ",",boo:Boolean = false):Array
		{
			var posArr:Array = [];
			//trace(str)
			if (!boo) {
				//搜寻str  把他进行分段 然后存入数组
				while (str.indexOf(",") != -1) {
					var pos:String = str.substr(0, str.indexOf(splitByStr));
					posArr.push(pos);
					str = str.substring(str.indexOf(splitByStr) + 1);
				}
				posArr.push(str);
			} else {
				//搜寻str  把他进行分段 然后存入数组
				while (str.indexOf(splitByStr) != -1) {
					var num:int = int(str.substr(0, str.indexOf(splitByStr)));
					posArr.push(num);
					str = str.substring(str.indexOf(splitByStr) + 1);
				}
				posArr.push(int(str));
			}
			
			return posArr;
		}
		
		//多维数组转化为字符串(是不带引号但是带中括号的字符串)
		/*public static function multiArrayToString(arr:Array):String
		{
			var str:String = "";
			for (var i:int = 0; i < arr.length; i++ ) {
				str += "[" + arr[i].toString() + "],"
			}
			return str.slice(0, str.length - 1);
		}*/
		
		// 2 3 维数组
		//多维数组转化为字符串(是不带引号但是带中括号的字符串)
		public static function multiArrayToString(arr:Array):String
		{
			
			if (!arr) {
				return null;
			}
			
			var str:String = "";
			for (var i:int = 0; i < arr.length; i++ ) {
				if (!arr[i] is Array) {
					str += "[" + arr[i].toString() + "],"
				}else {
					var str2:String ="";
					for (var j:int = 0; j < arr[i].length; j++ ) {
						str2 += "[" + arr[i][j].toString() + "],";
					}
					var str3:String = str2.slice(0, str2.length - 1);
				
					str += "[" + str3 + "],";
				}
				
			}
			return str.slice(0, str.length - 1);
		}
		
		
		//  字符串转数组
		//4维纯 int型数组转换  为数组
		public static function parseStringThree(str:String):Array
		{
			if (str == null) {
				return null;
			}
			var arr:Array = str.split("]],[[");    
			for (var i:int = 0; i < arr.length; i++ ) {
				if (arr[i].charAt(0) == "[") {
					arr[i] = arr[i].slice(2, arr[i].length);
				}else if (arr[i].charAt(arr[i].length-1) == "]"){
					arr[i] = arr[i].slice(0, arr[i].length-2);
				}
				arr[i] = arr[i].split("],[");
				for (var j:int = 0; j < arr[i].length; j++ ) {
					if (arr[i][j].length > 1) {
							arr[i][j] = arr[i][j].split(",");
						for (var k:int = 0; k < arr[i][j].length; k++ ) {
							arr[i][j][k] = int(arr[i][j][k]);
						}
					}else {
						arr[i][j] = int(arr[i][j]); 
					}
					
				}
			}
			return arr;
		}
		
		
		//去掉最外面一层[]
		public static function reduceOutString(arr:Array):String
		{
			var str:String = arrayToString(arr);
			
			str = str.slice(1, str.length - 1);
			return str;
		}
		
		
		//数组转化为字符串
		/**
		 * 
		 * @param	arr
		 * @param	yinhaoCheck   true 表示 输出的是带引号的   false 表示输出的是不带引号的
		 * @return
		 */
		public static function arrayToString旧(arr:Array,yinhaoCheck:Boolean = false):String
		{
			if (arr.length == 0) {
				return "[]";
			}
			var str:String = "[";
			
			var yinhao:String = '"';
			
			for (var i:int = 0; i < arr.length; i++ ) {
				//如果是数组
				if (arr[i] is Array) {
					str += arrayToString(arr[i],yinhaoCheck) + ",";
				} else {
					//如果需要输出引号
					if (yinhaoCheck) {
						if (arr[i] is String) {
							str += yinhao + arr[i].toString() + yinhao + ","
							
						} else {
							str +=  arr[i].toString() + ","
						}
					} else {
						str +=  arr[i].toString() + ","
					}
					
				}
			}
			str = str.slice(0, str.length - 1);
			str += "]";
			return str;
		}
		
		
		
		
		
		//将字符串转化为数组
		/**
		 * 
		 * @param	outPut 要输出的字符串，首先这个字符串的形式是 带"[ ]"标识 的 ，会根据[]  来把东西输出成对应的数据
		 * 			
		 * @return
		 */		//event_1,158,212,[123,444],1,2,3,4],[event_2,377,230,500,1,2,4,33,
		public static function stringToArray旧(outPut:String):Array
		{
			if (outPut == "") {
				return [];
			}
			var allArr:Array = [];
			
			
			var str:String;
			
			//替换所有的 空格符 换行符 等
			outPut = outPut.replace(/\s*,\s*/g, ",");
			outPut = outPut.replace(/\s*\[\s*/g, "[");
			outPut = outPut.replace(/\s*\]\s*/g, "]");
			
			
			var oldPut:String = outPut;
			//判断是不是有追尾的逗号    比如这种形式的逗号  [1,2,]
			if (outPut.slice(outPut.length - 2, outPut.length - 1) == ",") {
				outPut = outPut.substring(0, outPut.length - 2) + "]";
				trace("追尾了-----------------------------",oldPut,"a+a+a+",outPut)
			}
			
			outPut = outPut.slice(1, outPut.length -1);
			outPut += ",";
			
			while (outPut.length > 0) {
				//如果 是数组  找到这个数组的范围  搜寻具有相同数量的中括号
				if (outPut.slice(0, 1) == "[") {
					
					var zuo:int = 1;
					var you:int = 0;
					str = outPut.concat();
					
					var count:int = 0;
					//必须要左中括号的数量不等于又中括号的数量我才搜寻
				a:	while (zuo != you) {
						count++;
						if (str.slice(count, count+1) == "[") {
							zuo++;
						}
						if (str.slice(count,count +1) == "]") {
							you++;
						}
						if (zuo == you) {
							break a;
						}
					}
					str = outPut.slice(0, count+1);
					outPut = outPut.slice(count + 2);
					allArr.push(stringToArray(str));
					
				} else {
					str = outPut.slice(0, outPut.indexOf(","));
					outPut = outPut.slice(outPut.indexOf(",") +1);
					if (Number(str) ) {
						allArr.push(Number(str));
					} else if(str == "0"){
						allArr.push(Number(str));
					} else {
						allArr.push(str);
					}
					
				}
			}
			
			return allArr;
			
		}
		
		
		
		
		
		
		
		//数组转化为字符串 2012-4-16
		/**
		 * 
		 * @param	arr
		 * @param	yinhaoCheck   true 表示 输出的是带引号的   false 表示输出的是不带引号的
		 * @return
		 */
		public static function arrayToString(arr:Array,yinhaoCheck:Boolean = false):String
		{
			if (!arr ) {
				return "";
			}
			if (arr.length == 0) {
				return "[]";
			}
			var str:String = "[";
			
			var yinhao:String = '"';
			
			for (var i:int = 0; i < arr.length; i++ ) {
				//如果是数组
				if (arr[i] is Array) {
					str += arrayToString(arr[i],yinhaoCheck) + ",";
				} else {
					//如果需要输出引号
					if (yinhaoCheck) {
						if (arr[i] is String) {
							str += yinhao + arr[i].toString() + yinhao + ","
							
						} else {
							str +=  arr[i].toString() + ","
						}
					} else {
						if (arr[i] == null) {
							continue;
						}
						str +=  arr[i] + ",";
					}
					
				}
			}
			str = str.slice(0, str.length - 1);
			str += "]";
			return str;
		}
		
		 
		//将字符串转化为数组     2012-4-16
		/**
		 * 
		 * @param	outPut 要输出的字符串，首先这个字符串的形式是 带"[ ]"标识 的 ，会根据[]  来把东西输出成对应的数据
		 * 			
		 * @return
		 */
		
		public static function stringToArray(outPut:String):Array
		{
			if (outPut == "") {
				return [];
			}
			
			if (outPut == "[]") {
				return [];
			}
			var allArr:Array = [];
			
			
			var str:String;
			
			//替换所有的 空格符 换行符 等
			outPut = outPut.replace(/\s*,\s*/g, ",");
			outPut = outPut.replace(/\s*\[\s*/g, "[");
			outPut = outPut.replace(/\s*\]\s*/g, "]");
			
			var oldPut:String = outPut;
			//判断是不是有追尾的逗号    比如这种形式的逗号  [1,2,]
			if (outPut.slice(outPut.length - 2, outPut.length - 1) == ",") {
				outPut = outPut.substring(0, outPut.length - 2) + "]";
				trace("追尾了-----------------------------",oldPut,"a+a+a+",outPut)
			}
			
			outPut = outPut.slice(1, outPut.length -1);
			outPut += ",";
			
			while (outPut.length > 0) {
				//如果 是数组  找到这个数组的范围  搜寻具有相同数量的中括号
				if (outPut.slice(0, 1) == "[") {
					
					var zuo:int = 1;
					var you:int = 0;
					str = outPut.concat();
					
					var count:int = 0;
					//必须要左中括号的数量不等于又中括号的数量我才搜寻
				a:	while (zuo != you) {
						count++;
						if (str.slice(count, count+1) == "[") {
							zuo++;
						}
						if (str.slice(count,count +1) == "]") {
							you++;
						}
						if (zuo == you) {
							break a;
						}
					}
					str = outPut.slice(0, count+1);
					outPut = outPut.slice(count + 2);
					allArr.push(stringToArray(str));
					
				} else {
					str = outPut.slice(0, outPut.indexOf(","));
					outPut = outPut.slice(outPut.indexOf(",") +1);
					if (Number(str) ) {
						allArr.push(Number(str));
					} else if(str == "0"){
						allArr.push(Number(str));
					} else {
						allArr.push(str);
					}
					
				}
			}
			return allArr;
		}
		
		
		
		import com.adobe.serialization.json.JSONDecoder;
		import com.adobe.serialization.json.JSONEncoder;
		
		//obj 转化成字符串
		public static function objectToString(obj:Object):String
		{
			
			var jsonEn:JSONEncoder = new JSONEncoder(obj);

			var jsonStr:String = jsonEn.getString();
			return jsonStr;
		}
		
		//字符串转化成obj
		public static function stringToObject(str:String):Object
		{
			if (!str || str == "" ) {
				return null;
			}
			//把字符串还原成 object
			var jsonDe:JSONDecoder = new JSONDecoder(str,false);

			var obj2:Object = jsonDe.getValue();//反序列化
			return obj2;
		}
		
		
		
		
	}
	
}