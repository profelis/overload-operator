package deep.math;

import deep.macro.math.IOverloadOperator;

/**
 * ...
 * @author Simon Krajewski
 */

class Quaternion
{
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float;
	
	public function new(x, y, z, w) 
	{
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
	
	public function getNorm()
	{
		return Math.sqrt(x * x + y * y + z * z + w * w);
	}
	
	public function normalize()
	{
		return QuaternionMath.scalarDiv(this, getNorm());
	}
	
	public function invert()
	{
		return QuaternionMath.scalar(QuaternionMath.conjugate(this), getNorm());
	}
	
	static public function fromAxisAngle(x:Float, y:Float, z:Float, a:Float)
	{
		var r = Math.sin(a / 2.0);
		return new Quaternion(x * r, y * r, z * r, Math.cos(a / 2.0));
	}
	
	static public function fromYawPitchRoll(yaw:Float, pitch:Float, roll:Float)
	{
		var x = fromAxisAngle(1, 0, 0, pitch);
		var y = fromAxisAngle(0, 1, 0, yaw);
		var z = fromAxisAngle(0, 0, 1, roll);

		return QuaternionMath.mul(QuaternionMath.mul(x, y), z);
	}
	
	public function toString()
	{
		return "[Quaternion " +x + " " +y + " " +z + " " +w + "]";
	}
}