package deep.math;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

class ComplexMath 
{

	@op("+", true) inline static public function add(a:Complex, b:Complex):Complex
	{
		return new Complex(a.re + b.re, a.im + b.im);
	}
	
	@op("+", true) inline static public function addFloat(a:Complex, b:Float):Complex
	{
		return new Complex(a.re + b, a.im);
	}
	
	@op("-", true) inline static public function sub(a:Complex, b:Complex):Complex
	{
		return new Complex(a.re - b.re, a.im - b.im);
	}
	
	@op("-", false) inline static public function subFloat(a:Complex, b:Float):Complex
	{
		return new Complex(a.re - b, a.im);
	}
	
	@op("*", true) inline static public function mult(a:Complex, b:Complex):Complex
	{
		return new Complex(a.re * b.re - a.im * b.im, a.re * b.im + a.im * b.re);
	}
	
	@op("*", true) inline static public function multFloat(a:Complex, b:Float):Complex
	{
		return new Complex(a.re * b, a.im * b);
	}
	
	@op("/", true) inline static public function div(a:Complex, b:Complex):Complex
	{
		var div = 1 / (b.re * b.re + b.im * b.im);
		return new Complex((a.re * b.re + a.im * b.im) * div, (a.re * b.im + a.im * b.re) * div);
	}
	
	@op("/", false) inline static public function divFloat(a:Complex, b:Float):Complex
	{
		return new Complex(a.re / b, a.im / b);
	}
	
	@op("+=", true) inline static public function iadd(a:Complex, b:Complex):Complex
	{
		a.re += b.re;
		a.im += b.im;
		return a;
	}
	
	@op("+=", false) inline static public function iaddFloat(a:Complex, b:Float):Complex
	{
		a.re += b;
		return a;
	}
	
	@op("-=", true) inline static public function isub(a:Complex, b:Complex):Complex
	{
		a.re -= b.re;
		a.im -= b.im;
		return a;
	}

	@op("-=", false) inline static public function isubFloat(a:Complex, b:Float):Complex
	{
		a.re -= b;
		return a;
	}
	
	@op("*=", true) inline static public function imult(a:Complex, b:Complex):Complex
	{
		var are = a.re;
		var bre = b.re;
		a.re = are * bre - a.im * b.im;
		a.im = are * b.im + a.im * bre;
		return a;
	}
	
	@op("*=", false) inline static public function imultFloat(a:Complex, b:Float):Complex
	{
		a.re *= b;
		a.im *= b;
		return a;
	}
	
	@op("/=") inline static public function idiv(a:Complex, b:Complex):Complex
	{
		var are = a.re;
		var bre = b.re;
		var div = 1 / (bre * bre + b.im * b.im);
		a.re = (are * bre + a.im * b.im) * div;
		a.im = (are * b.im + a.im * bre) * div;
		return a;
	}
	
	@op("/=", false) inline static public function idivFloat(a:Complex, b:Float):Complex
	{
		a.re /= b;
		a.im /= b;
		return a;
	}
	
	@op("==", true) public static function eq(a:Complex, b:Complex):Bool
	{
		return a.re == b.re && a.im == b.im;
	}
	
	@op("==", true) public static function eqFloat(a:Complex, b:Float):Bool
	{
		return a.re == b && a.im == 0;
	}
	
	@op("!=", true) public static function notEq(a:Complex, b:Complex):Bool
	{
		return a.re != b.re || a.im != b.im;
	}
	
	@op("!=", true) public static function notEqFloat(a:Complex, b:Float):Bool
	{
		return a.re != b || a.im != 0;
	}
	
}