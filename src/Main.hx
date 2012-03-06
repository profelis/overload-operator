package ;
import deep.macro.math.IOverloadOperator;
import deep.macro.math.OverloadOperator;
import deep.math.Complex;
import deep.math.ComplexMath;
import haxe.unit.TestRunner;
import nme.geom.Point;
//import test.OverloadTestComplex;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */
class Main implements IOverloadOperator<ComplexMath>
{
	
	static public function main() 
	{
		/*
		var r = new TestRunner();
		r.add(new OverloadTestComplex());
		r.run();
		*/
		
		//OverloadOperator.addMath(ComplexMath);
		
		new Main();
	}
			
	public function new()
	{
		init();
		var c1:Complex = new Complex(1, 2);
		var c2:Complex = new Complex(3, 4);
		//trace(c + c2);
		//trace(c == c2);
		//trace(c1 + c2);
		trace(cp1 + c1); // normal var
		trace(cp2 + c1); // prop getter
		trace(getCp1() + c1); // normal function
	}
		
	var cp2(getCp2, null):Complex;
	
	function getCp2()
		return new Complex(9, 9)
	
	function getCp1():Complex
		return cp1
	
	var cp1:Complex;
		
	function init()
	{
		cp1 = new Complex(5, 5);
	}
}

