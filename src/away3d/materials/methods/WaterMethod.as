package away3d.materials.methods
{
	import away3d.arcane;
	import away3d.core.managers.Stage3DProxy;
	import away3d.materials.compilation.ShaderRegisterCache;
	import away3d.materials.compilation.ShaderRegisterElement;
	
	use namespace arcane;
	
	public class WaterMethod extends BasicDiffuseMethod
	{
		/**
		 * 时间增量
		 */
		public var timeAdd:int = 1;
		
		/**
		 * 平率值 
		 */
		public var level:Number = 15;
		/**
		 * 范围值 
		 */
		public var wide:Number = 30;
		/**
		 * 速率 
		 */
		public var speed:Number = 0.015;
		private var time:int = 0;
		public function WaterMethod()
		{
			super();
		}
		
		override public function copyFrom(method : ShadingMethodBase) : void
		{
			var diff : BasicDiffuseMethod = BasicDiffuseMethod(method);
			alphaThreshold = diff.alphaThreshold;
			texture = diff.texture;
			diffuseAlpha = diff.diffuseAlpha;
			diffuseColor = diff.diffuseColor;
		}
		
		/**
		 * @inheritDoc
		 */
		override arcane function getFragmentPostLightingCode(vo : MethodVO, regCache : ShaderRegisterCache, targetReg : ShaderRegisterElement) : String
		{
				
				var code : String = "";
				var albedo : ShaderRegisterElement;
				var cutOffReg : ShaderRegisterElement;
				
				// incorporate input from ambient
				if (vo.numLights > 0) {
					if (_shadowRegister)
						code += applyShadow(vo, regCache);
					albedo = regCache.getFreeFragmentVectorTemp();
					regCache.addFragmentTempUsages(albedo, 1);
				} else {
					albedo = targetReg;
				}
				
				
				if (_useTexture) {
					_diffuseInputRegister = regCache.getFreeTextureReg();
					vo.texturesIndex = _diffuseInputRegister.index;
//					添加扭曲
					var fc:ShaderRegisterElement = regCache.getFreeFragmentConstant();
					vo.fragmentConstantsIndex = fc.index*4;
					
					var ft0:ShaderRegisterElement = regCache.getFreeFragmentVectorTemp();
					regCache.addFragmentTempUsages(ft0, 1);
					var ft1:ShaderRegisterElement = regCache.getFreeFragmentVectorTemp();
					regCache.addFragmentTempUsages(ft1, 1);
					var ft2:ShaderRegisterElement = regCache.getFreeFragmentVectorTemp();
					regCache.addFragmentTempUsages(ft2, 1);
					
					var v0:ShaderRegisterElement = sharedRegisters.uvVarying;
					
					code += "mov "+ft2+","+v0+"\n"+
						"mov "+ft0+","+fc+"\n"+
						
						"div "+ft1+".x,"+ft0+".x,"+ft0+".y\n"+
						"mul "+ft1+".y,"+v0+".x,"+ft0+".z\n"+
						"add "+ft1+".z,"+ft1+".x,"+ft1+".y\n"+
						"cos "+ft1+".w,"+ft1+".z\n"+
						"mul "+ft1+".x,"+ft1+".w,"+ft0+".w\n"+
						"add "+ft2+".x,"+ft2+".x,"+ft1+".x\n"+
						
						"div "+ft1+".x,"+ft0+".x,"+ft0+".y\n"+
						"mul "+ft1+".y,"+v0+".y,"+ft0+".z\n"+
						"add "+ft1+".z,"+ft1+".x,"+ft1+".y\n"+
						"cos "+ft1+".w,"+ft1+".z\n"+
						"mul "+ft1+".x,"+ft1+".w,"+ft0+".w\n"+
						"add "+ft2+".y,"+ft2+".y,"+ft1+".x\n"+
						
						getTex2DSampleCode(vo, targetReg, _diffuseInputRegister, texture,ft2);
//					code += getTex2DSampleCode(vo, albedo, _diffuseInputRegister, _texture);
					if (_alphaThreshold > 0) {
						cutOffReg = regCache.getFreeFragmentConstant();
						vo.fragmentConstantsIndex = cutOffReg.index * 4;
						code += "sub " + albedo + ".w, " + albedo + ".w, " + cutOffReg + ".x\n" +
							"kil " + albedo + ".w\n" +
							"add " + albedo + ".w, " + albedo + ".w, " + cutOffReg + ".x\n";
					}
				}
				else {
					_diffuseInputRegister = regCache.getFreeFragmentConstant();
					vo.fragmentConstantsIndex = _diffuseInputRegister.index * 4;
					code += "mov " + albedo + ", " + _diffuseInputRegister + "\n";
				}
				
				if (vo.numLights == 0)
					return code;
				
				code += "sat " + _totalLightColorReg + ", " + _totalLightColorReg + "\n";
				
				if (useAmbientTexture) {
					code += "mul " + albedo + ".xyz, " + albedo + ", " + _totalLightColorReg + "\n" +
						"mul " + _totalLightColorReg + ".xyz, " + targetReg + ", " + _totalLightColorReg + "\n" +
						"sub " + targetReg + ".xyz, " + targetReg + ", " + _totalLightColorReg + "\n" +
						"add " + targetReg + ".xyz, " + albedo + ", " + targetReg + "\n";
				}
				else {
					code += "add " + targetReg + ".xyz, " + _totalLightColorReg + ", " + targetReg + "\n";
					if (_useTexture) {
						code += "mul " + targetReg + ".xyz, " + albedo + ", " + targetReg + "\n" +
							"mov " + targetReg + ".w, " + albedo + ".w\n";
					}
					else {
						code += "mul " + targetReg + ".xyz, " + _diffuseInputRegister + ", " + targetReg + "\n" +
							"mov " + targetReg + ".w, " + _diffuseInputRegister + ".w\n";
					}
				}
				
				regCache.removeFragmentTempUsage(_totalLightColorReg);
				regCache.removeFragmentTempUsage(albedo);
				
				return code;
		}
		
		/**
		 * @inheritDoc
		 */
		override arcane function activate(vo : MethodVO, stage3DProxy : Stage3DProxy) : void
		{
			if (_useTexture) {
				stage3DProxy._context3D.setTextureAt(vo.texturesIndex, texture.getTextureForStage3D(stage3DProxy));
				if (_alphaThreshold > 0)
					vo.fragmentData[vo.fragmentConstantsIndex] = _alphaThreshold;
				}
//				增加常量
				if(time>level*6)
				{
					time = 0;
				}
				time+=timeAdd;
				vo.fragmentData[vo.fragmentConstantsIndex+0] = time;
				vo.fragmentData[vo.fragmentConstantsIndex+1] = level;
				vo.fragmentData[vo.fragmentConstantsIndex+2] = wide;
				vo.fragmentData[vo.fragmentConstantsIndex+3] = speed;
			}
		}
		
}
