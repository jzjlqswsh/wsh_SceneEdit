package wshExpand.effect 
{
	import away3d.animators.data.ParticleProperties;
	import away3d.animators.data.ParticlePropertiesMode;
	import away3d.animators.nodes.ParticleBillboardNode;
	import away3d.animators.nodes.ParticleColorNode;
	import away3d.animators.nodes.ParticleScaleNode;
	import away3d.animators.nodes.ParticleTimeNode;
	import away3d.animators.nodes.ParticleVelocityNode;
	import away3d.animators.ParticleAnimationSet;
	import away3d.animators.ParticleAnimator;
	import away3d.core.base.Geometry;
	import away3d.core.base.ParticleGeometry;
	import away3d.entities.Mesh;
	import away3d.events.AnimatorEvent;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.helpers.ParticleGeometryHelper;
	import away3d.utils.Cast;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author wangshuaihua
	 */
	public class Effect_bone 
	{
		
		private var _mesh:Mesh;
		
		public function Effect_bone() 
		{
			
		}
		
		public static function addBoneEff(ctn:*,time:Number, posx:Number = 0,posy:Number = 0,posz:Number = 0):void
		{
			var mesh:Mesh = initParticles(time);
			(mesh.animator as ParticleAnimator).start();
			ctn.addChild(mesh);
			mesh.x = posx;
			mesh.y = posy;
			mesh.z = posz;
			
		}
		
		private static function initParticles(time:Number):Mesh
		{
			//create the particle animation set
			
			var _mesh:Mesh;
			
			var fireAnimationSet:ParticleAnimationSet = new ParticleAnimationSet(true, false);
			
			//add some animations which can control the particles:
			//the global animations can be set directly, because they influence all the particles with the same factor
			fireAnimationSet.addAnimation(new ParticleBillboardNode());
			fireAnimationSet.addAnimation(new ParticleScaleNode(ParticlePropertiesMode.GLOBAL, false, false, 2.5, 0.5));
			//fireAnimationSet.addAnimation(new ParticleVelocityNode(ParticlePropertiesMode.GLOBAL, new Vector3D(0, 80, 0)));
			fireAnimationSet.addAnimation(new ParticleColorNode(ParticlePropertiesMode.GLOBAL, true, true, false, false, new ColorTransform(0, 0, 0, 1, 0xFF, 0x33, 0x01), new ColorTransform(0, 0, 0, 1, 0x99)));
			
			//no need to set the local animations here, because they influence all the particle with different factors.
			fireAnimationSet.addAnimation(new ParticleVelocityNode(ParticlePropertiesMode.LOCAL_STATIC));
			
			//set the initParticleFunc. It will be invoked for the local static property initialization of every particle
			fireAnimationSet.initParticleFunc = initParticleFunc;
			
			//create the original particle geometry
			var particle:Geometry = new PlaneGeometry(10, 10, 1, 1, false);
			
			//combine them into a list
			var geometrySet:Vector.<Geometry> = new Vector.<Geometry>;
			for (var i:int = 0; i < 100; i++) {
				geometrySet.push(particle);
			}
			
			var particleGeometry:ParticleGeometry = ParticleGeometryHelper.generateGeometry(geometrySet);
			
			//var particleMaterial:TextureMaterial/* = new TextureMaterial(Cast.bitmapTexture(FireTexture))*/;
			
			var particleMaterial:ColorMaterial = new ColorMaterial(0xff0000);
			particleMaterial.blendMode = BlendMode.ADD;
			_mesh = new Mesh(particleGeometry, particleMaterial);
			var animator:ParticleAnimator = new ParticleAnimator(fireAnimationSet);
			animator.chixuTime = time * 1000;
			_mesh.animator = animator;
			animator.addEventListener(AnimatorEvent.STOP, endEff);
			function endEff(e:AnimatorEvent):void 
			{
				trace("粒子特效删除8888888888888888")
				//animator.animationSet.deactivate
				_mesh.deleteMe();
			}
			return _mesh;
		}
		
		
		private static function initParticleFunc(prop:ParticleProperties):void
		{	
			prop.startTime = Math.random()*0.1;
			prop.duration = 0.5;//Math.random() * 4 + 0.1;
			var degree1:Number = Math.random() * Math.PI * 2;
			var degree2:Number = Math.random() * Math.PI * 2;
			var r:Number = 100*Math.random()+80;
			prop[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(r * Math.sin(degree1) * Math.cos(degree2), r * Math.cos(degree1) * Math.cos(degree2), r * Math.sin(degree2));
		}
		
		
				
				
		
	}

}