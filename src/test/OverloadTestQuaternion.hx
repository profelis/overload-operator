package test;
import deep.math.QuaternionMath;
import deep.math.Quaternion;
import deep.macro.math.IOverloadOperator;
import haxe.unit.TestCase;

/**
 * ...
 * @author Simon Krajewski
 */

class OverloadTestQuaternion extends TestCase, implements IOverloadOperator<QuaternionMath>
{	
	public function testGetNorm()
	{
		var quat = new Quaternion(5, 3, 1, 1);
		assertEquals(6.0, quat.getNorm());
	}
	
	public function testNormalize()
	{
		var quat = new Quaternion(10, 0, 0, 0);
		var quatNorm = quat.normalize();
		assertEquals(1.0, quatNorm.x);
		assertEquals(0.0, quatNorm.y);
		assertEquals(0.0, quatNorm.z);
		assertEquals(0.0, quatNorm.w);
	}
	
	public function testAdd()
	{
		var quat = new Quaternion(1, 2, 3, 4) + new Quaternion(1, 1, 1, 1);
		assertEquals(2.0, quat.x);
		assertEquals(3.0, quat.y);
		assertEquals(4.0, quat.z);
		assertEquals(5.0, quat.w);
		
		quat += new Quaternion(1, 2, 3, 4);
		assertEquals(3.0, quat.x);
		assertEquals(5.0, quat.y);
		assertEquals(7.0, quat.z);
		assertEquals(9.0, quat.w);		
	}
	
	public function testSubtract()
	{
		var quat = new Quaternion(1, 2, 3, 4) - new Quaternion(1, 1, 1, 1);
		assertEquals(0.0, quat.x);
		assertEquals(1.0, quat.y);
		assertEquals(2.0, quat.z);
		assertEquals(3.0, quat.w);
		
		quat -= new Quaternion(4, 3, 2, 1);
		assertEquals(-4.0, quat.x);
		assertEquals(-2.0, quat.y);
		assertEquals(0.0, quat.z);
		assertEquals(2.0, quat.w);				
	}	
	
	public function testEquals()
	{
		var quat1 = new Quaternion(1, 2, 3, 9);
		var quat2 = new Quaternion(1, 2, 3, 9);
		assertTrue(quat1 == quat2);
		assertTrue(quat1 == quat1);
		assertFalse(quat1 == new Quaternion(1, 2, 3, 8));
	}
	
	public function testNotEquals()
	{
		var quat1 = new Quaternion(1, 2, 3, 9);
		var quat2 = new Quaternion(1, 2, 3, 9);
		assertFalse(quat1 != quat2);
		assertFalse(quat1 != quat1);
		assertTrue(quat1 != new Quaternion(1, 2, 3, 8));
	}	
	
	public function testRotate()
	{
		var point = new Quaternion(0, 1, 0, 0);
		
		var rotate = Quaternion.fromYawPitchRoll(0, 0, Math.PI / 2);
		// 90° roll from (0, 1, 0) to (-1, 0, 0)
		var rotated = point << rotate;
		assertFloatEquals( -1.0, rotated.x);
		assertFloatEquals( 0.0, rotated.y);
		assertFloatEquals( 0.0, rotated.z);
		
		rotate = Quaternion.fromYawPitchRoll(0, 0, Math.PI);
		// 180° roll from (0, 1, 0) to (0, -1, 0)
		var rotated = point << rotate;
		assertFloatEquals( 0.0, rotated.x);
		assertFloatEquals( -1.0, rotated.y);
		assertFloatEquals( 0.0, rotated.z);		
	}
	
	public function testScalar()
	{
		var quat = new Quaternion(1, 2, 3, 4);
		var scaledQuat = quat * 5.0;
		assertEquals(5.0, scaledQuat.x);
		assertEquals(10.0, scaledQuat.y);
		assertEquals(15.0, scaledQuat.z);
		assertEquals(20.0, scaledQuat.w);
		assertTrue(5.0 * quat == scaledQuat);
		
		scaledQuat = quat / 4.0;
		assertEquals(1 / 4, scaledQuat.x);
		assertEquals(2 / 4, scaledQuat.y);
		assertEquals(3/ 4, scaledQuat.z);
		assertEquals(1.0, scaledQuat.w);
		
		quat *= 2.0;
		assertEquals(2.0, quat.x);	
		assertEquals(4.0, quat.y);	
		assertEquals(6.0, quat.z);	
		assertEquals(8.0, quat.w);	
		
		quat /= 2.0;
		assertEquals(1.0, quat.x);	
		assertEquals(2.0, quat.y);	
		assertEquals(3.0, quat.z);	
		assertEquals(4.0, quat.w);			
	}
	
	public function testCombinedRotation()
	{
		var point = new Quaternion(0, 1, 0, 0);
		var rotate1 = Quaternion.fromYawPitchRoll(0, 0, Math.PI / 2);
		var rotate2 = Quaternion.fromYawPitchRoll(Math.PI, 0, 0);
		var rotate = rotate2 * rotate1;

		// rotate (0, 1, 0) 90° about z to (-1, 0, 0)
		// then rotate this 180° about x to (1, 0, 0)
		var rotated = point << rotate;
		assertFloatEquals(1.0, rotated.x);
		assertFloatEquals(0.0, rotated.y);
		assertFloatEquals(0.0, rotated.z);
	}
	
	function assertFloatEquals(ex:Float, act:Float)
		assertTrue(Math.abs(act - ex) < 0.00000001)
}