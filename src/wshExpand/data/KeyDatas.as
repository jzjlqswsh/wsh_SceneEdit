package wshExpand.data 
{
	
	/**
	 * ...
	 * @author wsh
	 */
	public class KeyDatas 
	{
		
		public function KeyDatas()
		{
			throw new Error("KeyDatas 是一个静态类 无法实例化");
		}
		
		
		
		// ------------------------------------------------------------------------------------------------------------- 
		
		
		
		//（可以动态改变）游戏控制按键
		public static var key_w : Array;
		public static var key_s : Array;
		public static var key_a : Array;
		public static var key_d : Array;
		public static var key_j : Array;
		public static var key_k : Array;
		public static var key_l : Array;
		public static var key_i : Array;
		
		
		// 有几组按键
		public static const KEYGROUP:int = 2;
		// 按键名称组
		private static const _KEYNAMEARR:Array = ["w", "s", "a", "d", "j", "k", "l", "i"];
		
		
		// 默认游戏控制按键
		private static const _DEFAULTKEYW : Array = [ 87, 38  ];
		private static const _DEFAULTKEYS : Array = [ 83, 40  ];
		private static const _DEFAULTKEYA : Array = [ 65, 37  ];
		private static const _DEFAULTKEYD : Array = [ 68, 39  ];
		private static const _DEFAULTKEYJ : Array = [ 74, 97  ];
		private static const _DEFAULTKEYK : Array = [ 75, 98  ];
		private static const _DEFAULTKEYL : Array = [ 76, 99  ];
		private static const _DEFAULTKEYI : Array = [ 73, 101 ];
		
		
		public static const keyToNumsObj:Object = 
		{
			"A": 65, "B": 66, "C": 67, "D": 68, 
			"E": 69, "F": 70, "G": 71, "H": 72,
			"I": 73, "J": 74, "K": 75, "L": 76, 
			"M": 77, "N": 78, "O": 79, "P": 80, 
			"Q": 81, "R": 82, "S": 83, "T": 84, 
			"U": 85, "V": 86, "W": 87, "X": 88, 
			"Y": 89, "Z": 90, "0": 48, "1": 49, 
			"2": 50, "3": 51, "4": 52, "5": 53, 
			"6": 54, "7": 55, "8": 56, "9": 57, 
			
			"a": 65, "b": 66, "c": 67, "d": 68, 
			"e": 69, "f": 70, "g": 71, "h": 72,
			"i": 73, "j": 74, "k": 75, "l": 76, 
			"m": 77, "n": 78, "o": 79, "p": 80, 
			"q": 81, "r": 82, "s": 83, "t": 84, 
			"u": 85, "v": 86, "w": 87, "x": 88, 
			"y": 89, "z": 90,
			
			"s0": 96 , "s1": 97 , "s2": 98 ,
			"s3": 99 , "s4": 100, "s5": 101, 
			"s6": 102, "s7": 103, "s8": 104, 
			"s9": 105, 
			"[": 219,
			"]": 221,	"}":221,
			
			"=" : 187,	"-":189, 
			"*" : 106, "+" : 107, "_"  : 109, "."  : 110, 
			"/" : 111, "F1": 112, "F2" : 113, "F3" : 114, 
			"F4": 115, "F5": 116, "F6" : 117, "F7" : 118, 
			"F8": 119, "F9": 120, "F11": 122, "F12": 123,
			
			"BACKSPACE"  : 8 , "TAB"      : 9 , "ENTER"   : 13 , "SHIFT": 16 ,
			"CONTROL"    : 17, "CAPS LOCK": 20, "ESC"     : 27 , "SPACE": 32 , 
			"PAGE UP"    : 33, "PAGE DOWN": 34, "END"     : 35 , "HOME" : 36 , 
			"←"          : 37, "↑"        : 38, "→"       : 39 , "↓"    : 40 , 
			"INSERT"     : 45, "DELETE"   : 46, "NUM LOCK": 144, "SCRLK": 145, 
			"PAUSE/BREAK": 19 
			
		}
		
		// 菜单码     	Esc / p
		private static const _MENUCODE:Array = [ 27, 80 ];
		// 帮助界面码 	[
		public static const HELPCODE:uint = 219;
		// 音乐暂停码 	]
		public static const MUSICPAUSECODE:uint = 221;
		// 跳关码     	o
		public static const NEXTCODE:uint = 79;
		
		public static var key_uiplayerinfo:int = keyToNumsObj["c"];	
		public static var key_uibag:int = keyToNumsObj["b"];			
		
		public static var key_uiironsmith:int = -97;	
		
		public static var key_uiqianghua:int = keyToNumsObj["t"];
		
		public static var key_uiskill:int = keyToNumsObj["x"]	//	x	技能
		
		public static var key_uiShop:int = keyToNumsObj["v"];	//
		public static var key_uiTask:int = keyToNumsObj["q"];	//任务 q
		
		public static var key_uiBusiness:int = keyToNumsObj["f"];				//道具店1 装备
		public static var key_uiBusiness2:int = keyToNumsObj["g"];				//道具店2  药水
		public static var key_uiBusiness3:int = -90;				//道具店2  药水
		
		public static var key_dailyTask:int = -99;		//日常任务
		
		public static var key_uiMypet:int = -98;	//keyToNumsObj["n"]		//宠物
		
		public static var key_esc:int = 27;			//	esc
		
		public static var key_space:int = 32;		//空格
		
		public static var key_uiZuoqi:int = keyToNumsObj["z"];	//坐骑 z
		
		public static var key_SkillArr:Array = ["U", "I", "O", "L","H"];
		public static var key_pillArr:Array = ["1", "2","3"];
		
		// 键盘按键值对应的名字
		private static const _KEYINFO:Array = [
			["A", 65], ["B", 66], ["C", 67], ["D", 68], 
			["E", 69], ["F", 70], ["G", 71], ["H", 72],
			["I", 73], ["J", 74], ["K", 75], ["L", 76], 
			["M", 77], ["N", 78], ["O", 79], ["P", 80], 
			["Q", 81], ["R", 82], ["S", 83], ["T", 84], 
			["U", 85], ["V", 86], ["W", 87], ["X", 88], 
			["Y", 89], ["Z", 90], ["0", 48], ["1", 49], 
			["2", 50], ["3", 51], ["4", 52], ["5", 53], 
			["6", 54], ["7", 55], ["8", 56], ["9", 57], 
			
			["NUMBER 0", 96 ], ["NUMBER 1", 97 ], ["NUMBER 2", 98 ],
			["NUMBER 3", 99 ], ["NUMBER 4", 100], ["NUMBER 5", 101], 
			["NUMBER 6", 102], ["NUMBER 7", 103], ["NUMBER 8", 104], 
			["NUMBER 9", 105], 
			
			["*" , 106], ["+" , 107], ["-"  , 109], ["."  , 110], 
			["/" , 111], ["F1", 112], ["F2" , 113], ["F3" , 114], 
			["F4", 115], ["F5", 116], ["F6" , 117], ["F7" , 118], 
			["F8", 119], ["F9", 120], ["F11", 122], ["F12", 123],
			
			["BACKSPACE"  , 8 ], ["TAB"      , 9 ], ["ENTER"   , 13 ], ["SHIFT", 16 ],
			["CONTROL"    , 17], ["CAPS LOCK", 20], ["ESC"     , 27 ], ["SPACE", 32 ], 
			["PAGE UP"    , 33], ["PAGE DOWN", 34], ["END"     , 35 ], ["HOME" , 36 ], 
			["←"          , 37], ["↑"        , 38], ["→"       , 39 ], ["↓"    , 40 ], 
			["INSERT"     , 45], ["DELETE"   , 46], ["NUM LOCK", 144], ["SCRLK", 145], 
			["PAUSE/BREAK", 19], 
			
			["; :", 186], ["= +", 187], ["- _", 189], ["/ ?", 191], ["` ~", 192], 
			["[ {", 219], ["\ |", 220], ["] }", 221], ["” ’", 222], [", <", 188], 
			[". >", 190]
		];
		
		// ------------------------------------------------------------------------------------------------------------- 
		
		
		
		
	}
	
}