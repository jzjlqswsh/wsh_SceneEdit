/*
*
* Copyright (c) 2013 Sunag Entertainment
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of
* this software and associated documentation files (the "Software"), to deal in
* the Software without restriction, including without limitation the rights to
* use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
* the Software, and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
* FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
* IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
*/

package sunag.sea3d
{
	import away3d.animator.IMorphAnimator;
	import away3d.animator.MorphAnimationSet;
	import away3d.animator.MorphAnimator;
	import away3d.animator.MorphGeometry;
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.VertexAnimationSet;
	import away3d.animators.VertexAnimator;
	import away3d.animators.data.JointPose;
	import away3d.animators.data.Skeleton;
	import away3d.animators.data.SkeletonJoint;
	import away3d.animators.data.SkeletonPose;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.animators.nodes.VertexClipNode;
	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.controllers.LookAtController;
	import away3d.core.base.Geometry;
	import away3d.core.base.SkinnedSubGeometry;
	import away3d.core.base.SubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Entity;
	import away3d.entities.JointObject;
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.materials.IColorMaterial;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.ITranslucentMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.BasicDiffuseMethod;
	import away3d.materials.methods.CelDiffuseMethod;
	import away3d.materials.methods.CelSpecularMethod;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.EnvMapMethod;
	import away3d.materials.methods.FresnelEnvMapMethod;
	import away3d.materials.methods.LayeredDiffuseMethod;
	import away3d.materials.methods.LayeredTexture;
	import away3d.materials.methods.OutlineMethod;
	import away3d.materials.methods.PlanarReflectionMethod;
	import away3d.materials.methods.RefractionEnvMapMethod;
	import away3d.materials.methods.RimLightMethod;
	import away3d.materials.methods.ShadowMapMethodBase;
	import away3d.materials.methods.SubsurfaceScatteringDiffuseMethod;
	import away3d.materials.TextureMaterial;
	import away3d.morph.MorphNode;
	import away3d.sea3d.animation.CameraAnimation;
	import away3d.sea3d.animation.DirectionalLightAnimation;
	import away3d.sea3d.animation.MeshAnimation;
	import away3d.sea3d.animation.MorphAnimation;
	import away3d.sea3d.animation.PointLightAnimation;
	import away3d.sea3d.animation.SkeletonAnimation;
	import away3d.sea3d.animation.TextureAnimation;
	import away3d.sea3d.animation.TextureLayeredAnimation;
	import away3d.sea3d.animation.VertexAnimation;
	import away3d.textures.ATFCubeTexture;
	import away3d.textures.ATFTexture;
	import away3d.textures.AsynBitmapCubeTexture;
	import away3d.textures.AsynBitmapTexture;
	import away3d.textures.AsynSingleBitmapCubeTexture;
	import away3d.textures.BitmapCubeTexture;
	import away3d.textures.CubeReflectionTextureTarget;
	import away3d.textures.CubeTextureBase;
	import away3d.textures.PlanarReflectionTextureTarget;
	import away3d.textures.Texture2DBase;
	import away3d.tools.SkeletonTools;
	
	import flash.utils.Dictionary;
	
	import sunag.animation.Animation;
	import sunag.animation.AnimationNode;
	import sunag.animation.AnimationSet;
	import sunag.animation.IAnimationPlayer;
	import sunag.animation.data.AnimationData;
	import sunag.sea3d.config.DefaultConfig;
	import sunag.sea3d.config.IConfig;
	import sunag.sea3d.mesh.MeshData;
	import sunag.sea3d.objects.SEAATF;
	import sunag.sea3d.objects.SEAATFCube;
	import sunag.sea3d.objects.SEAAnimation;
	import sunag.sea3d.objects.SEAAnimationSequence;
	import sunag.sea3d.objects.SEABitmap;
	import sunag.sea3d.objects.SEACamera;
	import sunag.sea3d.objects.SEACube;
	import sunag.sea3d.objects.SEACubeBase;
	import sunag.sea3d.objects.SEADirectionalLight;
	import sunag.sea3d.objects.SEAFileInfo;
	import sunag.sea3d.objects.SEAGIF;
	import sunag.sea3d.objects.SEAGeometry;
	import sunag.sea3d.objects.SEAJPEG;
	import sunag.sea3d.objects.SEAJPEGXR;
	import sunag.sea3d.objects.SEALight;
	import sunag.sea3d.objects.SEAMaterial;
	import sunag.sea3d.objects.SEAMesh;
	import sunag.sea3d.objects.SEAMesh2D;
	import sunag.sea3d.objects.SEAMorph;
	import sunag.sea3d.objects.SEAMorphAnimation;
	import sunag.sea3d.objects.SEAObject3D;
	import sunag.sea3d.objects.SEAPNG;
	import sunag.sea3d.objects.SEAPointLight;
	import sunag.sea3d.objects.SEASingleCube;
	import sunag.sea3d.objects.SEASkeleton;
	import sunag.sea3d.objects.SEASkeletonAnimation;
	import sunag.sea3d.objects.SEATexture;
	import sunag.sea3d.objects.SEAVertexAnimation;
	import sunag.sea3d.textures.Layer;
	import sunag.sea3d.textures.LayerBitmap;
	import sunag.sunag;
	import sunag.utils.DataTable;
	
	use namespace sunag;
	
	public class SEA3D extends SEA
	{					
		protected var _player:IAnimationPlayer;
		
		protected var _container:ObjectContainer3D;							
		protected var _shadow:ShadowMapMethodBase;
										
		protected var _config:IConfig;
				
		protected var _camera:Vector.<Camera3D>;
		protected var _mesh:Vector.<Mesh>;
		protected var _cubemap:Vector.<CubeTextureBase>;
		protected var _material:Vector.<SinglePassMaterialBase>;
		protected var _texture:Vector.<Texture2DBase>;
		protected var _light:Vector.<LightBase>;
		protected var _animation:Vector.<Animation>;
		protected var _animationSet:Vector.<AnimationSet>;
		protected var _composite:Vector.<LayeredDiffuseMethod>;			
		protected var _object3d:Vector.<ObjectContainer3D>;		
		protected var _morphAnimation:Vector.<Mesh>;
		protected var _vertexAnimation:Vector.<Mesh>;
		protected var _skeletonAnimation:Vector.<Mesh>;
		protected var _morphAnimationSet:Vector.<MorphAnimationSet>;
		protected var _skeletonAnimationSet:Vector.<SkeletonAnimationSet>;
		protected var _skeleton:Vector.<away3d.animators.data.Skeleton>;		
		protected var _jointObject:Vector.<JointObject>;
		protected var _planarReflection:Vector.<PlanarReflectionTextureTarget>;
		protected var _cubemapReflection:Vector.<CubeReflectionTextureTarget>;			
		protected var _sprite3D:Vector.<Sprite3D>;
		
		protected var _planarReflectionDict:Dictionary;
		protected var _cubemapReflectionDict:Dictionary;
		
		protected var _matTechRead:Object = 
		[
			applyDefaultTechnique,
			applyDiffuseMapTechnique,
			applySpecularMapTechnique,
			applyReflectionTechnique,
			applyRefractionTechnique,
			applyNormalMapTechnique,
			applyReflectionTechnique, //fresnel
			applyRimTechnique,			
			applyTranslucentTechnique,
			applyCelTechnique
		];
		
		/**
		 * Creates a new SEA3D loader 
		 * @param config Settings of loader
		 * @param player If you have a player all animations will be automatically added to it
		 * @param debug Creates Dummy and Log for the objects of the scene.
		 * 
		 * @see SEA3DManager
		 * @see SEA3DDebug
		 */
		public function SEA3D(config:IConfig=null)
		{
			super(config ||= new DefaultConfig());						
			
			_config = config;						
			
			_container = config.container;
			
			// ADOBE FLASH PLAYER
			_typeRead[SEAATF.TYPE] = readATFTexture; 
			_typeRead[SEAATFCube.TYPE] = readATFCubeTexture;
			
			// UNIVERSAL
			_typeRead[SEAJPEG.TYPE] = readBitmapTexture;
			_typeRead[SEAJPEGXR.TYPE] = readBitmapTexture;
			_typeRead[SEAPNG.TYPE] = readBitmapTexture;
			_typeRead[SEAGIF.TYPE] = readBitmapTexture;						
			_typeRead[SEACube.TYPE] = readCubeTexture;
			_typeRead[SEASingleCube.TYPE] = readSingleCubeTexture;					
			_typeRead[SEATexture.TYPE] = readTexture;
			_typeRead[SEAMaterial.TYPE] = readMaterial;
			_typeRead[SEAAnimation.TYPE] = readAnimation;
			_typeRead[SEAMorph.TYPE] = readMorph;
			_typeRead[SEAMorphAnimation.TYPE] = readMorphAnimation;
			_typeRead[SEASkeleton.TYPE] = readSkeleton;
			_typeRead[SEASkeletonAnimation.TYPE] = readSkeletonAnimation;
			_typeRead[SEAGeometry.TYPE] = readGeometry;			
			_typeRead[SEAMesh.TYPE] = readMesh;						
			_typeRead[SEAMesh2D.TYPE] = readSprite3D;
			_typeRead[SEACamera.TYPE] = readCamera;		
			_typeRead[SEADirectionalLight.TYPE] = readDirectionalLight;
			_typeRead[SEAPointLight.TYPE] = readPointLight;					
			_typeRead[SEAFileInfo.TYPE] = readFileInfo;			
		}
		
		//
		//	Protected
		//
		
		protected function readMaterial(sea:SEAMaterial):void
		{
			var mat:SinglePassMaterialBase;						
					
			if (sea.diffuseMap)			
				mat = _config.creatTextureMaterial();
			else
				mat = _config.creatColorMaterial();
						
			for each(var tech:Object in sea.technique)
				_matTechRead[tech.kind](mat, tech);
								
			mat.mipmap = sea.mipmap;				
			mat.smooth = sea.smooth;			
			mat.bothSides = sea.bothSides;			
														
			if (mat is TextureMaterial)
			{
				(mat as TextureMaterial).alphaPremultiplied = true;
				(mat as TextureMaterial).alphaThreshold = 0.9;
				TextureMaterial(mat).alpha = sea.alpha;
				
				/*if (TextureMaterial(mat).alphaBlending)
					TextureMaterial(mat).alphaThreshold = sea.alphaThreshold;*/
			}
			
			mat.lightPicker = _config.lightPicker;
			
			if (sea.blendMode)
				mat.blendMode = sea.blendMode;
											
			//if (_shadow) mat.shadowMethod = _shadow;
			
			mat.name = sea.name;
						
			_material ||= new Vector.<SinglePassMaterialBase>();
			_material.push(object[sea.filename] = sea.tag = mat);			
		}				
		
		protected function applyDefaultTechnique(mat:SinglePassMaterialBase, tech:Object):void
		{
			mat.ambientColor = tech.ambientColor;
			mat.diffuseMethod.diffuseColor = tech.diffuseColor;
			mat.specularColor = tech.specularColor;
			
			mat.gloss = tech.gloss;
			mat.specular = tech.specular;
			
			if (mat is IColorMaterial)
				IColorMaterial(mat).color = tech.diffuseColor;
		}
		
		protected function applyDiffuseMapTechnique(mat:TextureMaterial, tech:Object):void
		{
			var tex:SEATexture = _objects[tech.texture] as SEATexture;
								
			mat.animateUVs = tex.layer.length == 1 && (tex.firstLayer.containsUV || tex.firstLayer.useAnimation);
									
			if (mat is ITranslucentMaterial)
			{								
				(mat as ITranslucentMaterial).alphaBlending = (_objects[tex.firstLayer.index] as SEABitmap).transparent;
			}
			
			mat.repeat = tex.firstLayer.repeat;
			
			var texture:* = tex.tag;
			
			if (texture is Texture2DBase)
			{
				mat.texture = texture;
			}
			else if (texture is BasicDiffuseMethod)
			{
				mat.diffuseMethod = texture;
			}								
		}
		
		protected function applySpecularMapTechnique(mat:SinglePassMaterialBase, tech:Object):void
		{			
			mat.specularMap = _objects[tech.texture].tag;				
		}
		
		protected function applyRefractionTechnique(mat:SinglePassMaterialBase, tech:Object):void
		{
			// 64 < is reserved command for runtime textures
			if (tech.texture < 64) return; // no contains runtime refraction
			
			var cubemap:CubeTextureBase = _objects[tech.texture-64].tag;
			
			var method:RefractionEnvMapMethod = new RefractionEnvMapMethod(cubemap, tech.ior);
			method.alpha = tech.alpha;
			
			mat.addMethod(method);
		}
		
		protected function applyReflectionTechnique(mat:SinglePassMaterialBase, tech:Object):void
		{			
			var isRuntime:Boolean = false;
			
			// 64 < is reserved command for runtime textures
			if (tech.texture < 64)
			{
				// Mirror
				if (tech.texture == SEAMaterial.R_MIRROR)
				{					
					if (!_planarReflectionDict) 
						_planarReflectionDict = new Dictionary(true);
					
					var planarMethod:PlanarReflectionMethod = new PlanarReflectionMethod(null, tech.alpha);
					
					if (mat.normalMap)
						planarMethod.normalDisplacement = 1;
					
					mat.addMethod(_planarReflectionDict[mat] = planarMethod);
					
					return;
				}
				else isRuntime = true;
			}
			
			var cubemap:CubeTextureBase,
				method:EffectMethodBase;
		
			if (!isRuntime)
				cubemap = _objects[tech.texture-64].tag;			
											
			if (tech.kind == SEAMaterial.FRESNEL_REFLECTION)
			{				
				var fresnelShader:FresnelEnvMapMethod = new FresnelEnvMapMethod(cubemap, tech.alpha);				
				
				fresnelShader.fresnelPower = tech.power;
				fresnelShader.normalReflectance = tech.normal;
				
				method = fresnelShader;					
			}
			else
			{
				method = new EnvMapMethod(cubemap, tech.alpha);					
			}	
											
			if (isRuntime)
			{					
				if (!_cubemapReflectionDict) 
					_cubemapReflectionDict = new Dictionary(true);
				
				_cubemapReflectionDict[mat] = method;
			}
			
			mat.addMethod( method );			
		}
		
		protected function applyRimTechnique(mat:SinglePassMaterialBase, tech:Object):void
		{			
			mat.addMethod(new RimLightMethod(tech.color, tech.strength, tech.power, tech.blendMode));
		}
		
		protected function applyNormalMapTechnique(mat:SinglePassMaterialBase, tech:Object):void
		{						
			mat.normalMap = _objects[tech.texture].tag;
		}
		
		protected function applyTranslucentTechnique(mat:SinglePassMaterialBase, tech:Object):void
		{			
			var trans:SubsurfaceScatteringDiffuseMethod = new SubsurfaceScatteringDiffuseMethod();
			
			trans.scatterColor = tech.color;
			trans.translucency = tech.translucency;			
			trans.scattering = tech.scattering;
			
			mat.diffuseMethod = trans;
		}				
		
		protected function applyCelTechnique(mat:SinglePassMaterialBase, tech:Object):void
		{
			mat.diffuseMethod = new CelDiffuseMethod(tech.levels);
			mat.specularMethod = new CelSpecularMethod(tech.specularCutOff);
			
			CelDiffuseMethod(mat.diffuseMethod).smoothness = tech.smoothness;
			CelSpecularMethod(mat.specularMethod).smoothness = tech.smoothness;						
						
			mat.addMethod(new OutlineMethod(tech.color, tech.size));	
		}
		
		protected function getTextureBlending(sea:SEATexture):LayeredDiffuseMethod
		{
			var diffuse:LayeredDiffuseMethod = new LayeredDiffuseMethod(sea.multiChannel);
			
			for(var i:int=0;i<sea.layer.length;i++)
			{
				var layer:Layer = sea.layer[i];
				
				var diffuseLayer:LayeredTexture = new LayeredTexture(_objects[layer.texture.index].tag);	
				diffuseLayer.textureUVChannel = layer.texture.channel;
				
				if (layer.mask)
				{
					diffuseLayer.maskUVChannel = layer.mask.channel;
					diffuseLayer.mask = _objects[layer.mask.index].tag;
				}
					
				diffuseLayer.alpha = layer.opacity;
				diffuseLayer.blendMode = layer.blendMode;
				diffuseLayer.offsetU = layer.texture.offsetU;
				diffuseLayer.offsetV = layer.texture.offsetV;
				diffuseLayer.scaleU = layer.texture.scaleU;
				diffuseLayer.scaleV = layer.texture.scaleV;
				
				if (layer.texture.animation)
				{
					addAnimation
					(
						new TextureLayeredAnimation(_objects[layer.texture.animation].tag, diffuseLayer),
						sea.name + ":" +  i
					)										
				}
				
				diffuse.addLayer(diffuseLayer);
			}
			
			return diffuse;
		}
					
		protected function readTexture(sea:SEATexture):void
		{
			if (sea.layer.length > 1)
			{		
				_composite ||= new Vector.<LayeredDiffuseMethod>();				
				_composite.push(object[sea.filename] = sea.tag = getTextureBlending(sea));
			}
			else
			{
				object[sea.filename] = sea.tag = _objects[sea.firstLayer.index].tag;
			}
		}
		
		protected function readMorph(sea:SEAMorph):void
		{
			var morphs:Vector.<MorphNode> = new Vector.<MorphNode>(sea.node.length);
			 
			for(var i:int=0;i<morphs.length;i++)
			{
				var md:MeshData = sea.node[i];				 					
				morphs[i] = new MorphNode(md.name, md.vertex, md.normal);
			}
						
			var morph:MorphAnimationSet = new MorphAnimationSet(morphs, _config.forceCPU);
			
			_morphAnimationSet ||= new Vector.<MorphAnimationSet>();
			_morphAnimationSet.push(object[sea.filename] = sea.tag = morph);
		}
				
		protected function readMorphAnimation(sea:SEAMorphAnimation):void
		{
			var anmSet:AnimationSet = new AnimationSet();
						
			var node:AnimationNode, 
				anmData:Object,
				anmList:Array = sea.morph;
			
			var seqList:Array = sea.useSequence ? (_objects[sea.sequence] as SEAAnimationSequence).list : [sea.getRootSequence()];					
				
			for each(var seq:Object in seqList)
			{
				node = new AnimationNode(seq.name, sea.frameRate, seq.count, seq.repeat, seq.intrpl);
				
				for each(anmData in anmList)
				{						
					node.addData( new AnimationData(anmData.kind, DataTable.FLOAT, anmData.data, seq.start) );						
				}
				
				anmSet.addAnimation( node );
			}
							
			_animationSet ||= new Vector.<AnimationSet>();
			_animationSet.push(object["#mph/" + sea.name] = sea.tag = anmSet);
		}
		
		protected function readAnimation(sea:SEAAnimation):void
		{
			var anmSet:AnimationSet = new AnimationSet();
			
			var node:AnimationNode,
				anmData:Object,
				anmList:Array = sea.dataList;
					
			var seqList:Array = sea.useSequence ? (_objects[sea.sequence] as SEAAnimationSequence).list : [sea.getRootSequence()];					
				
			for each(var seq:Object in seqList)
			{
				node = new AnimationNode(seq.name, sea.frameRate, seq.count, seq.repeat, seq.intrpl);
				
				for each(anmData in anmList)
				{						
					node.addData( new AnimationData(anmData.kind, anmData.type, anmData.data, seq.start * anmData.blockSize) );
				}
				
				anmSet.addAnimation( node );
			}
						
			_animationSet ||= new Vector.<AnimationSet>();
			_animationSet.push(object["#anm/" + sea.name] = sea.tag = anmSet);
		}		
		
		protected function readSkeletonAnimation(sea:SEASkeletonAnimation):void
		{
			var data:Vector.<SkeletonClipNode> = new Vector.<SkeletonClipNode>();
						
			var seqList:Array = sea.useSequence ? (_objects[sea.sequence] as SEAAnimationSequence).list : [sea.getRootSequence()];					
			
			for each(var seq:Object in seqList)		
			{
				var clip:SkeletonClipNode = new SkeletonClipNode();
				
				clip.name = seq.name;
				clip.looping = seq.repeat;
				//clip.frameRate = sea.frameRate;
				
				var start:int = seq.start;
				var end:int = start + seq.count;
				
				for (var i:int=start;i<end;i++)
				{
					var pose:Array = sea.pose[i];
					var len:uint = pose.length;
					
					var sklPose:SkeletonPose = new SkeletonPose();			
					sklPose.jointPoses.length = len;
					
					for (var j:int=0;j<len;j++)
					{				
						var jointPose:JointPose = sklPose.jointPoses[j] = new JointPose();
						var jointData:Array = pose[j];
						
						jointPose.translation.x = jointData[0];
						jointPose.translation.y = jointData[1];
						jointPose.translation.z = jointData[2];
						
						jointPose.orientation.x = jointData[3];
						jointPose.orientation.y = jointData[4];
						jointPose.orientation.z = jointData[5];
						jointPose.orientation.w = jointData[6];
					}
					
					clip.addFrame(sklPose,1000/sea.frameRate);				
				}
				
				data[data.length] = clip;
			}
						
			object["skla/" + sea.name] = sea.tag = data;
		}	
		
		protected function readATFCubeTexture(sea:SEAATFCube):void
		{
			var cube:ATFCubeTexture = new ATFCubeTexture(sea.data);			
			cube.name = sea.name;	
			
			_cubemap ||= new Vector.<CubeTextureBase>();
			_cubemap.push(object["cube/" + sea.name] = sea.tag = cube);
		}
		
		protected function readCubeTexture(sea:SEACube):void
		{
			var cube:AsynBitmapCubeTexture = new AsynBitmapCubeTexture
				(
					sea.faces[0], 
					sea.faces[1],	
					sea.faces[2],
					sea.faces[3],
					sea.faces[4],
					sea.faces[5]
				);
			
			cube.name = sea.name;	
			
			_cubemap ||= new Vector.<CubeTextureBase>();
			_cubemap.push(object["cube/" + sea.name] = sea.tag = cube);
		}
		
		protected function readSingleCubeTexture(sea:SEASingleCube):void
		{
			var cube:AsynSingleBitmapCubeTexture = new AsynSingleBitmapCubeTexture((sea as SEASingleCube).face);
			
			cube.name = sea.name;	
			
			_cubemap ||= new Vector.<CubeTextureBase>();
			_cubemap.push(object["cube/" + sea.name] = sea.tag = cube);
		}
		
		protected function readATFTexture(sea:SEAATF):void
		{
			var tex:ATFTexture = new ATFTexture( sea.data );
			tex.name = sea.name;	
			
			_texture ||= new Vector.<Texture2DBase>();
			_texture.push(object["bmp/" + sea.name] = sea.tag = tex);	
		}
		
		protected function readBitmapTexture(sea:SEABitmap):void
		{	
			var tex:AsynBitmapTexture = new AsynBitmapTexture( sea.data );
			tex.name = sea.name;	
			
			_texture ||= new Vector.<Texture2DBase>();
			_texture.push(object["bmp/" + sea.name] = sea.tag = tex);		
		}
		
		protected function readSprite3D(sea:SEAMesh2D):void
		{
			var sprite:Sprite3D = new Sprite3D(sea.useMaterial ? _objects[sea.material].tag : null, sea.width, sea.height);
			
			sprite.position = sea.position;
			
			_sprite3D ||= new Vector.<Sprite3D>();
			_sprite3D.push(object[sea.filename] = sprite);
			
			addSceneObject(sea, sprite);			
		}
				
		protected function readGeometry(sea:SEAGeometry):void
		{
			var	geo:Geometry = new Geometry();
			
			for each(var index:Vector.<uint> in sea.indexes)			
			{
//				var skinSubGeo:SkinnedSubGeometry = new SkinnedSubGeometry(sea.maxJointCount);
//				
//				skinSubGeo.updateIndexData(indexData);					
//				skinSubGeo.fromVectors(verts, uv, norms, tang);										
//				
//				skinSubGeo.arcane::updateJointIndexData(jointIndices);
//				skinSubGeo.arcane::updateJointWeightsData(jointWeights);
//				
//				subGeo = skinSubGeo;
				// Skeleton
				if (sea.jointPerVertex > 0)
				{
					var skinSubGeo:SkinnedSubGeometry = new SkinnedSubGeometry(sea.jointPerVertex);
					
					skinSubGeo.updateIndexData(index);		
					skinSubGeo.fromVectors
						(
							sea.vertex, 
							sea.uv && sea.uv.length > 0 ? sea.uv[0] : null, 
							sea.normal, 
							sea.tangent
							//,sea.uv && sea.uv.length > 1 ? sea.uv[1] : null
						);						
					
					skinSubGeo.arcane::updateJointIndexData(sea.joint);
					skinSubGeo.arcane::updateJointWeightsData(sea.weight);					
					
					geo.addSubGeometry(skinSubGeo);
				}	
				else
				{
					var stdSubGeo:SubGeometry = new SubGeometry();
					
					stdSubGeo.updateIndexData(index);
					
					stdSubGeo.updateVertexData(sea.vertex);
					
					if (sea.uv) 
					{
						stdSubGeo.updateUVData(sea.uv[0]);
						if (sea.uv.length > 1) stdSubGeo.updateSecondaryUVData(sea.uv[1]);
					}
					else stdSubGeo.autoGenerateDummyUVs = true;
					
					if (sea.normal) stdSubGeo.updateVertexNormalData(sea.normal);
					else stdSubGeo.autoDeriveVertexNormals = true;
					
					if (sea.tangent) stdSubGeo.updateVertexTangentData(sea.tangent);
					else stdSubGeo.autoDeriveVertexTangents = true;
					
					geo.addSubGeometry(stdSubGeo);					
				}
			}
			
			sea.tag = geo;
		}
					
		protected function readMesh(sea:SEAMesh):void
		{	
			//
			//	Geometry
			//
			
			var mesh:Mesh = new Mesh
				( 
					_objects[sea.geometry].tag					
				); 
				
			//
			//	Material
			//
						
			var planarReflection:PlanarReflectionTextureTarget,
			cubemapReflection:CubeReflectionTextureTarget;
			
			if (sea.material)
			{				
				var firstMaterial:Boolean = true;
				
				for(var i:int=0;i<sea.material.length;i++)
				{
					var index:uint = sea.material[i];
					
					if (index > 0)
					{
						var seaMat:SEAMaterial = _objects[index-1] as SEAMaterial;
						var mat:SinglePassMaterialBase = seaMat.tag;
						
						if (_cubemapReflectionDict && _cubemapReflectionDict[mat])
						{
							cubemapReflection ||= new CubeReflectionTextureTarget(128, mesh);										
							_cubemapReflectionDict[mat].envMap = cubemapReflection;
							
							_cubemapReflection ||= new Vector.<CubeReflectionTextureTarget>();
							_cubemapReflection.push( cubemapReflection );
						}
						
						if (_planarReflectionDict && _planarReflectionDict[mat])
						{
							planarReflection ||= new PlanarReflectionTextureTarget(mesh);						
							PlanarReflectionMethod( _planarReflectionDict[mat] ).texture = planarReflection;
							
							_planarReflection ||= new Vector.<PlanarReflectionTextureTarget>();
							_planarReflection.push( planarReflection );
						}
						
						if (!sea.receiveShadows) (mat as SinglePassMaterialBase).shadowMethod = null;
						if (!sea.receiveLights) (mat as SinglePassMaterialBase).lightPicker = null;
						
						if (seaMat.diffuseMap)
						{
							var seaTex:SEATexture = _objects[seaMat.diffuseMap.texture] as SEATexture;
							
							if (seaTex.layer.length == 1) 
							{
								var subMesh:SubMesh = mesh.subMeshes[i];								
								var firstLayer:LayerBitmap = seaTex.firstLayer;
								
								if (firstLayer.containsUV)
								{
									subMesh.offsetU = firstLayer.offsetU;
									subMesh.offsetV = firstLayer.offsetV;
									
									subMesh.scaleU = firstLayer.scaleU;
									subMesh.scaleV = firstLayer.scaleV;
									
									subMesh.uvRotation = firstLayer.rotation;
								}
								
								if (firstLayer.animation)
								{				
									addAnimation
									(
										new TextureAnimation(_objects[firstLayer.animation].tag, subMesh),						
										"texa/" + seaTex.name
									);					
								}
							}
						}
						
						if (firstMaterial)
						{
							mesh.material = mat;
							firstMaterial = false;
						}
						else if (mat != mesh.material)
						{
							mesh.subMeshes[i].material = mat;
						}
					}
				}
			}
			
			//
			//	Animation
			//
			
			var skl:Skeleton, sklAnm:SkeletonAnimator;
			
			if (sea.useAnimation) 
			{
				addAnimation(new MeshAnimation(_objects[sea.animation].tag, mesh), sea.name);								
			}
					
			if (sea.meshType == SEAMesh.SKELETON_ANIMATION)
			{
				skl = _objects[sea.skeleton].tag; 
					
				sklAnm = new SkeletonAnimator
				(
					creatSkeletonSet(_objects[sea.skeletonAnimation] as SEASkeletonAnimation, (_objects[sea.geometry] as SEAGeometry).jointPerVertex), 
					skl, 
					_config.forceCPU
				);				
				sklAnm.autoUpdate = _config.autoUpdate;								
				
				if (_config.updateGlobalPose)
					SkeletonTools.poseFromSkeleton(sklAnm.globalPose, skl);
				
				mesh.animator = sklAnm;
				
				_skeletonAnimation ||= new Vector.<Mesh>();
				_skeletonAnimation.push(mesh);	
				
				addAnimation
				(
					new away3d.sea3d.animation.SkeletonAnimation(mesh.animator as SkeletonAnimator), 
					sea.name
				);
			}
			else if (sea.meshType == SEAMesh.VERTEX_ANIMATION)
			{
				mesh.animator = new VertexAnimator(creatVertexAnimationSet(_objects[sea.vertexAnimation] as SEAVertexAnimation, mesh.geometry));
				(mesh.animator as VertexAnimator).autoUpdate = _config.autoUpdate;
				
				_vertexAnimation ||= new Vector.<Mesh>();
				_vertexAnimation.push(mesh);	
				
				addAnimation
				(										
					new VertexAnimation(mesh.animator as VertexAnimator),					
					sea.name
				);
			}		
			
			// Morph GPU
			if (sea.morphType > 0)
			{		
				var morph:IMorphAnimator;
				
				if (mesh.animator)
				{
					// CPU Morph Animation
					morph = new MorphGeometry( _objects[sea.morph].tag, _objects[sea.geometry].tag );
					
					object['mphg/' + sea.name] = morph; 
				}
				else
				{
					// GPU/CPU Morph Animation
					morph = new MorphAnimator( _objects[sea.morph].tag );
					mesh.animator = morph as MorphAnimator;										
				}
				
				_morphAnimation ||= new Vector.<Mesh>();
				_morphAnimation.push(mesh);				
				
				if (sea.morphType == 2)
				{
					addAnimation
					(
						new MorphAnimation
						(
							_objects[sea.morphAnimation].tag,
							morph
						),
						sea.name
					);
				}
			}
									
			mesh.transform = sea.transform;			
			mesh.castsShadows = sea.castShadows;	
			
			mesh.staticNode = sea.isStatic;
			
			_mesh ||= new Vector.<Mesh>();
			_mesh.push(object[sea.filename] = mesh);
			
			addSceneObject(sea, mesh);
		}				
										
		protected function readSkeleton(sea:SEASkeleton):away3d.animators.data.Skeleton
		{
			var skeleton:away3d.animators.data.Skeleton = new away3d.animators.data.Skeleton();			
			var joints:Array = sea.joint;
			
			for(var i:int=0;i<joints.length;i++)
			{
				var jointData:Array = joints[i];	
				
				var sklJoint:SkeletonJoint = skeleton.joints[i] = new SkeletonJoint();
				sklJoint.name = jointData[0];
				sklJoint.parentIndex = jointData[1];
				sklJoint.inverseBindPose = jointData[2];
			}
			
			_skeleton ||= new Vector.<away3d.animators.data.Skeleton>();
			_skeleton.push(object["skl/" + sea.name] = sea.tag = skeleton);			
			
			return skeleton;
		}
			
		protected function readCamera(sea:SEACamera):void
		{
			var lens:PerspectiveLens = new PerspectiveLens(sea.fov);
			
			lens.near = _config.cameraNear;
			lens.far = _config.cameraFar;
			
			var cam:Camera3D = new Camera3D(lens);
			
			cam.transform = sea.transform;						
					
			_camera ||= new Vector.<Camera3D>();
			_camera.push(object[sea.filename] = cam);	
			
			if (sea.useAnimation) 
			{
				addAnimation
				(
					new CameraAnimation(_objects[sea.animation].tag, cam),
					sea.name					
				);
			}
					
			addSceneObject(sea, cam);
		}
		
		protected function readPointLight(sea:SEAPointLight):void
		{
			var light:PointLight = new PointLight();
			
			readLight
			(
				light, 
				sea.name, 
				sea.color, 
				sea.multiplier,
				sea.ambient,
				sea.ambientColor
			);
			
			light.position = sea.position;
			light.radius = sea.attenStart;
			light.fallOff = sea.attenEnd;				
			
			if (sea.useAnimation) 
			{
				addAnimation
				(
					new PointLightAnimation(_objects[sea.animation].tag, light),
					sea.name
				);
			}	
			
			addSceneObject(sea, light);
		}
		
		protected function readDirectionalLight(sea:SEADirectionalLight):void
		{
			var light:DirectionalLight = new DirectionalLight();
			
			readLight
			(
				light, 
				sea.name, 
				sea.color, 
				sea.multiplier, 
				sea.ambient,
				sea.ambientColor
			);
			
			light.transform = sea.transform;				
				
			if (_config.enabledShadow && !_shadow)
			{
				creatShadow(light, sea);
			}
			
			if (sea.useAnimation) 
			{
				addAnimation
				(
					new DirectionalLightAnimation(_objects[sea.animation].tag, light),
					sea.name
				);
			}			
			
			addSceneObject(sea, light);
		}
		
		protected function creatShadow(light:LightBase, sea:SEALight):void
		{
			if (light is DirectionalLight)
			{
				if (sea.shadow && !_shadow)
				{
					light.shadowMapper = _config.getShadowMapper();
					_shadow = _config.getShadowMapMethod(light as DirectionalLight);
				}
			}
			
			for each(var mat:SinglePassMaterialBase in _material)
			{
				mat.shadowMethod = _shadow;
			}
		}
		
		protected function readLight(light:LightBase, name:String, color:int, multiplier:Number, ambient:Number, ambientColor:uint):void
		{
			light.color = color;
			light.diffuse = multiplier;
			light.specular = multiplier;			
			
			light.ambientColor = ambientColor;
			light.ambient = ambient;
			
			// Updatep
			var picker:StaticLightPicker = _config.lightPicker;
			
			picker.lights.push(light)
			picker.lights = picker.lights;			
			
			_light ||=  new Vector.<LightBase>();
			_light.push(object["lht/" + name] = light);
		}
				
		//
		//  Creators
		//
		
		public function creatJointObject(mesh : Mesh, jointIndex : uint = 0):JointObject
		{											
			var joint : JointPose = (mesh.animator as SkeletonAnimator).globalPose.jointPoses[jointIndex];
			
//			if (!joint.extra)
//			{
				var jointObj:JointObject = new JointObject(mesh, jointIndex, _config.autoUpdate);
				
				mesh.addChild(jointObj);
				
				if (_config.updateGlobalPose)
					jointObj.update();
				
				_jointObject ||= new Vector.<JointObject>();
				_jointObject.push(object["jnt/"+mesh.name+"/"+jointObj.jointName] /*= joint.extra*/ = jointObj);	
				return jointObj;
//			}
//			
//			return joint.extra;
		}
		
		public function creatSkeletonSet(sea:SEASkeletonAnimation, jointPerVertex:int=4):SkeletonAnimationSet
		{
			if (sea.tag2)
				return sea.tag2;
			
			var sklClipList:Vector.<SkeletonClipNode> = sea.tag;
			
			var sklAnmSet:SkeletonAnimationSet = new SkeletonAnimationSet(jointPerVertex);
			sklAnmSet.name = sea.name;
			
			for(var i:int=0;i<sklClipList.length;i++)			
				sklAnmSet.addAnimation(sklClipList[i]);	
			
			_skeletonAnimationSet ||= new Vector.<SkeletonAnimationSet>();
			_skeletonAnimationSet.push(object["#skl/" + sea.name] = sea.tag2 = sklAnmSet);
			
			return sklAnmSet;
		}
		
		public function creatVertexAnimationSet(sea:SEAVertexAnimation, ref:Geometry):VertexAnimationSet
		{
			if (sea.tag)
				return sea.tag;
			
			var i:int = 0, 
				frames:Vector.<Geometry> = new Vector.<Geometry>(sea.frame.length),
				anmSet:VertexAnimationSet = new VertexAnimationSet();
			
			while (i < frames.length)
			{
				var frame:MeshData = sea.frame[i];				
				var geo:Geometry = new Geometry();
				
				for each(var refSG:SubGeometry in ref.subGeometries)
				{
					var frameSG:SubGeometry = new SubGeometry();
					
					frameSG.updateIndexData(refSG.indexData);
					
					frameSG.fromVectors
						(
							frame.vertex,
							refSG.UVData,
							frame.normal ? frame.normal : null,
							refSG.vertexTangentData
							//,refSG.secondaryUVData
						);
					
					geo.addSubGeometry(frameSG);
				}	
				
				frames[i++] = geo;
			}
						
			var seqList:Array = sea.useSequence ? (_objects[sea.sequence] as SEAAnimationSequence).list : [sea.getRootSequence()];					
			
			for each(var seq:Object in seqList)		
			{
				var clip:VertexClipNode = new VertexClipNode();
				
				clip.name = seq.name;
				clip.looping = seq.repeat;
				//clip.frameRate = sea.frameRate;
				
				var start:int = seq.start;
				var end:int = seq.start + seq.count;
				
				for (var j:int=start;j<end;j++)			
					clip.addFrame(frames[j],1000/sea.frameRate);
				
				anmSet.addAnimation(clip);				
			}
			
			object["#vtx/" + sea.name] = sea.tag = anmSet;
			
			return anmSet;
		}
		
		//
		//	Utils
		//
						
		sunag function addSceneObject(sea:SEAObject3D, obj3d:ObjectContainer3D):void
		{
			obj3d.name = sea.name;				
			
			if (sea.properties)
			{
				obj3d.extra = _objects[sea.properties].tag;
			}
			
			obj3d.ignoreTransform = sea.isStatic;

			_object3d ||= new Vector.<ObjectContainer3D>();
			_object3d.push(object["o3d/"+sea.name] = sea.tag = obj3d);
										
			if (sea.lookAt && obj3d is Entity)
			{
				setLookAtObject(sea, obj3d as Entity);											
			}
			
			if (sea.parent)
			{
//				if (sea.parent.joint)
//				{
//					creatJointObject(_objects[sea.parent.index].tag, sea.parent.joint).addChild(obj3d);
//				}
//				else
//				{
					_objects[sea.parent.index].tag.addChild(obj3d);
//				}
			}
			else if (_container) _container.addChild(obj3d);							
		}
		
		sunag function addAnimation(anm:Animation, name:String):void
		{			
			anm._name = name;						
			anm.autoUpdate = _config.autoUpdate;
			anm.blendMethod = _config.animationBlendMethod;
			
			if (_player)			
				_player.addAnimation(anm);				
						
			_animation ||= new Vector.<Animation>();
			_animation.push(object["anm/"+name] = anm);
		}			
		
		//
		//	Public Methods ( GET )
		//
		
		/**
		 * List of CubeReflection with the target (Mesh)  
		 */
		public function get cubeReflections():Vector.<CubeReflectionTextureTarget>
		{			
			return _cubemapReflection;
		}
		
		/**
		 * List of PlanarReflection with the target (Mesh)  
		 */
		public function get planarReflections():Vector.<PlanarReflectionTextureTarget>
		{
			return _planarReflection;
		}
				
		/**
		 * Global animation player  
		 */
		public function set player(val:IAnimationPlayer):void
		{
			_player = val;
		}
		
		
		public function get player():IAnimationPlayer
		{
			return _player;
		}
		
		/**
		 * Config object  
		 */
		public function get config():IConfig
		{
			return _config;
		}
		
		/**
		 * JointObject is any object attached to the skeleton of a model. As eyes on the head for example.
		 */
		public function get jointObjects():Vector.<JointObject>
		{
			return _jointObject;
		}				
			
		/**
		 * Multi/Materials textures and advanced techniques of blend.
		 */
		public function get composites():Vector.<LayeredDiffuseMethod>
		{
			return _composite;
		}
		
		/**
		 * List of all animations of the SEA3D
		 */
		public function get animations():Vector.<Animation>
		{
			return _animation;			
		}		
		
		/**
		 * List of all shared animation (AnimationSet)
		 */
		public function get animationsSet():Vector.<AnimationSet>
		{
			return _animationSet;
		}	
		
		/**
		 * List of all skeletons
		 */
		public function get skeleton():Vector.<away3d.animators.data.Skeleton>
		{
			return _skeleton;
		}
		
		/**
		 * List of all shared skeleton animation
		 */
		public function get skeletonAnimationsSet():Vector.<SkeletonAnimationSet>
		{
			return _skeletonAnimationSet;
		}
		
		/**
		 * List of all meshes containing skeleton animator 
		 */
		public function get skeletonAnimations():Vector.<Mesh>
		{
			return _skeletonAnimation;
		}
		
		/**
		 * List of all meshes containing morph animator 
		 */
		public function get morphAnimations():Vector.<Mesh>
		{
			return _morphAnimation;
		}
		
		/**
		 * List of all meshes containing vertex animator 
		 */
		public function get vertexAnimations():Vector.<Mesh>
		{
			return _vertexAnimation;
		}
		
		/**
		 * List of all lights
		 */
		public function get lights():Vector.<LightBase>
		{
			return _light;
		}
		
		/**
		 * List of all textures
		 */
		public function get textures():Vector.<Texture2DBase>
		{
			return _texture;
		}

		/**
		 * List of all materials
		 */
		public function get materials():Vector.<SinglePassMaterialBase>
		{
			return _material;
		}
		
		/**
		 * List of all cubemaps
		 */
		public function get cubemaps():Vector.<CubeTextureBase>
		{
			return _cubemap;
		}
		
		/**
		 * List of all meshes
		 */
		public function get meshes():Vector.<Mesh>
		{
			return _mesh;
		}
		
		/**
		 * List of all sprite3D
		 */
		public function get sprites3D():Vector.<Sprite3D>
		{
			return _sprite3D;
		}
		
		/**
		 * List of all cameras
		 */
		public function get cameras():Vector.<Camera3D>
		{
			return _camera;
		}		
		
		/**
		 * List of all child contained in the SEA file (ObjectContainer3D)
		 * 
		 * @see #getObject3D()
		 */
		public function get objects3d():Vector.<ObjectContainer3D>
		{
			return _object3d;
		}
		
		/**
		 * Returns true if it contains an SEA3D object already loaded
		 * @param ns Namespace of an object. Example: <b>object3d/Light001</b>
		 */
		public function containsObject(ns:String):Boolean
		{
			return object[ns] != null;
		}
		
		/**
		 * Returns one SEA3D object already loaded
		 * @param ns Namespace of an object. Example: <b>object3d/Light001</b>
		 */
		public function getObject(ns:String):*
		{
			return object[ns];
		}
		
		/**
		 * Returns one Camera3D.		 
		 * Use <b>getAnimation</b> to get the camera animator.
		 * 
		* @param name Name of the object. Example:<b>Camera001</b>
		 * 
		 * @see #getAnimation()
		 * @see away3d.sea3d.animation.CameraAnimation
		 */		
		public function getCamera(name:String):Camera3D
		{
			return object["cam/"+name];
		}
					
		/**
		 * Returns one Light.		 
		 * Use <b>getAnimation</b> to get the light animator.
		 * 
		 * @param name Name of the object. Example:<b>Light001</b>
		 * 
		 * @see #getAnimation()
		 * @see away3d.sea3d.animation.LightAnimationBase
		 */
		public function getLight(name:String):LightBase
		{
			return object["lht/"+name];
		}
		
		/**
		 * Returns one CubeTextureBase.
		 * 
		 * @param name CubeMap slot name
		 */
		public function getCubeMap(name:String):CubeTextureBase
		{
			return object["cube/"+name];
		}
			
		/**
		 * Returns one Texture2D.
		 * 
		 * @param name of the texture
		 */
		public function getTextureBase(name:String):Texture2DBase
		{
			return object["bmp/"+name];
		}
		
		/**
		 * Returns one Texture usually Texture2D and LayeredTexture.
		 * This texture may be of any slot, including Diffuse, Normal and Specular.
		 * 
		 * @param name Name of texture.
		 */
		public function getTexture(name:String):*
		{
			return object["tex/"+name];
		}
		
		/**
		 * Get a material based on its name
		 * 
		 * @param name Material name
		 */
		public function getMaterial(name:String):SinglePassMaterialBase
		{
			return object["mat/"+name];
		}
		
		/**
		 * Returns one Mesh.		 
		 * Use <b>getAnimation</b> to get the mesh animator.
		 * 
		 * @param name Name of the object. Example:<b>Box001</b>
		 * 
		 * @see #getAnimation()
		 * @see #morphAnimations
		 * @see #skeletonAnimations
		 * @see #vertexAnimations
		 * @see away3d.sea3d.animation.MeshAnimation
		 */
		public function getMesh(name:String):Mesh
		{
			return object["m3d/"+name];
		}
		
		/**
		 * Returns one Animator.		 
		 * @return Returns a Animator. Base of all animation of the SEA3D.
		 */
		public function getAnimation(name:String):Animation
		{
			return object["anm/"+name];
		}
		
		/**
		 * Returns one Single Layer TextureAnimation.		 
		 * @param textureName Texture name
		 */
		public function getTextureAnimation(textureName:String):TextureAnimation
		{
			return getAnimation(textureName) as TextureAnimation;
		}
		
		/**
		 * Returns one MultiLayer TextureAnimation.		 
		 * @param textureName Texture name		 
		 * @param index Layer of the texture
		 */
		public function getTextureLayeredAnimation(textureName:String, index:int=0):TextureLayeredAnimation
		{
			return getAnimation(textureName + ":" + index) as TextureLayeredAnimation;
		}
		
		/**
		 * Base of all animation objects by exception of dynamic mesh (e.g: SkeletonAnimation, VertexAnimation).	 
		 * @param name Typically the object name, material or texture
		 */
		public function getAnimationSet(name:String):AnimationSet
		{
			return object["#anm/"+name];
		}
		
		/**
		 * Base of all MorphAnimation	 
		 * @param name Typically the object name, material or texture
		 */
		public function getMorphAnimationSet(name:String):MorphAnimationSet
		{
			return object["#mph/"+name];
		}
		
		/**
		 * Base of all CPU MorphAnimation. Typically Skeleton Morph Animation
		 * @param name Typically the object name, material or texture
		 */
		public function getMorphGeometry(name:String):MorphGeometry
		{
			return object["mphg/"+name];
		}
			
		/**
		 * Gets a child contained in the SEA file
		 * @param name Name of a child
		 */
		public function getObject3D(name:String):ObjectContainer3D
		{
			return object["o3d/"+name];
		}
		
		/**
		 * Gets a Sprite3D
		 * @param name Name of a child
		 */
		public function getSprite3D(name:String):Sprite3D
		{
			return object["m2d/"+name];
		}
		
		/**
		 * Base all takes skeleton animations	 
		 * @param name Typically the object Mesh name
		 */
		public function getSkeletonAnimationSet(name:String):SkeletonAnimationSet
		{
			return object["#skl/"+name];
		}
		
		/**
		 * Base all takes vertex animations	 
		 * @param name Typically the object Mesh name
		 */
		public function getVertexAnimationSet(name:String):VertexAnimationSet
		{
			return object["#vtx/"+name];
		}
		
		/**
		 * Skeleton of the Mesh object
		 * @param name Typically the object Mesh name
		 */
		public function getSkeleton(name:String):away3d.animators.data.Skeleton
		{
			return object["skl/"+name];
		}
		
		/**
		 * JointObject is any object attached to the skeleton of a model. As eyes on the head for example.
		 * @param mesh Mesh name
		 * @param joint Joint name (Bone name)
		 */
		public function getJointObject(mesh:String, joint:String):JointObject
		{
			return object["jnt/"+mesh+"/"+joint];
		}
				
		//得到动画数据
		public function getSkeletonNodesObject(name:String):Vector.<SkeletonClipNode>
		{
			return object["skla/"+name];
		}
		
		//得到一套动作
		public function getOneSkeletonNodesObject():Vector.<SkeletonClipNode>
		{
			for (var i:String in object) {
				if (i.indexOf("skla/") != -1) {
					return object[i];
				}
			}
			return null;
		}
		
		
		//
		//	System
		//
		
		override protected function reset():void
		{
			super.reset();
			
			_mesh =			
			_morphAnimation =
			_vertexAnimation =
			_skeletonAnimation = null;
			
			_camera = null;
			_jointObject = null;
			_cubemap = null;
			_material = null;
			_texture = null;
			_skeleton = null;
			_skeletonAnimationSet = null;
			_light = null;
			_composite = null;
			_morphAnimationSet = null;
			_planarReflection = null;
			_planarReflectionDict = null;
			_cubemapReflection = null;
			_cubemapReflectionDict = null;
			
			_shadow = null;
			
			_animationSet = null;
			_animation = null;
			_object3d = null;
		}
		
		public override function dispose():void
		{
			for each(var mesh:Mesh in _mesh) 
				mesh.dispose();
				
			for each(var camera:Camera3D in _camera)
				camera.dispose();
				
			for each(var joint:JointObject in _jointObject)
				joint.dispose();
			
			for each(var cubemap:CubeTextureBase in _cubemap)
				cubemap.dispose();
			
			for each(var material:SinglePassMaterialBase in _material)
				material.dispose();		
			
			for each(var texture:Texture2DBase in _texture)
				texture.dispose();	
			
			for each(var skl:Skeleton in _skeleton)
				skl.dispose();
						
			for each(var sklAnm:SkeletonAnimationSet in _skeletonAnimationSet)
				sklAnm.dispose();	
									
			for each(var light:LightBase in _light)
				light.dispose();
			
			for each(var composite:LayeredDiffuseMethod in _composite)
				composite.dispose();
			
			for each(var morphAnmSet:MorphAnimationSet in _morphAnimationSet)
				morphAnmSet.dispose();
						
			for each(var planar:PlanarReflectionTextureTarget in _planarReflection)
				planar.dispose();
			
			for each(var cubeRef:CubeReflectionTextureTarget in _cubemapReflection)
				cubeRef.dispose();
						
			super.dispose();
		}
						
		//
		//	Protected Utils
		//
			
		protected function setLookAtObject(sea:SEAObject3D, object3d:Entity):void
		{
			object3d["controller"] = new LookAtController(_objects[sea.lookAt.index].tag);						
		}
								
		override protected function readHead():Boolean
		{
			if (super.readHead())
			{				
				var differentVersion:int = version - VERSION;
				
				if (differentVersion < 0)
					trace("Warning: File contains an old version of SEA3D.");
				else if (differentVersion > 0)
					trace("Warning: File was designed for a newer version of SEA3D.");
				
				return true;
			}
			
			return false;
		}		
	}
}