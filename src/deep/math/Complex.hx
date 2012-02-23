package deep.math;
/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

class Complex 
{

	public var re:Float;
	public var im:Float;
	
	public function new(re:Float = 0, im:Float = 0) 
	{
		this.re = re;
		this.im = im;
	}
	
	public function toString()
	{
		return "[Complex: " + re + ", " + im + "]";
	}
	
}