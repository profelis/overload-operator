package test;
import deep.macro.math.IOverloadOperator;
import deep.math.Int64Math;
import haxe.Int64;
import haxe.unit.TestCase;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

class OverloadTestInt64 extends TestCase, implements IOverloadOperator<Int64Math>
{

	public function new() 
	{
		super();
	}
	
	function test1()
	{
		var i1 = Int64.ofInt(30);
		var i2 = Int64.ofInt(3000);
		
		assertTrue(i1 + i2 == 3030);
		assertTrue(i1 < i2);
		assertFalse(i1 > i2);
		assertTrue(i2 > i1);
		assertFalse(i2 < i1);
		
		assertTrue(i1 == 30);
		assertTrue(i2 == 3000);
		assertTrue(i1 != i2);
		
		assertTrue(i1 * i2 == 90000);
		assertTrue(i2 / i1 == 100);
		
		assertTrue(i2 % i1 == 0);
		assertTrue(i1 % i2 == 30);
		
		assertTrue(i1 << 1 == 60);
		assertTrue(i2 >> 1 == 1500);
		
		assertTrue( -i2 >> 1 == -1500);
		
		i1 <<= 2;
		assertTrue(i1 == 120);
		i1 >>= 2;
		assertTrue(i1 == 30);
		
		i1++;
		assertTrue(i1 == 31);
		--i1;
		assertTrue(i1 == 30);
		
		i1 += 10;
		assertTrue(i1 == 40);
		i1 -= 10;
		assertTrue(i1 == 30);
		
		assertTrue( -i1 == -30);
		
		assertTrue(i1 & i2 == 30 & 3000);
		assertTrue(i1 | i2 == 30 | 3000);
		assertTrue(i1 ^ i2 == 30 ^ 3000);
	}
	
}