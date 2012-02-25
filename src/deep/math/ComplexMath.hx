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
	
}