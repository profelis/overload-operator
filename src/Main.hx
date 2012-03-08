package ;
import deep.macro.math.IOverloadOperator;
import deep.math.Complex;
import deep.math.ComplexMath;
import haxe.unit.TestRunner;
import test.OverloadTestComplex;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */
class Main implements IOverloadOperator<ComplexMath>
{
	// noOverload - overload macros ignore this method
	@noOverload static public function main() 
	{
		var r = new TestRunner();
		r.add(new OverloadTestComplex());
		r.run();
		
		new Main();
	}
	
	public function new()
	{
		var c = new Complex(0, 1);
		c *= new Complex(0, 1);
		//trace(c);
	}
}

