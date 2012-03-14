package deep.math;

/**
 * ...
 * @author Simon Krajewski
 */

class QuaternionMath
{
	// basic arithmetic
	
	@op('+', true) inline static public function add(lhs:Quaternion, rhs:Quaternion)
	{
		return new Quaternion(lhs.x + rhs.x,
			lhs.y + rhs.y,
			lhs.z + rhs.z,
			lhs.w + rhs.w);
	}
	
	@op('-', true) inline static public function sub(lhs:Quaternion, rhs:Quaternion)
	{
		return new Quaternion(lhs.x - rhs.x,
			lhs.y - rhs.y,
			lhs.z - rhs.z,
			lhs.w - rhs.w);
	}

	@op('*', true) inline static public function mul(lhs:Quaternion, rhs:Quaternion)
	{
		return new Quaternion(
			rhs.x * lhs.w + rhs.w * lhs.x + rhs.z * lhs.y - rhs.y * lhs.z,
			rhs.y * lhs.w + rhs.w * lhs.y + rhs.x * lhs.z - rhs.z * lhs.x,
			rhs.z * lhs.w + rhs.w * lhs.z + rhs.y * lhs.x - rhs.x * lhs.y,
			rhs.w * lhs.w - rhs.x * lhs.x - rhs.y * lhs.y - rhs.z * lhs.z
		);		
	}
	
	// arithmetic assignment versions
	
	@op('+=', true) inline static public function addAssign(lhs:Quaternion, rhs:Quaternion)
	{
		lhs.x += rhs.x;
		lhs.y += rhs.y;
		lhs.z += rhs.z;
		lhs.w += rhs.w;
		return lhs;
	}
	
	@op('-=', true) inline static public function subAssign(lhs:Quaternion, rhs:Quaternion)
	{
		lhs.x -= rhs.x;
		lhs.y -= rhs.y;
		lhs.z -= rhs.z;
		lhs.w -= rhs.w;
		return lhs;
	}	

	@op('*=', true) inline static public function mulAssign(lhs:Quaternion, rhs:Quaternion)
	{
		lhs.x = rhs.x * lhs.w + rhs.w * lhs.x + rhs.z * lhs.y - rhs.y * lhs.z;
		lhs.y = rhs.y * lhs.w + rhs.w * lhs.y + rhs.x * lhs.z - rhs.z * lhs.x;
		lhs.z = rhs.z * lhs.w + rhs.w * lhs.z + rhs.y * lhs.x - rhs.x * lhs.y;
		lhs.w = rhs.w * lhs.w - rhs.x * lhs.x - rhs.y * lhs.y - rhs.z * lhs.z;
		return lhs;
	}

	// conjugation
	
	@op('-x') inline static public function conjugate(rhs:Quaternion)
	{
		return new Quaternion( -rhs.x, -rhs.y, -rhs.z, rhs.w);
	}
		
	// rotation
	
	@op('<<', true) inline static public function rotate(point:Quaternion, rotation:Quaternion)
	{
		return mul(mul(rotation, point), conjugate(rotation));
	}
	
	// scalar
	
	@op("*", false) inline static public function scalar(quat:Quaternion, scalar:Float)
	{
		return new Quaternion(quat.x * scalar, quat.y * scalar, quat.z * scalar, quat.w * scalar);
	}
	
	@op("/", false) inline static public function scalarDiv(quat:Quaternion, scalar:Float)
	{
		return new Quaternion(quat.x / scalar, quat.y / scalar, quat.z / scalar, quat.w / scalar);
	}	
	
	// scalar assignment versions
	
	@op("*=", false) inline static public function scalarAssign(quat:Quaternion, scalar:Float)
	{
		quat.x *= scalar;
		quat.y *= scalar;
		quat.z *= scalar;
		quat.w *= scalar;
		return quat;
	}
	
	@op("/=", false) inline static public function scalarDivAssign(quat:Quaternion, scalar:Float)
	{
		quat.x /= scalar;
		quat.y /= scalar;
		quat.z /= scalar;
		quat.w /= scalar;
		return quat;
	}	
	
	// comparison
	
	@op("==", true) inline static public function equals(lhs:Quaternion, rhs:Quaternion)
	{
		return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w;
	}
	
	@op("!=", true) inline static public function notEquals(lhs:Quaternion, rhs:Quaternion)
	{
		return lhs.x != rhs.x || lhs.y != rhs.y || lhs.z != rhs.z || lhs.w != rhs.w;
	}	
}