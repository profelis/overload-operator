package ;

import deep.macro.OverloadOperator;
import deep.math.Complex;
import deep.math.ComplexMath;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */
class Main 
{
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		
		var c1 = new Complex(1, 2);
		var c2 = new Complex(-2, -3);
		var c3 = new Complex(4, -5);
		
		
		OverloadOperator.setMath(ComplexMath);
		var c4;
		OverloadOperator.calc( { c4 = c1 + c2; c4 += c3; trace(c4); } );
		
		
		c4 = OverloadOperator.calc(c1 + c2 * c3);
		trace(c4);
		
		c4 = OverloadOperator.calc((c1 + c2) * c3);
		trace(c4);
		
		c4 = OverloadOperator.calc(c1 + (c2 * c3));
		trace(c4);
		
		
		c4 = OverloadOperator.calc(c1 * c2 + c3);
		trace(c4);
		
		c4 = OverloadOperator.calc((c1 * c2) + c3);
		trace(c4);
		
		c4 = OverloadOperator.calc(c1 * (c2 + c3));
		trace(c4);
		
		var c4:Complex;
		OverloadOperator.calc(c4 = c1 * c2);
		trace(c4);
		
	}
	
}

