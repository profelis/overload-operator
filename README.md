
```
ComplexMath.hx
...
// @op(operator, [commutative=false])
// support operators
// + - * / % += -= *= /= %=
// < > == != <= >=
// & && | || ^ ! 
// << >> <<< ~
// ...
// ++x x++ --x x-- -x 
@op("+", true) inline static public function add(a:Complex, b:Complex):Complex
{
	return new Complex(a.re + b.re, a.im + b.im);
}

@op("+", true) inline static public function addFloat(a:Complex, b:Float):Complex
{
	return new Complex(a.re + b, a.im);
}

@op("/=", true) inline static public function idiv(a:Complex, b:Complex):Complex
{
	var are = a.re;
	var bre = b.re;
	var div = 1 / (bre * bre + b.im * b.im);
	a.re = (are * bre + a.im * b.im) * div;
	a.im = (are * b.im + a.im * bre) * div;
	return a;
}
...

Test.hx
...
var c = new Complex(1, -3.0);
var c2:Complex;

OverloadOperator.calc( {
	c2 = new Complex(0, c.re);
	c.im = 0;
	c /= c2;
	
	var c3 = c + c2;
	
	assertTrue(ComplexMath.eq(c3, ComplexMath.add(c, c2)));
});

assertTrue(ComplexMath.eq(c, c2));
...
```