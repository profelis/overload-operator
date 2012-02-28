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
	}
	
	function test2()
	{
		var c:Complex;
		OverloadOperator.calc({
			
			c = new Complex(0, 1);
			c *= c;  // i^2
			
			assertTrue(c == new Complex(-1, 0));
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
	
	function test4()
	{
		var c = new Complex(0, 10);
		var c2:Complex;
		
		OverloadOperator.calc( {
			c2 = c;
			for (i in 0...Std.int(c.im))
			{
				c = c + 0.1;
			}
			assertTrue(Math.abs(c.re - 1) < 0.00000001);
			assertTrue(c != c2);
			
			c = new Complex(0, 10);
			c2 = c;
			for (i in 0...Std.int(c.im))
			{
				c += 0.1;
			}
			assertTrue(c == c2);
			assertTrue(Math.abs(c.re - 1) < 0.00000001);
		});
	}
	
	function test5()
	{
		var c = new Complex(0, 1);
		
		OverloadOperator.calc( {
			c = ComplexMath.add(new Complex(2, 1), c * c);
			
			assertTrue(c == new Complex(1, 1));
			
			assertTrue( -new Complex(3, -4) == new Complex( -3, 4));
		});
	}
	
	function test6()
	{
		var c1 = new Complex(0, 1);
		var c2 = new Complex(-3, 4);
		var c3 = new Complex(6, -3);
		
		OverloadOperator.calc( {
			assertTrue(c1 + c2 * c3 == ComplexMath.add(c1, ComplexMath.mult(c2, c3)));
			
			assertTrue(c2 * c3 + c1 == ComplexMath.add(c1, ComplexMath.mult(c2, c3)));
			
			assertTrue(c1 + c2 * c3 == c2 * c3 + c1);
			assertTrue(c1 + c2 * c3 == c1 + (c2 * c3));
			assertTrue(c1 + c2 * c3 != (c1 + c2) * c3);
		});
	}
	
}