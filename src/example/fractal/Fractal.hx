package example.fractal;
import deep.macro.math.IOverloadOperator;
import deep.math.Complex;
import deep.math.ComplexMath;
import haxe.Timer;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

using deep.math.ComplexMath;
 
class Fractal implements IOverloadOperator<ComplexMath>
{
	@noOverload public static function main()
	{
		new Fractal();
	}
	
	@noOverload public function new() 
	{
		var s = Lib.current.stage;
		s.scaleMode = StageScaleMode.NO_SCALE;
		s.align = StageAlign.TOP_LEFT;
		
		
		var bd = new BitmapData(800, 800, false, 0xFFFFFF);
		fractal(45, new Complex(-0.008, 0.697), bd, true);
		
		s.addChild(new Bitmap(bd));
	}
	
	var timer:Timer;
	
	function fractal(randomSeed:Int, c:Complex, res:BitmapData, timed:Bool = false):Void
	{
		if (timer != null)
		{
			timer.stop();
			timer = null;
		}
		var w = Math.round(res.width / 2);
		var h = Math.round(res.height / 2);
		var z = new Complex();
		var i:Int;
		var j = -h;
		var k:Int;
		var step = 5;
		
		var ts = Timer.stamp();
		
		function tick():Void
		{
			res.lock();
			for (t in 0...step)
			{
				i = -w;
				while (i <= w)
				{
					z.re = i / w;
					z.im = j / h;
					k = 0;
					while (k < randomSeed)
					{
						z.sqr();
						z += c;
						
						if (z.abs2() > 1.0E10) break;
						k++;
					}
					res.setPixel(i + w, j + h, fromHSV((k / randomSeed) * 360));
					i++;
				}
				j++;
				if (j > h)
				{
					res.unlock();
					if (timer != null)
					{
						timer.stop();
						timer = null;
						trace("render time: " + (Timer.stamp() - ts));
					}
					return;
				}
			}
			res.unlock();
		}
		if (!timed)
		{
			for (k in 0...Std.int(2 * h / step)) tick();
			trace("render time: " + (Timer.stamp() - ts));
		}
		else
		{
			timer = new Timer(30);
			timer.run = tick;
		}
	}
	
	@noOverload	inline static function fromHSV(hue:Float):Int
    {
		var h:Float = (hue  + 360) % 360;
		var v:Float = 1;
		var hi:Int = Math.round(h / 60) % 6;
		var f:Float = h / 60 - hi;
		var p:Float = 0;
		var q:Float = 1 - f;
		var t:Float = f;
		if (hi == 0) return fromFloats(v, t, p); 
		else if (hi == 1) return fromFloats(q, v, p);
		else if (hi == 2) return fromFloats(p, v, t); 
		else if (hi == 3) return fromFloats(p, q, v);
		else if (hi == 4) return fromFloats(t, p, v);
		else if (hi == 5) return fromFloats(v, p, q);
		else return 0;
	}
	
	@noOverload
	inline static function fromFloats(red:Float, green:Float, blue:Float):Int
	{
		return 0x10000*Math.round(red*0xFF) + 0x100*Math.round(green*0xFF) + Math.round(blue*0xFF);
	}
}