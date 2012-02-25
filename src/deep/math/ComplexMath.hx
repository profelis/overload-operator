package deep.math;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

class ComplexMath 
{

	@op("+") inline static public function add(a:Complex, b:Complex):Complex
	{
		return new Complex(a.re + b.re, a.im + b.im);
	}
	
	@op("-") inline static public function sub(a:Complex, b:Complex):Complex
	{
		return new Complex(a.re - b.re, a.im - b.im);
	}
	
	@op("*") inline static public function mult(a:Complex, b:Complex):Complex
	{
		return new Complex(a.re * b.re - a.im * b.im, a.re * b.im + a.im * b.re);
	}
	
	@op("/") inline static public function div(a:Complex, b:Complex):Complex
	{
		var div = 1 / (b.re * b.re + b.im * b.im);
		return new Complex((a.re * b.re + a.im * b.im) * div, (a.re * b.im + a.im * b.re) * div);
	}
	
	@op("+=") inline static public function iadd(a:Complex, b:Complex):Complex
	{
		a.re += b.re;
		a.im += b.im;
		return a;
	}
	
	@op("-=") inline static public function isub(a:Complex, b:Complex):Complex
	{
		a.re -= b.re;
		a.im -= b.im;
		return a;
	}
	
	@op("*=") inline static public function imult(a:Complex, b:Complex):Complex
	{
		var re = a.re;
		a.re = re * b.re - a.im * b.im;
		a.im = re * b.im + a.im * b.re;
		return a;
	}
	
	@op("/=") inline static public function idiv(a:Complex, b:Complex):Complex
	{
		var re = a.re;
		var div = 1 / (b.re * b.re + b.im * b.im);
		a.re = (re * b.re + a.im * b.im) * div;
		a.im = (re * b.im + a.im * b.re) * div;
		return a;
	}
	
	@op("==") public static function eq(a:Complex, b:Complex):Bool
	{
		return a.re == b.re && a.im == b.im;
	}
	
	@op("!=") public static function notEq(a:Complex, b:Complex):Bool
	{
		return a.re != b.re || a.im != b.im;
	}
	
}