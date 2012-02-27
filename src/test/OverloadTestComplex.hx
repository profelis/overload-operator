package test;
import deep.macro.OverloadOperator;
import deep.math.Complex;
import deep.math.ComplexMath;
import haxe.unit.TestCase;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

class OverloadTestComplex extends TestCase
{

	public function new() 
	{
		super();
	}
	
	override public function setup():Void 
	{
		OverloadOperator.clearMath();
		OverloadOperator.addMath(ComplexMath);
	}
	
	function test1()
	{
		var c1 = new Complex(2, 3);
		var c2 = new Complex( -4, 1);
		var c3;
		
		OverloadOperator.calc(c3 = c1 + c2);
		
		assertTrue(ComplexMath.eq(c3, new Complex( -2, 4)));
		
		assertFalse(false);
	}
	
	function test2()
	{
		var c:Complex;
		OverloadOperator.calc({
			
			c = new Complex(0, 1);
			c *= c;  // i^2
			
			assertTrue(c.im == 0 && c.re == -1);
		});
	}
	
	function test3()
	{
		var c = new Complex(1, -3.0);
		var c2:Complex;
		
		OverloadOperator.calc( {
			c2 = new Complex(0, c.re);
			c.im = 0;
			c /= c2;
			
			var c3 = c + c2;
			assertTrue(ComplexMath.eq(c3, ComplexMath.add(c, c2)));
		});
		
		assertTrue(ComplexMath.eq(c, c2));
		
	}
	
}