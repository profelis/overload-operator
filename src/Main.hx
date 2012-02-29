package ;
import deep.macro.OverloadOperator;
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
		
		//new Main();
	}
	
	public function new()
	{
		var a = 0;
		var b = 1;
		var c = [1, 2];
		var d:Class<Dynamic>;
		OverloadOperator.self(t = 3);
	}
	
	public var t(get_t, null):Float;
	
	function get_t() { return t; }
	
}

