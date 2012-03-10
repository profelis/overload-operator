package test;

import haxe.unit.TestRunner;

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

