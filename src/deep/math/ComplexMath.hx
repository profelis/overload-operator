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
	
}