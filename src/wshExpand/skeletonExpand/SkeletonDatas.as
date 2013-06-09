package wshExpand.skeletonExpand 
{
	import away3d.animators.data.JointPose;
	import away3d.animators.data.Skeleton;
	import away3d.animators.data.SkeletonJoint;
	import away3d.animators.data.SkeletonPose;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.core.math.Quaternion;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	/**
	 * ...骨骼动画 数据初始化 存储
	 * @author wangshuaihua
	 */
	public class SkeletonDatas 
	{
		
		public function SkeletonDatas() 
		{
			
		}
		
		private static var skeletonDataDic:Dictionary = new Dictionary();
		
		public static function initSkeletonAnimator( animator:SkeletonAnimator ):void
		{
			var tempSkeleton:Skeleton = animator.skeleton;
			var tempActiveNode:SkeletonClipNode;
			var animationSet:SkeletonAnimationSet = animator.animationSet as SkeletonAnimationSet;
			var sourcePose : Vector.<JointPose>;
			var sourceMatrices:Vector.<Number>;
			
			var _skeletonPosObj:Object = new Object();
			var _globalMatricesObj:Object = new Object();
			
			if (skeletonDataDic[animator]) {
				_skeletonPosObj = skeletonDataDic[animator][0];
				_globalMatricesObj = skeletonDataDic[animator][1];
			}
			
			var actionName:String;
			
			for (var j:int = 0; j < animationSet.animations.length; j++ ) {
				tempActiveNode = animationSet.animations[j] as SkeletonClipNode;
				actionName = tempActiveNode.name;
				if (!_skeletonPosObj[actionName]) {
					_skeletonPosObj[actionName] = [];
					_globalMatricesObj[actionName] = [];
				}else {
					continue;
				}
				for (var i:int = 0; i <= tempActiveNode.lastFrame; i++  ) {
					sourcePose = initLocalToGlobalPose(tempActiveNode.frames[i], tempSkeleton);
					sourceMatrices = initGlobalMatrices(sourcePose, tempSkeleton);
					_skeletonPosObj[actionName][i] = deepCloneJointPose(sourcePose);
					_globalMatricesObj[actionName][i] = deepCloneGlobalMatrices(sourceMatrices);
				}
			}
			skeletonDataDic[animator] = [_skeletonPosObj, _globalMatricesObj];
			animator.setSkeleTonData([_skeletonPosObj, _globalMatricesObj]);
		}
		
		
		
		//====拿数据
		public static function getSkeletonData(animator:SkeletonAnimator):Array
		{
			return skeletonDataDic[animator];
		}
		
		//====删除数据
		public static function deleteSkeletonData(animator:SkeletonAnimator):void
		{
			delete skeletonDataDic[animator];
			skeletonDataDic[animator] = null;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private static function deepCloneGlobalMatrices(cunPos:Vector.<Number>):Vector.<Number>
		{
			return cunPos;
			var endPos:Vector.<Number> = new Vector.<Number>();
			for (var i:int = 0; i < cunPos.length; i++ ) {
				endPos[i] = cunPos[i];
			}
			return endPos;
		}
		
		private static function deepCloneJointPose(cunPos:Vector.<JointPose>):Vector.<JointPose>
		{
			return cunPos;
			var endPos:Vector.<JointPose> = new Vector.<JointPose>();
			var endJointPose:JointPose;
			for (var i:int = 0; i < cunPos.length; i++ ) {
				endJointPose = new JointPose();
				endJointPose.copyFrom(cunPos[i]);
				endPos[i] = endJointPose;
			}
			return endPos;
		}
		
		
		private static function initLocalToGlobalPose(sourcePose : SkeletonPose, skeleton : Skeleton) : Vector.<JointPose>
		{
			var globalPoses : Vector.<JointPose> = new Vector.<JointPose>;
			var globalJointPose : JointPose;
			var joints : Vector.<SkeletonJoint> = skeleton.joints;
			var len : uint = sourcePose.numJointPoses;
			var jointPoses : Vector.<JointPose> = sourcePose.jointPoses;
			var parentIndex : int;
			var joint : SkeletonJoint;
			var parentPose : JointPose;
			var pose : JointPose;
			var or : Quaternion;
			var tr : Vector3D;
			var t : Vector3D;
			var q : Quaternion;
			
			var x1 : Number, y1 : Number, z1 : Number, w1 : Number;
			var x2 : Number, y2 : Number, z2 : Number, w2 : Number;
			var x3 : Number, y3 : Number, z3 : Number;
			
			// :s
			if (globalPoses.length != len) globalPoses.length = len;
			
			for (var i : uint = 0; i < len; ++i) {
				globalJointPose = globalPoses[i] ||= new JointPose();
				joint = joints[i];
				parentIndex = joint.parentIndex;
				pose = jointPoses[i];
				
				q = globalJointPose.orientation;
				t = globalJointPose.translation;
				
				if (parentIndex < 0) {
					tr = pose.translation;
					or = pose.orientation;
					q.x = or.x;
					q.y = or.y;
					q.z = or.z;
					q.w = or.w;
					t.x = tr.x;
					t.y = tr.y;
					t.z = tr.z;
				}
				else {
					// append parent pose
					parentPose = globalPoses[parentIndex];
					
					// rotate point
					or = parentPose.orientation;
					tr = pose.translation;
					x2 = or.x;
					y2 = or.y;
					z2 = or.z;
					w2 = or.w;
					x3 = tr.x;
					y3 = tr.y;
					z3 = tr.z;
					
					w1 = -x2 * x3 - y2 * y3 - z2 * z3;
					x1 = w2 * x3 + y2 * z3 - z2 * y3;
					y1 = w2 * y3 - x2 * z3 + z2 * x3;
					z1 = w2 * z3 + x2 * y3 - y2 * x3;
					
					// append parent translation
					tr = parentPose.translation;
					t.x = -w1 * x2 + x1 * w2 - y1 * z2 + z1 * y2 + tr.x;
					t.y = -w1 * y2 + x1 * z2 + y1 * w2 - z1 * x2 + tr.y;
					t.z = -w1 * z2 - x1 * y2 + y1 * x2 + z1 * w2 + tr.z;
					
					// append parent orientation
					x1 = or.x;
					y1 = or.y;
					z1 = or.z;
					w1 = or.w;
					or = pose.orientation;
					x2 = or.x;
					y2 = or.y;
					z2 = or.z;
					w2 = or.w;
					
					q.w = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2;
					q.x = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2;
					q.y = w1 * y2 - x1 * z2 + y1 * w2 + z1 * x2;
					q.z = w1 * z2 + x1 * y2 - y1 * x2 + z1 * w2;
				}
			}
			return globalPoses;
		}
		private static function initGlobalMatrices(sourcePose : Vector.<JointPose>, skeleton : Skeleton) : Vector.<Number>
		{
			// convert pose to matrix
			
			var tempGlobalMatrices:Vector.<Number> = new Vector.<Number>;
			
		    var mtxOffset : uint;
			var globalPoses : Vector.<JointPose> = sourcePose;
			var raw : Vector.<Number>;
			var ox : Number, oy : Number, oz : Number, ow : Number;
			var xy2 : Number, xz2 : Number, xw2 : Number;
			var yz2 : Number, yw2 : Number, zw2 : Number;
			var n11 : Number, n12 : Number, n13 : Number;
			var n21 : Number, n22 : Number, n23 : Number;
			var n31 : Number, n32 : Number, n33 : Number;
			var m11 : Number, m12 : Number, m13 : Number, m14 : Number;
			var m21 : Number, m22 : Number, m23 : Number, m24 : Number;
			var m31 : Number, m32 : Number, m33 : Number, m34 : Number;
			var joints : Vector.<SkeletonJoint> = skeleton.joints;
			var pose : JointPose;
			var quat : Quaternion;
			var vec : Vector3D;
			var t : Number;

			for (var i : uint = 0; i < skeleton.numJoints; ++i) {
				pose = globalPoses[i];
				quat = pose.orientation;
				vec = pose.translation;
				ox = quat.x;	oy = quat.y;	oz = quat.z;	ow = quat.w;

				xy2 = (t = 2.0*ox) * oy;
				xz2 = t * oz;
				xw2 = t * ow;
				yz2 = (t = 2.0 * oy) * oz;
				yw2 = t * ow;
				zw2 = 2.0 * oz * ow;

				yz2 = 2.0 * oy * oz;
				yw2 = 2.0 * oy * ow;
				zw2 = 2.0 * oz * ow;
				ox *= ox;
				oy *= oy;
				oz *= oz;
				ow *= ow;

				n11 = (t = ox - oy) - oz + ow;
				n12 = xy2 - zw2;
				n13 = xz2 + yw2;
				n21 = xy2 + zw2;
				n22 = -t - oz + ow;
				n23 = yz2 - xw2;
				n31 = xz2 - yw2;
				n32 = yz2 + xw2;
				n33 = -ox - oy + oz + ow;
				
				// prepend inverse bind pose
				raw = joints[i].inverseBindPose;
				m11 = raw[0];	m12 = raw[4];	m13 = raw[8];	m14 = raw[12];
				m21 = raw[1];	m22 = raw[5];   m23 = raw[9];	m24 = raw[13];
				m31 = raw[2];   m32 = raw[6];   m33 = raw[10];  m34 = raw[14];
				tempGlobalMatrices[uint(mtxOffset)] = n11 * m11 + n12 * m21 + n13 * m31;
				tempGlobalMatrices[uint(mtxOffset+1)] = n11 * m12 + n12 * m22 + n13 * m32;
				tempGlobalMatrices[uint(mtxOffset+2)] = n11 * m13 + n12 * m23 + n13 * m33;
				tempGlobalMatrices[uint(mtxOffset+3)] = n11 * m14 + n12 * m24 + n13 * m34 + vec.x;
				tempGlobalMatrices[uint(mtxOffset+4)] = n21 * m11 + n22 * m21 + n23 * m31;
				tempGlobalMatrices[uint(mtxOffset+5)] = n21 * m12 + n22 * m22 + n23 * m32;
				tempGlobalMatrices[uint(mtxOffset+6)] = n21 * m13 + n22 * m23 + n23 * m33;
				tempGlobalMatrices[uint(mtxOffset+7)] = n21 * m14 + n22 * m24 + n23 * m34 + vec.y;
				tempGlobalMatrices[uint(mtxOffset+8)] = n31 * m11 + n32 * m21 + n33 * m31;
				tempGlobalMatrices[uint(mtxOffset+9)] = n31 * m12 + n32 * m22 + n33 * m32;
				tempGlobalMatrices[uint(mtxOffset+10)] = n31 * m13 + n32 * m23 + n33 * m33;
				tempGlobalMatrices[uint(mtxOffset+11)] = n31 * m14 + n32 * m24 + n33 * m34 + vec.z;

				mtxOffset = uint(mtxOffset + 12);
			}
			return tempGlobalMatrices;
		}
		
		
		
		
	}

}