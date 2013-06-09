package wshExpand.utils
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author star
	 */
	public class Equation
	{
		
		public function Equation()
		{
			throw new Error( "Equation 是一个静态类不能实例化" );
		}
		
		
		
		// 弧度转化为 数学里面的 小的角
		public static function transToSmallRadian( num:Number ):Number
		{
			var result:Number;
			
			if ( num > 0 && num < Math.PI / 2 ) {
				result = num;
			} else if ( num > -Math.PI && num < -Math.PI / 2 ) {
				result = Math.PI - Math.abs(num);
			} else if ( num > -Math.PI/2 && num < 0 ) {
				result = num;
			} else if ( num > Math.PI/2 && num < Math.PI ) {
				result = -(Math.PI - num);
			}
			
			return result;
 		}
		
		// 弧度转化为 垂线的角
		public static function transToSmallVerticalRadian( num:Number ):Number
		{
			var result:Number;
			
			result = transToSmallRadian( num );
			
			if ( result > 0 && result < Math.PI / 2 ) {
				result = -( Math.PI/2 - result ); 
			} else if ( result > -Math.PI && result < -Math.PI / 2 ) {
				result = -( Math.PI/2 - (Math.PI - Math.abs(result)) );
			} else if ( result > -Math.PI/2 && result < 0 ) {
				result = Math.PI/2 - Math.abs(result);
			} else if ( result > Math.PI/2 && result < Math.PI ) {
				result = Math.PI/2 - (Math.PI - result);
			}
			
			return result;
 		}
		
		
		//三角形 已知正切值和对边 求斜边的长
		public static function triangleLength(tan:Number,a:Number ):Number
		{
			var c:Number;
			c = a * Math.sqrt(tan * tan + 1) / tan;
			return c;
		}
		
		
		// 建立一元一次方程
		public static function creat_1_1_a( startP:Point, radian:Number, haveArea:Boolean = false ):Object
		{
			var eqObj:Object = { };
			
			// 方程式
			// a * x + b * y + c = 0;
			
			// 限制定义域
			eqObj.haveArea = true;
			
			// 竖向方程
			if ( radian == Math.PI/2 ) {
				eqObj.typ = "plumb";
				eqObj.a = 1;
				eqObj.b = 0;
				eqObj.c = -startP.x;
			// 横向方程
			} else if ( radian == 0 ) {
				eqObj.typ = "level";
				eqObj.a = 0;
				eqObj.b = 1;
				eqObj.c = -startP.y;
			// 普通方程
			} else {
				eqObj.typ = "normal";
				// 规定为1
				eqObj.b = 1;
				
				eqObj.a = -Math.tan(radian);
				eqObj.c = -eqObj.a * startP.x - startP.y;
			}
			
			// 检查 point 是否在 定义域内
			eqObj.inArea = function( p:Point ):Boolean {
				return true;
				
				// 下面一句 很奇怪的可以注释掉
				//return true;
			}
			
			return eqObj;
		}
		
		// 建立一元一次方程
		public static function creat_1_1_b( startP:Point, endP:Point, haveArea:Boolean = true ):Object
		{
			var eqObj:Object = { };
			
			// 方程式
			// a * x + b * y + c = 0;
			
			// 限制定义域
			eqObj.haveArea = true;
			
			// 竖向方程
			if ( startP.x == endP.x ) {
				eqObj.typ = "plumb";
				eqObj.a = 1;
				eqObj.b = 0;
				eqObj.c = -endP.x;
			// 横向方程
			} else if ( startP.y == endP.y ) {
				eqObj.typ = "level";
				eqObj.a = 0;
				eqObj.b = 1;
				eqObj.c = -endP.y;
			// 普通方程
			} else {
				eqObj.typ = "normal";
				// 规定为1
				eqObj.b = 1;
				// - a / b = (y2- y1) / ( x2 - x1 )
				eqObj.a = - ( endP.y - startP.y ) / ( endP.x - startP.x );
				// c = -a x + y;
				eqObj.c = -eqObj.a * startP.x - startP.y;
			}
			
			// 检查 point 是否在 定义域内
			eqObj.inArea = function( p:Point ):Boolean {
				// 有定义域限制
				if ( eqObj.haveArea ) {
					// 是否在X轴
					var inX:Boolean;
					if ( p.x <= startP.x && p.x >= endP.x ) {
						inX = true;
					} else if ( p.x >= startP.x && p.x <= endP.x ) {
						inX = true;
					}
					
					// 是否在Y轴
					var inY:Boolean;
					if ( p.y <= startP.y && p.y >= endP.y ) {
						inY = true;
					} else if ( p.y >= startP.y && p.y <= endP.y ) {
						inY = true;
					}
					
					// 同时在定义域 x y 满足
					if ( inX && inY ) {
						return true;
					} else {
						return false;
					}
				// 没定义域限制
				} else {
					return true;
				}
				
				// 下面一句 很奇怪的可以注释掉
				//return true;
			}
			
			return eqObj;
		}
		
		//已知2直线 求其夹角的正切值  
		public static function lineTangent(eq1:Object, eq2:Object):Number
		{
			var tan:Number = 0;
			var k1:Number ;
			var k2:Number ;
			if(eq1.b == 0 && eq2.a != 0) {
				tan  = eq2.b / eq2.a;
				return tan;
			} 
			if(eq2.b == 0 && eq1.a != 0) {
				tan  = eq1.b / eq1.a;
				return tan;
			}else {
				k1 = -eq1.a / eq1.b;
				k2 = -eq2.a / eq2.b;
				
				tan = (k2 - k1) / (k2 * k1 + 1);
				return tan;
			}		
			return tan;
		}
		
		
		// 判断2个一元一次方程的交点
		public static function pointOf( eqObj1:Object, eqObj2:Object ):Point
		{
			var p:Point;
			
			// 2条平行线
			if ( eqObj1.a == 0 && eqObj2.a == 0 ) {
				return null;
			// 1条平行线
			} else if ( eqObj1.typ == "level" ) {
				p = new Point();
				p.y = -eqObj1.c;
				p.x = ( -eqObj2.c - eqObj2.b * p.y ) / eqObj2.a;
			// 1条平行线
			} else if ( eqObj2.typ == "level" ) {
				p = new Point();
				p.y = -eqObj2.c;
				p.x = ( -eqObj1.c - eqObj1.b * p.y ) / eqObj1.a;
			} else if ( eqObj1.typ != "level" && eqObj2.typ != "level" ) {
				p = new Point();
				if ( eqObj1.typ == "plumb" ) {
					p.x = -eqObj1.c; 
					p.y = ( -eqObj2.c - eqObj2.a * p.x ) / eqObj2.b;
				} else if ( eqObj2.typ == "plumb" ) {
					p.x = -eqObj2.c; 
					p.y = ( -eqObj1.c - eqObj1.a * p.x ) / eqObj1.b;
				} else {
					p.y = ( eqObj2.c / eqObj2.a - eqObj1.c / eqObj1.a ) / ( eqObj1.b / eqObj1.a - eqObj2.b / eqObj2.a );
					p.x = ( -eqObj1.c - eqObj1.b * p.y ) / eqObj1.a;
				}
			}
			
			if ( p == null ) {
				return null;
			// 检查是否在2者的 定义域
			} else if ( eqObj1.inArea(p) && eqObj2.inArea(p) ) {
				return p;
			} else {
				return null;
			}
				
			return null;
		}
		
		
		//平面2点间的距离
		public static function pointDistance(p1:Point, p2:Point):Number
		{
			var dis:Number = Math.sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
			return dis;
		}
		
		
		//过一点做已知直线的垂线
		public static function plumbLine(p:Point, eqobj:Object):Object
		{
			var eq:Object ;
			//3种情况
			if (eqobj.typ == "level" ) {
				 eq = Equation.creat_1_1_a(p, Math.PI / 2);
			} else if ( eqobj.typ == "plumb" ) {
				 eq = Equation.creat_1_1_a(p, 0);
			} else {				 
				eq  = {};
				eq.a = eqobj.b;
				eq.b = -eqobj.a;
				eq.c = eqobj.a * p.y - eqobj.b * p.x;
				eq.typ = "normal";
				eq.haveArea = false;	
				// 检查 point 是否在 定义域内
				eq.inArea = function( p:Point ):Boolean {
					return true;
					
					// 下面一句 很奇怪的可以注释掉
					//return true;
				}
			}
			return eq;		
		}
		
		//点到直线的距离  tpy 类型 默认值为0 就是距离的绝对值， 1  和 2是相对距离 有正负的
		public static function pointLineDistance(p:Point, eqobj:Object, tpy:int = 0 ):Number 
		{					
			var distance:Number;
			if (tpy == 0) {
				distance= Math.abs(eqobj.a * p.x + eqobj.b * p.y + eqobj.c) / Math.sqrt(
								eqobj.a * eqobj.a + eqobj.b * eqobj.b);
				
			} else if (tpy == 1) {
				distance = (eqobj.a * p.x + eqobj.b * p.y + eqobj.c) / Math.sqrt(
								eqobj.a * eqobj.a + eqobj.b * eqobj.b);
				
			} else if (tpy == 2) {
				distance = -(eqobj.a * p.x + eqobj.b * p.y + eqobj.c) / Math.sqrt(
							eqobj.a * eqobj.a + eqobj.b * eqobj.b);
			
			}
			return distance;
		}
		
		//修正坐标 到直线的距离 小于半径 然后修正到刚好等于半径
		public static function adjustPosByLine(p:Point,dis:Number,r:Number,ang:Number,eq:Object):Point 
		{
			var angDis:Number = ang - eq.angle;
			var length:Number =  (r - dis * eq.type)/Math.abs(Math.sin(angDis));
			p.x -= length * Math.cos(ang);
			p.y -= length * Math.sin(ang);
			
			return p;
			
		}	
		
		//过点做目标直线的垂线，判断垂线和目标直线是否有交点 
		public static function checkPlumbPoint(p:Point,eq:Object):Boolean
		{
			var plumbLine:Object = Equation.plumbLine(p, eq);
			if (Equation.pointOf(plumbLine, eq) == null) {
				return false;
			}
			else return true;
		}
		
		//过点做 目标2点所在直线的垂线 判断垂线和目标直线是否有交点
		public static function checkPointByThreePoint(p:Point,lineP1:Point,linep2:Point):Boolean
		{
			
			var line:Object = creat_1_1_b(lineP1, linep2);
			
			var plumbLine:Object = Equation.plumbLine(p, line);
			if (Equation.pointOf(plumbLine, line) == null) {
				return false;
			}
			else return true;
		}
		
		
		
		//判断1点到已知2点的直接上的最小距离 如果  点与直线没有交点  返回 到直线顶点的最小距离
		public static function pointLineDistance2(p:Point,lineP1:Point,lineP2:Point):Number
		{
			var line:Object = creat_1_1_b(lineP1, lineP2);
			//如果点和直线有交点  那么返回点到直线的距离
			if (checkPlumbPoint(p, line)) {
				return pointLineDistance(p, line);
			//否则返回点到2端点的距离
			} else {
				var dis1:Number = (lineP1.x - p.x) * (lineP1.x - p.x) + (lineP1.y - p.y) * (lineP1.y - p.y);
				var dis2:Number = (lineP2.x - p.x) * (lineP2.x - p.x) + (lineP2.y - p.y) * (lineP2.y - p.y);
				
				var dis:Number = Math.min(dis1, dis2);
				
				return Math.sqrt(dis);
			}
			
			return 0;
			
		}
		
		
		// 计算一点关于另外一点的对称点
		public static function symmetryByPAToPB(pa:Array,pb:Array):Array
		{
			var arr:Array = [];
			arr[0] = 2 * pb[0] - pa[0];
			arr[1] = 2 * pb[1] - pa[1];
			if (pb[2] != null) {
				arr[2] = 2 * pb[2] - pa[2];
			}
			
			return arr;
			
		}
		
		
		
		
		//过一点 作已知直线垂线， 求出交点
		public static function getPlumbPoint(p:Point, eq:Object):Point
		{
			var line:Object = plumbLine(p, eq);
			eq.haveArea = false;
			return pointOf(line, eq);
		}
		
		
		
		
		//圆与直线交点的求法					圆心				半径	直线	直线方向的角度 类型 1是 正方向交点 -1 是反方向交点	
		public static function roundLinePointof(centrePoint:Point,r:Number, eq:Object,ang:Number,type:Number):Point
		{
			//圆心到直线距离
			var dis:Number = pointLineDistance(centrePoint, eq);
			
			//调整的长度
			var length:Number = Math.sqrt(r * r - dis * dis);
			
			//过圆心作直线的垂线
			var plumb:Object = plumbLine(centrePoint, eq);
			
			//垂线与 已知直线的交点；
			var point1:Point = pointOf(eq, plumb);
			
			//圆与直线的交点
			var pointoff:Point = new Point();
			
			pointoff.x = point1.x +length * type * Math.cos(ang);
			pointoff.y = point1.y + length * type * Math.sin(ang);
			
			return pointoff;
		}
		
		//判断三点的位置关系 中间一点是否在2点之间
		public static function check3PointPos(p1:Point, p2:Point, p3:Point,type:int = 0):Boolean
		{
			var xCheck:Boolean;
			var yCheck:Boolean;
			if (type == 0) {
				if (p2.x <= p1.x && p2.x >= p3.x) {
					xCheck = true;
				} else if(p2.x <= p3.x && p2.x >= p1.x) {
					xCheck = true;
				} else {
					xCheck = false;
				}
				if (p2.y <= p1.y && p2.y >= p3.y) {
					yCheck = true;
				} else if(p2.y <= p3.y && p2.y >= p1.y) {
					yCheck = true;
				} else {
					yCheck = false;
				}
				if (xCheck && yCheck) {
					return true;
				}
				else return false;
			} else {
				if (p2.x < p1.x && p2.x > p3.x) {
					xCheck = true;
				} else if(p2.x < p3.x && p2.x > p1.x) {
					xCheck = true;
				} else {
					xCheck = false;
				}
				if (p2.y < p1.y && p2.y > p3.y) {
					yCheck = true;
				} else if(p2.y < p3.y && p2.y > p1.y) {
					yCheck = true;
				} else {
					yCheck = false;
				}
				if (xCheck && yCheck) {
					return true;
				}
				else return false;
			}
			
		}
		
		
		// 算抛物线方程 参数为 起点 终点 顶点 重力
		public static function creat_2_2( pa:Point, pb:Point, pc:Point, g:Number ):Object
		{
			var eqObj:Object = { };
			// 求方程参数
			// 方程
			// y = a (x -  b)^ + c
			// y1 = a ( x1 - b )^ + c
			// y2 = a ( x2 - b )^ + c
			// 顶点 x3 y3
			// y3 = c
			// y1 - y3 = a ( x1 - b )^
			// y2 - y3 = a ( x2 - b )^
			// 2式相除
			//  y1 - y3     x1 - b
			// --------- = --------- ^
			//  y2 - y3     x2 - b
			
			//  b - x1                  y1 - y3
			// --------- = Math.sqrt(-----------)
			// x2 - b			    y2 - y3
			// b = (x2 * Math.sqrt((y1 - y3)/(y2 - y3)) + x1) / (1 + Math.sqrt((y1 - y3)/(y2 - y3)) )
			// a = (y1 - y3) / (x1 - b)^
			// c = y3
			// x3 = b
			eqObj.pa = pa;
			eqObj.pb = pb;
			eqObj.pc = pc;
			
			if ( Math.abs(pa.x - pb.x) <= 2 ) {
				pb.x += 3;
				eqObj.pb.x += 3;
			}
			
			// 方程参数 a b c
			eqObj.b = (pb.x * Math.sqrt((pa.y - pc.y)/(pb.y - pc.y)) + pa.x) / ( 1 + Math.sqrt((pa.y - pc.y)/(pb.y - pc.y)) );
			eqObj.a = (pa.y - pc.y) / (pa.x - eqObj.b) / (pa.x - eqObj.b);
			eqObj.c = pc.y;
			// 计算顶点x坐标
			eqObj.pc.x = eqObj.b;
			
			// x 对应 y 坐标
			eqObj.yCd = function(xCd:Number):Number {
				return eqObj.a * (xCd - eqObj.b)* (xCd - eqObj.b) + eqObj.c;
			}
			
			// 斜率方程推到 ( 导数 )
			// y~ = lim ( a(x + @ - b)^ - a(x - b)^ ) / @ = lim a ( 2x + @ - 2b ) @ / @ = lim a (2x - 2b + @)
			// y~ = 2ax - 2ab
			// 出射角
			eqObj.radian = Math.atan(2 * eqObj.a * pa.x - 2 * eqObj.a * eqObj.b);
			
			// 某一点的角
			eqObj.currentRad = function(xCd:Number):Number {
				return Math.atan(2 * eqObj.a * xCd - 2 * eqObj.a * eqObj.b);
			}
			
			// v = gt;
			// v^ = 2g(pc.y - pa.y);
			// pc.y - pa.y = 1/2 * g * t^;
			// 上升的时间
			eqObj.t1 = Math.sqrt( 2 * (pc.y - pa.y) / -g );
			// 下落的时间
			eqObj.t2 = Math.sqrt( 2 * (pc.y - pb.y) / -g );
			// 总速度
			eqObj.speed = -g * eqObj.t1 / Math.sin(eqObj.radian);
			
			return eqObj;
		}		
		//保留小数位										保留多少位
		public static function getNumByDecimal(num:Number,index:int =0):Number
		{
			var pow:Number = Math.pow(10, index);
			
			var result:Number = Math.round(num * pow) / pow;
			
			return result;
		}
		
		//根据 水平位移 水平速度 和g 计算 初始竖直方向上的速度 以及竖直方向上的位移为负
		public static function countPlumbSpeedBySVG(sx:Number,vx:Number,g:Number):Array
		{
			var t:Number = Math.abs(sx / vx);
			var vy:Number = -g * t / 2
			var sy:Number = - g * t * t / 4;
			return [vy,sy];
		}
		
		//根据 水平位移 水平速度 和数值位移 计算 初始竖直方向上的速度 以及重力加速度
		public static function countPlumbSpeedBySVS(sx:Number,vx:Number,sy:Number):Array
		{
			
			var t:Number = Math.abs(sx / vx);
			var g:Number = Math.abs(sy) * 2 / (t * t);
			return [-g * t / 2,g];
		}
		
		
		//横坐标 纵坐标  旋转角度  true正方向旋转（false反方向旋转）  是数学系里面的坐标旋转
		public static function ratoteFormulation(nx:Number, ny:Number, ang:Number,boo:Boolean = true):Point
		{
			var cos:Number = Math.cos(ang);
			var sin:Number = Math.sin(ang);
			
			var p:Point;
			//正方向旋转
			var newX:Number = cos * nx - sin * ny;
			var newY:Number = cos * ny + sin * nx;
			//反方向旋转
			var backX:Number = cos * nx + sin * ny;
			var backY:Number = cos * ny - sin * nx;
			//
			if (boo) {
				 p = new Point(newX, newY);
			} else {
				 p = new Point(backX, backY);
			}
			
			return p;
		}	
		
		//根据距离计算 时间  计算 速度 角度
		public static function countSpeedByTime(dx:Number,dy:Number,g:Number,time:int):Object
		{
			var obj:Object = { };
			obj.xSpeed = dx / time;
			obj.ySpeed = (dy - 0.5 * g * time * time) / time;
			obj.angle = Math.atan2(obj.ySpeed, obj.xSpeed);
			return obj;
		}
		
		//给定 最大的竖直高度 
		public static function countSpeedByHeight(dx:Number,dy:Number,g:Number):Object
		{
			var obj:Object = { };
			var time:Number= Math.sqrt(-2* dy/g) ;
			
			obj.ySpeed = -g * time;
			obj.xSpeed = dx / (time*2);
			
			obj.time = time;
			obj.angle = Math.atan2(obj.ySpeed, obj.xSpeed);
			return obj;
		}
		
		
		//从最大值最小值里面随机取一个数
		/**
		 * 
		 * @param	min
		 * @param	max
		 * @param	decimal 保留小数位
		 * @return
		 */
		public static function getRadomFromMinMax(start:Number, end:Number, decimal:int = 0 ):Number
		{
			var dis:Number = end - start;
			//随机取x
			var radom:Number = Math.random();
			
			//直线  2点式
			/**
			 *  0  			1
			 * start        end
			 */
			var k:Number = (end - start) / (1 - 0);		//计算斜率
			//直线 点斜式
			//y - y1 = k(x- x1);
			var result:Number = k * (radom - 0) + start;
			return getNumByDecimal(result,decimal)
			
		}
		
		
		//根据起始坐标S 终点坐标E  重力G跳跃高度H 计算  3D速度
		/**
		 * 
		 * @param	s
		 * @param	e
		 * @param	g
		 * @param	h
		 * @return
		 */
		//根据起始坐标S 终点坐标E  重力G跳跃高度H 计算  3D速度
		/**
		 * 
		 * @param	s
		 * @param	e
		 * @param	g
		 * @param	h
		 * @return
		 */
		public static function getSpeedBySEGH(s:Array,e:Array,g:Number,h:Number):Array
		{
			var t:Number;		//运动总时间
			var xSpeed:Number;	//
			var ySpeed:Number;
			var zSpeed:Number;
			
			
			var dx:Number = e[0] - s[0];  //总的x位移
			var dy:Number = e[1] - s[1];//总的y位移
			
			
			if ( -(e[2] - s[2]) > h ) {
				e[2] = s[2] - h;
			}
			var dz:Number = e[2] - s[2];	//z位移
			var halfT:Number;				//运动到最高点的时间 也就是上升时间  上升时间可能和下落时间不相等
			halfT = Math.sqrt(2 * h / g);
			zSpeed = -g * halfT;			//z速度 -等级加速度×时间 因为开始上升过程是 减速过程
			t =halfT +  Math.sqrt((dz + h) * 2 / g) ;	//运动的总时间 等于 上升时间 加上下落时间
			
			xSpeed = dx / t;
			ySpeed = dy / t;
			return [xSpeed, ySpeed, zSpeed];
		}
		 
		//根据起始坐标S 终点坐标E  重力G跳跃高度H 计算  3D速度
		/**
		 * 
		 * @param	s
		 * @param	e
		 * @param	g
		 * @param	h
		 * @return
		 */
		/*public static function getSpeedBySEGS(s:Array,e:Array,g:Number,speed:Number):Array
		{
			var t:Number;		//运动总时间
			var xSpeed:Number;	//
			var ySpeed:Number;
			var zSpeed:Number;
			
			
			var dx:Number = e[0] - s[0];  //总的x位移
			var dy:Number = e[1] - s[1];//总的y位移
			
			var spceTime:Number = Math.sqrt(2 * dy / g);
			if (dy > 0) {
				
			}
			
			
			if ( -(e[2] - s[2]) > h ) {
				e[2] = s[2] - h;
			}
			var dz:Number = e[2] - s[2];	//z位移
			var halfT:Number;				//运动到最高点的时间 也就是上升时间  上升时间可能和下落时间不相等
			halfT = Math.sqrt(2 * h / g);
			zSpeed = -g * halfT;			//z速度 -等级加速度×时间 因为开始上升过程是 减速过程
			t =halfT +  Math.sqrt((dz + h) * 2 / g) ;	//运动的总时间 等于 上升时间 加上下落时间
			
			xSpeed = dx / t;
			ySpeed = dy / t;
			return [xSpeed, ySpeed, zSpeed];
		}*/
		
		
		
		/**
		 * 
		 * @param	base  底数
		 * @param	logarithm 对数
		 * @return
		 */
		public static function log(base:Number,logarithm:Number):Number
		{
			if (base == 1) {
				return 1;
			}
			return Math.log(logarithm) / Math.log(base);
		}
		
		
		//计算一组数的平均值 
		public static function averageByNums(numsArr:Array):Number
		{
			var average:Number =0;
			for (var i:int = 0; i < numsArr.length; i++ ) {
				average += numsArr[i];
			}
			average /= numsArr.length;
			return average;
		}
		
		//计算一组数的方差
		public static function VarianceByNums(numsArr:Array):Number
		{
			//先计算平均值
			var average:Number = averageByNums(numsArr);
			var variance:Number = 0;
			for (var i:int = 0; i < numsArr.length; i++ ) {
				variance += (numsArr[i] - average)*(numsArr[i] - average)
			}
			return variance;
			
		}
		
		//随机获取半径范围内的一个点
		/**
		 * 
		 * @param	r  这里有2层半径 表示的 是  r 到r2半径范围内的点
		 * @param	r2
		 * @return
		 */
		public static function getRadomPointByRadius(r:Number = 200,r2:Number = 0,a:Number =0,a2:Number = Math.PI*2):Point
		{
			var radomR:Number = getRadomFromMinMax(r,r2);
			var ang:Number = getRadomFromMinMax(a, a2, -2);
			var xPos:Number = radomR * Math.cos(ang);
			var ypos:Number = radomR * Math.sin(ang);
			return new Point(xPos, ypos);
		}
		
	}
	
}