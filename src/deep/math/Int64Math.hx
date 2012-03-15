package deep.math;
import haxe.Int32;
import haxe.Int64;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

class Int64Math 
{

	@op("+", true) inline static public var add = Int64.add;
	
	@op("+", true) inline static public function addInt32(a:Int64, b:Int32):Int64
	{
		return Int64.add(a, Int64.ofInt32(b));
	}
	
	@op("+", true) inline static public function addInt(a:Int64, b:Int):Int64
	{
		return Int64.add(a, Int64.ofInt(b));
	}
	
	@op("-", true) inline static public var sub = Int64.sub;
	
	@op("-", false) inline static public function subInt32(a:Int64, b:Int32):Int64
	{
		return Int64.sub(a, Int64.ofInt32(b));
	}
	
	@op("-", false) inline static public function subInt(a:Int64, b:Int):Int64
	{
		return Int64.sub(a, Int64.ofInt(b));
	}
	
	@op("*", true) inline static public var mult = Int64.mul;
	
	@op("*", true) inline static public function multInt32(a:Int64, b:Int32):Int64
	{
		return Int64.mul(a, Int64.ofInt32(b));
	}
	
	@op("*", true) inline static public function multInt(a:Int64, b:Int):Int64
	{
		return Int64.mul(a, Int64.ofInt(b));
	}
	
	@op("/", true) inline static public var div = Int64.div;
	
	@op("/", false) inline static public function divInt32(a:Int64, b:Int32):Int64
	{
		return Int64.div(a, Int64.ofInt32(b));
	}
	
	@op("/", false) inline static public function divInt(a:Int64, b:Int):Int64
	{
		return Int64.div(a, Int64.ofInt(b));
	}
	
	@op("%", true) inline static public var mod = Int64.mod;
	
	@op("%", false) inline static public function modInt32(a:Int64, b:Int32):Int64
	{
		return Int64.mod(a, Int64.ofInt32(b));
	}
	
	@op("%", false) inline static public function modInt(a:Int64, b:Int):Int64
	{
		return Int64.mod(a, Int64.ofInt(b));
	}
	
	@op("+=", true) inline static public var iadd = Int64.add;
	
	@op("+=", false) inline static public function iaddInt32(a:Int64, b:Int32):Int64
	{
		return Int64.add(a, Int64.ofInt32(b));
	}
	
	@op("+=", false) inline static public function iaddInt(a:Int64, b:Int):Int64
	{
		return Int64.add(a, Int64.ofInt(b));
	}
	
	@op("-=", true) inline static public var isub = Int64.sub;
	
	@op("-=", false) inline static public function isubInt32(a:Int64, b:Int32):Int64
	{
		return Int64.sub(a, Int64.ofInt32(b));
	}
	
	@op("-=", false) inline static public function isubInt(a:Int64, b:Int):Int64
	{
		return Int64.sub(a, Int64.ofInt(b));
	}
	
	@op("*=", true) inline static public var imult = Int64.mul;
	
	@op("*=", false) inline static public function imultInt32(a:Int64, b:Int32):Int64
	{
		return Int64.mul(a, Int64.ofInt32(b));
	}
	
	@op("*=", false) inline static public function imultInt(a:Int64, b:Int):Int64
	{
		return Int64.mul(a, Int64.ofInt(b));
	}
	
	@op("/=", true) inline static public var idiv = Int64.div;
	
	@op("/=", false) inline static public function idivInt32(a:Int64, b:Int32):Int64
	{
		return Int64.div(a, Int64.ofInt32(b));
	}
	
	@op("/=", false) inline static public function idivInt(a:Int64, b:Int):Int64
	{
		return Int64.div(a, Int64.ofInt(b));
	}
	
	@op("<<", true) inline static public var shl = Int64.shl;
	@op("<<=", true) inline static public var ishl = Int64.shl;
	@op(">>", true) inline static public var shr = Int64.shr;
	@op(">>=", true) inline static public var ishr = Int64.shr;
	@op(">>>", true) inline static public var ushr = Int64.ushr;
	@op(">>>=", true) inline static public var iushr = Int64.ushr;
	
	@op("&", true) inline static public var and = Int64.and;
	@op("&=", true) inline static public var iand = Int64.and;
	@op("|", true) inline static public var or = Int64.or;
	@op("|=", true) inline static public var ior = Int64.or;
	@op("^", true) inline static public var xor = Int64.xor;
	@op("^=", true) inline static public var ixor = Int64.xor;
	
	@op("-x") inline static public var neg = Int64.neg;
	
	@op("++x", false) inline static public function inc(a:Int64):Int64
	{
		return Int64.add(a, Int64.ofInt(1));
	}
	
	@op("x++", false) inline static public function pinc(a:Int64):Int64
	{
		return Int64.add(a, Int64.ofInt(1));
	}
	
	@op("--x", false) inline static public function dec(a:Int64):Int64
	{
		return Int64.sub(a, Int64.ofInt(1));
	}
	
	@op("x--", false) inline static public function pdec(a:Int64):Int64
	{
		return Int64.sub(a, Int64.ofInt(1));
	}
	
	@op(">", false) inline static public function gt(a:Int64, b:Int64):Bool
	{
		return Int64.compare(a, b) > 0;
	}
	
	@op(">=", false) inline static public function gte(a:Int64, b:Int64):Bool
	{
		return Int64.compare(a, b) >= 0;
	}
	
	@op("<", false) inline static public function lt(a:Int64, b:Int64):Bool
	{
		return Int64.compare(a, b) < 0;
	}
	
	@op("<=", false) inline static public function lte(a:Int64, b:Int64):Bool
	{
		return Int64.compare(a, b) <= 0;
	}
	
	@op("==", true) inline static public function eq(a:Int64, b:Int64):Bool
	{
		return Int64.compare(a, b) == 0;
	}
	
	@op("==", true) inline public static function eqInt32(a:Int64, b:Int32):Bool
	{
		return Int64.compare(a, Int64.ofInt32(b)) == 0;
	}
	
	@op("==", true) inline public static function eqInt(a:Int64, b:Int):Bool
	{
		return Int64.compare(a, Int64.ofInt(b)) == 0;
	}
	
	@op("!=", true) inline static public function neq(a:Int64, b:Int64):Bool
	{
		return Int64.compare(a, b) != 0;
	}
	
	@op("!=", true) inline public static function neqInt32(a:Int64, b:Int32):Bool
	{
		return Int64.compare(a, Int64.ofInt32(b)) != 0;
	}
	
	@op("!=", true) inline public static function neqInt(a:Int64, b:Int):Bool
	{
		return Int64.compare(a, Int64.ofInt(b)) != 0;
	}
	
	inline static public function abs(a:Int64):Int64
	{
		if (Int64.isNeg(a))
			return Int64.neg(a);
		return a;
	}
	
}