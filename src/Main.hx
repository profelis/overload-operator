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
class Main implements IOverloadOperator
{
	
	static public function main() 
	{
		/*
		var r = new TestRunner();
		r.add(new OverloadTestComplex());
		r.run();
		*/
		
		OverloadOperator.addMath(ComplexMath);
		
		new Main();
	}
	
	public function new()
	{
		
		
		var c1:Complex = new Complex(1, 2);
		var c2:Complex = new Complex(3, 4);
		//trace(c + c2);
		//trace(c == c2);
		c1 + c2;
	}
}

