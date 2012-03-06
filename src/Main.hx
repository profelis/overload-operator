package ;
import deep.math.ComplexMath;
import haxe.unit.TestRunner;
import test.OverloadTestComplex;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */
class Main
{
	
	static public function main() 
	{
		
		var r = new TestRunner();
		r.add(new OverloadTestComplex());
		r.run();
	}
}

