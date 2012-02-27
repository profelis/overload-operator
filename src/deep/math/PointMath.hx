package deep.math;
import nme.geom.Point;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

class PointMath 
{

	@op("+", true) public static function add(a:Point, b:Point):Point
	{
		return new Point(a.x + b.x, a.y + b.y);
	}
	
	@op("+", true) public static function addScalarFloat(a:Point, b:Float):Point
	{
		return new Point(a.x + b, a.y + b);
	}
	
	@op("+", true) public static function addScalarInt(a:Point, b:Int):Point
	{
		return new Point(a.x + b, a.y + b);
	}
	
	@op("-", true) public static function sub(a:Point, b:Point):Point
	{
		return new Point(a.x - b.x, a.y - b.y);
	}
	
	@op("-", false) public static function subScalarFloat(a:Point, b:Float):Point
	{
		return new Point(a.x - b, a.y - b);
	}
	
	@op("-", false) public static function subScalarInt(a:Point, b:Int):Point
	{
		return new Point(a.x - b, a.y - b);
	}
	
	@op("/", false) public static function divScalarInt(a:Point, b:Int):Point
	{
		return new Point(a.x / b, a.y / b);
	}
	
	@op("/", false) public static function divScalarFloat(a:Point, b:Float):Point
	{
		return new Point(a.x / b, a.y / b);
	}
	
	@op("*", true) public static function multScalarInt(a:Point, b:Int):Point
	{
		return new Point(a.x * b, a.y * b);
	}
	
	@op("*", true) public static function multScalarFloat(a:Point, b:Float):Point
	{
		return new Point(a.x * b, a.y * b);
	}
	
}