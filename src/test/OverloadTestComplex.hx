package test;
import deep.macro.math.IOverloadOperator;
import deep.math.Complex;
import deep.math.ComplexMath;
import haxe.unit.TestCase;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */
class A
{
	public var a:Complex;
	
	public var b(getB, setB):Complex;
	
	private var _b:Complex;
	
	function getB() { return _b; }
	
	function setB(v:Complex) { a = v; return _b = v; }
	
	public function new()
	{
		a = new Complex(0, 1);
	}
}

enum ComplexRef 
{
	Ref(c:Complex);
	Ref2(c:Complex, b:Complex);
	Null;
}

class OverloadTestComplex extends TestCase, implements IOverloadOperator<ComplexMath>
{

	public function new() 
	{
		super();
	}
	
	
	function test1()
	{
		var c1 = new Complex(2, 3);
		var c2 = new Complex( -4, 1);
		var c3;
		
		c3 = c1 + c2;
		
		assertTrue(ComplexMath.eq(c3, new Complex( -2, 4)));
	}
	
	function test2()
	{
		var c:Complex;
			
		c = new Complex(0, 1);
		c *= c;  // i^2
		
		assertTrue(c == new Complex(-1, 0));
	}
	
	function test3()
	{
		var c:Complex = new Complex(1, -3.0);
		var c2:Complex = new Complex(0, c.re);
		c.im = 0;
		c /= c2;
		
		var c3 = c + c2;
		
		assertTrue(c3 == ComplexMath.add(c, c2));
	}
	
	function test4()
	{
		var c = new Complex(0, 10);
		var c2:Complex;
		
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
	}
	
	function test5()
	{
		var c = new Complex(0, 1);
		
		c = ComplexMath.add(new Complex(2, 1), c * c);
		
		assertTrue(c == new Complex(1, 1));
		
		assertTrue( -new Complex(3, -4) == new Complex( -3, 4));
	}
	
	function test6()
	{
		var c1 = new Complex(0, 1);
		var c2 = new Complex(-3, 4);
		var c3 = new Complex(6, -3);
		
		assertTrue(c1 + c2 * c3 == ComplexMath.add(c1, ComplexMath.mult(c2, c3)));
		
		assertTrue(c2 * c3 + c1 == ComplexMath.add(c1, ComplexMath.mult(c2, c3)));
		
		assertTrue(c1 + c2 * c3 == c2 * c3 + c1);
		assertTrue(c1 + c2 * c3 == c1 + (c2 * c3));
		assertTrue(c1 + c2 * c3 != (c1 + c2) * c3);
	}
	
	var cR(default, null):Complex;
	var cW(null, default):Complex;
	var cProp(get_c, set_c):Complex;
	var _cProp:Complex;
	
	function get_c() { return _cProp; }
	function set_c(v) { return _cProp = v; }
	
	function test7()
	{
		cR = new Complex(0, 1);
		var a = [new Complex(1, 2), new Complex(3, 4), null];
		cR *= cR;
		
		assertTrue(cR == new Complex( -1, 0));
		
		cW = cR;
		cW += new Complex(1, 1);
		
		assertTrue(cW == new Complex(0, 1));
		
		cProp = cR + cW;
		cProp += 1.5;
		assertTrue(cProp == _cProp);
		
		a[2] = a[0] * a[1];
		assertTrue(a[2] == ComplexMath.mult(a[0], a[1]));
	}
	
	function test8()
	{
		var a:A = new A();
		a.a *= new Complex(0, 1);
		assertTrue(a.a == new Complex( -1));
		
		a.b = new Complex(1);
		
		assertTrue(a.a != new Complex( -1));
		assertTrue(a.a == new Complex( 1));
	}
	
	function test9()
	{
		
		try
		{
			throw new Complex(1, 2);
		}
		catch (e:Complex)
		{
			assertTrue(e + 3.0 == new Complex(4, 2));
		}
		catch (d:Dynamic)
		{
			assertTrue(false);
		}
		
		var r = Ref(new Complex(0, 1));
		switch (r)
		{
			case Ref(tc):
				tc *= tc;
				assertTrue(tc == new Complex( -1, 0));
			default:
				assertTrue(false);
		}
		
		var d = Ref2(new Complex(1, 0), new Complex(0, 1));
		switch (d)
		{
			case Ref2(a, b):
				assertTrue(a + b == new Complex(1, 1));
			case Ref(a):
				assertFalse(true);
			default:
				assertFalse(true);
		}
		
		switch (d)
		{
			case Ref2(_, b):
				assertTrue(b == new Complex(0, 1));
			case Ref(a):
				assertFalse(true);
			default:
				assertFalse(true);
		}
	}
	
	function test10()
	{
		var a = [new Complex(0, 1), new Complex(1, 1), new Complex(-1, 3)];
		print(a.length);
		var s = new Complex();
		
		for (c in Lambda.list(a))
		{
			s += c;
		}
		
		assertTrue(s == new Complex(0, 5));
	}
	
	static inline var z:Complex = new Complex(0, 1) + new Complex(1, 0);
	
	function test11()
	{
		assertTrue(z == new Complex(1, 1));
	}
	
}