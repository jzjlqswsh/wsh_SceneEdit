package wshExpand.data 
{
	import wshExpand.utils.Functions;
	
	/**
	 * ...
	 * @author star   关于攻击数据
	 */
	public class AttackDatas 
	{
		
		public function AttackDatas() 
		{
			throw new Error("AttackDatas 是一个静态类 无法实例化");
		}
		
		
		
		//==========================================================================================
		//								攻击信息
		//==========================================================================================
		
		// -------------------------------------------------- 挨打多少次后被击飞
	
		// -------------------------------------------------- 人物
		
		// 配音用
		// 武器声音类型    					 （  气，　液体，拳，脚，身体，金属利器，金属钝器, 木质，石头， 软质（棉布草） ）
		// 武器攻击声音类型					 （  打,  刺， 挥  ）
		// 声音序号							 随即播放什么声音
		// 被打击的人则需要临时判断 受打击声音类型 ( 肉，金属，木质，石头，地形，软质（棉布草），液体 )
		
		// 类型
		// 厚度
		// 挨打动作
		// 伤害
		// 硬值
		// x速度
		// z速度
		// 特效
		// 闪光
		// 震屏
		// 空中撞人
		// 特殊伤害
		//特殊效果  0 没有  1霸体 2无硬直 3吸附效果
		
		private static var _player_1:Object =  {
			attack: {	
					攻击延迟: 10,			//多少帧后出伤害
					伤害:1,	
					硬值:3,
					x速度:2,
					倒地值:0,
					声音:"s_attack_1", 
					挨打动作:"aida",	
					挨打特效:"e_Hit_sharp_1",
					攻击特效:"e_Hit_sharp_1",	
					攻击距离:1,
					攻击类型:1
					//特殊伤害:[Abstract_eachOther.special_frost, 0, 1 , 0]
				}	
		};
		
		private static var _monster_1:Object =  {
			attack: {	
					攻击延迟: 10,			//多少帧后出伤害
					伤害:1,	
					硬值:3,
					x速度:2,
					倒地值:0,
					声音:"s_attack_1", 
					挨打动作:"aida",	
					挨打特效:"e_Hit_sharp_1",
					攻击特效:"e_Hit_sharp_1",	
					攻击距离:1,
					攻击类型:1
					//特殊伤害:[Abstract_eachOther.special_frost, 0, 1 , 0]
				}	
		};
		
		private static var _meizi:Object =  {
			attack: {	
					攻击延迟: 10,			//多少帧后出伤害
					伤害:1,	
					硬值:3,
					x速度:2,
					倒地值:0,
					声音:"s_attack_1", 
					挨打动作:"aida",	
					挨打特效:"e_Hit_sharp_1",
					攻击特效:"e_Hit_sharp_1",	
					攻击距离:1,
					攻击类型:1
					//特殊伤害:[Abstract_eachOther.special_frost, 0, 1 , 0]
				}	
		};
		
		
		
		// -------------------------------------------------- 子弹
		/*private static var _bullet:Object = {
			b_e4_1     :	{	伤害:1,声音:"s_attack_1", 				厚度:60,   	挨打动作:MyFrameLabels.aidaweidao,	硬值:4,    	x速度:2,	z速度:0,	特效:"e_Hit_sharp_1"	,	攻击距离:[-40,40,-30,30,80]							},
			b_e5_1     :	{	伤害:1,	声音:"s_attack_1", 				厚度:100,   挨打动作:MyFrameLabels.aidaweidao,	硬值:4,    	x速度:2,	z速度:0,	特效:"e_Hit_sharp_1"			,	特殊伤害:[Abstract_eachOther.special_fire,2,10 * DebugDatas.FRAMERATE,3] 		,	攻击距离:[-60,60,-30,30,80]							},
			b_e5_2     :	{	伤害:1,	声音:"s_attack_1", 				厚度:60,   	挨打动作:MyFrameLabels.aidaweidao,	硬值:4,    	x速度:2,	z速度:0,	特效:"e_Hit_sharp_1"		,	方式:"双向",  特殊伤害:[Abstract_eachOther.special_fire,2,10 * DebugDatas.FRAMERATE,3] 							},
			
			b_e11_1    :	{	伤害:1,	声音:"s_attack_1", 				厚度:30,   	挨打动作:MyFrameLabels.aidaweidao,	硬值:4,    	x速度:2,	z速度:0,	特效:"e_Hit_sharp_1"			,	攻击距离:[0,40,-30,30,80]		 				},
			
			b_e13_1     :	{	伤害:1,	声音:"s_attack_1", 				厚度:40,   	挨打动作:MyFrameLabels.aidaweidao,	硬值:4,    	x速度:2,	z速度:0,	特效:"e_Hit_sharp_1"		,	攻击距离:[0,80,-30,30,80]								},
			b_e13_2     :	{	伤害:1,	声音:"s_attack_1", 				厚度:40,   	挨打动作:MyFrameLabels.aidaweidao,	硬值:4,    	x速度:2,	z速度:0,	特效:"e_Hit_sharp_1"		,	攻击距离:[0,80,-30,30,80]							},
			
			b_e20_1    :	{	伤害:1,	声音:"s_attack_1", 				厚度:30,   	挨打动作:MyFrameLabels.aidaweidao,	硬值:4,    	x速度:2,	z速度:0,	特效:"e_Hit_sharp_1"			,	攻击距离:[-40,40,-30,30,80]		 				},
			b_e20_2    :	{	伤害:1,	声音:"s_attack_1", 				厚度:30,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:6,	z速度: - (Math.sqrt( 2 * 150 * Property.DEFAULTGRAVITY ) ),	特效:"e_Hit_sharp_1"			,	攻击距离:[-60,60,-40,40,80]	 				},
			
			b_e22_1    :	{	伤害:1,	声音:"s_attack_1", 				厚度:30,   	挨打动作:MyFrameLabels.aidaweidao,	硬值:4,    	x速度:2,	z速度: 0,	特效:"e_Hit_sharp_1"			,	攻击距离:[-40,40,-30,30,80]		 				},
			b_e22_2    :	{	伤害:1,	声音:"s_attack_1", 				厚度:90,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:2,	z速度:- (Math.sqrt( 2 * 150 * Property.DEFAULTGRAVITY ) ),	特效:"e_Hit_sharp_1"			,	攻击距离:[-60,60,-90,90,80]	 				},
			
			
			b_e24_1    :	{	伤害:1,	声音:"s_attack_1", 				厚度:30,   	挨打动作:MyFrameLabels.aidaweidao,	硬值:4,    	x速度:2,	z速度:0,	特效:"e_Hit_sharp_1"			,	攻击距离:[-40,40,-30,30,80]			 				},
			b_e24_2    :	{	伤害:1,	声音:"s_attack_1", 				厚度:40,   	挨打动作:MyFrameLabels.aidaweidao,	硬值:4,    	x速度:2,	z速度:0,	特效:"e_Hit_sharp_1"			,	特殊伤害:[Abstract_eachOther.special_fire,2,10 * DebugDatas.FRAMERATE,3] 		,	攻击距离:[-40,40,-30,30,80]				},
			
			//章鱼触须
			b_b2_2     :	{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:8,	z速度:0,	方式:"双向",  	特效:"e_Hit_sharp_1"	,特殊伤害:[Abstract_eachOther.special_poisonous,3,10 ,3,"e_fire"]		,	攻击距离:[-20,65,-60,60]						},
			
			//花妖地刺
			b_b3_2     :	{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:0,x运动:"静止",	z速度:0,	方式:"双向",  	特效:"e_Hit_sharp_1"			,	攻击距离:[-30,30,-60,0]						},
			//花妖炸弹
			b_b3_1     :	{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:8,	z速度:0,	方式:"双向",  	特效:"e_Hit_sharp_1"			,	攻击距离:[-20,65,-60,60]						},
			//人马战士标
			b_b4_1     :	{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:8,	z速度:0,	方式:"定向",  	特效:"e_Hit_sharp_1"			,	攻击距离:[-20,65,-60,60]						},
			//熊音波
			b_b5_1     :	{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:8,	z速度:0,	方式:"定向",  	特效:"e_Hit_sharp_1"			,	攻击距离:[-20,145,-200,200]						},
			//宠物子弹 种子
			b_pet_1_1     :	{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:0,x运动:"静止",	z速度:0,	方式:"定向",  	特效:"e_pet_1_1"			,	攻击距离:[-5,5,-5,5]						},
			b_pet_1_2     :	{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:0,	z速度:0,	方式:"定向",  	特效:"e_Hit_sharp_1"			,	攻击距离:[-10,30,-50,5]						},
			b_pet_1_3     :	{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:0,	z速度:- (Math.sqrt( 2 * 50 * Property.DEFAULTGRAVITY ) ),	方式:"定向",  	特效:"e_Hit_sharp_1"			,	攻击距离:[-10,30,-50,5]						},
			//宠物子弹 美人鱼
			//水箭
			b_pet_2_1     :	{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:0,x运动:"静止",	z速度:0,	方式:"定向",  	特效:"e_pet_1_1"			,	攻击距离:[-5,5,-5,5]						},
			b_pet_2_2     :	{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:0,x运动:"静止",	z速度:0,	方式:"定向",  	特效:"e_pet_2_2"			,	攻击距离:[-5,5,-5,5]						},
			b_pet_2_3     :	{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:0,x运动:"静止",	z速度:0,	方式:"定向",  	特效:"e_pet_2_3"			,	攻击距离:[-5,5,-5,5]						},
			//火宠
			b_pet_3_1     :	{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:0,x运动:"静止",	z速度:0,	方式:"定向",  	特效:"e_pet_3_1"			,	攻击距离:[-5,5,-5,5]						},
			b_pet_3_2     :	{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:0,x运动:"静止",	z速度:0,	方式:"定向",  	特效:"e_pet_3_2"			,	攻击距离:[-5,5,-5,5]						},
			b_pet_3_3     :	{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:0,x运动:"静止",	z速度:0,	方式:"双向",  	特效:"e_pet_3_2"			,	攻击距离:[-5,5,-5,5]						},
			
			
			
			b_k_1     :		{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:0,    	x速度:0,	z速度:0,	方式:"双向",  	特效:"e_Hit_sharp_1"			,	攻击距离:[-20,20,-80,20,200]						},
			
			b_k_2     :		{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:10,	z运动:"高度", z高度:30, z速度:- (Math.sqrt( 2 * 50 * Property.DEFAULTGRAVITY ) ),	方式:"定向",  	特效:"e_Hit_sharp_1"			,	攻击距离:[-60,60,-100,20,200]						},
			b_k_3     :		{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    	x速度:0,	z速度: 0,	方式:"定向",  	特效:"e_Hit_sharp_1"			,	攻击距离:[-60,60,-120,120,200]						},
			b_k_4     :		{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,     x运动:"静止",	x速度:0,	z运动:"高度", z高度:50, z速度:- (Math.sqrt( 2 * 100 * Property.DEFAULTGRAVITY ) ),	方式:"双向",  	特效:"e_Hit_sharp_1"			,	攻击距离:[-100,100,-300,20,200]						},
			b_k_5     :		{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:10,    x速度:1,	z速度:0,	方式:"定向",  	特效:"e_Hit_sharp_1"			,	攻击距离:[-60,60,-40,40,200]						},
			b_k_6     :		{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:40,   倒地值:100, 	x速度:1,	z速度:- (Math.sqrt( 2 * 150 * Property.DEFAULTGRAVITY ) ),	方式:"定向",  	特效:"e_Hit_sharp_1"			,	攻击距离:[-60,60,-40,40,200]						},
			b_k_7     :		{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:4,    倒地值:20, 	x速度:3,	z速度:0,	方式:"定向",  	特效:"e_Hit_sharp_1"			,	攻击距离:[-60,60,-20,20,200]						},
			b_k_8     :		{	伤害:1,	声音:"s_attack_1", 				厚度:80,   	挨打动作:MyFrameLabels.aidadaodi,	硬值:10,    倒地值:20, 	x速度:3,   晕眩值:100,	z速度:0,	方式:"定向",  	特效:"e_Hit_sharp_1"			,	攻击距离:[-60,60,-60,60,200]						},
			
			
			bullet_2    :	{	伤害:1,	武器声音类型:"金属利器", 	武器攻击声音类型:"刺",		类型:"手里剑",	厚度:30,   	挨打动作:"上段挨打",	硬值:4,    	x速度:2,	z速度:0,	特效:"Hit_obtuse_2"				 				}
			
		}*/
		
		//==========================================================================================
		//								外部访问
		//==========================================================================================
		//==检测是否存在某数据
		public static function checkData(theName:String, key:String = "" ) :Boolean
		{
			if ( AttackDatas["_" + theName] == undefined ) {
				throw new Error( "AttackDatas类里面没有找到你要的属性   " + theName );
			} else if ( key && AttackDatas["_" + theName][key] == undefined ) {
				return false;
			}
			return true;
		}
		
		
		public static function copyDatas( theName:String, key:String = "" ):* 
		{
			if ( AttackDatas["_" + theName] == undefined ) {
				throw new Error( "AttackDatas类里面没有找到你要的属性   " + theName );
			} else if ( key && AttackDatas["_" + theName][key] == undefined ) {
				throw new Error( "AttackDatas类的属性" + theName + " 里面没有找到你要的属性 " + key );
			}
			//判断是返回整个数据还是单个攻击数据
			if (!key) {
				return Functions.deepClone( AttackDatas["_" + theName] );
			} 
			return Functions.deepClone( AttackDatas["_" + theName][key] );
		}
		
		
		
		public static function escapeDatas():void
		{
			
		}
		
		
		
	}
	
}