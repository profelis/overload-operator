## haXe operator overloading tool

Macros

@op(operator, [commutative=false])

@noOverload - ignore

Support operators

```
+ - * / % += -= *= /= %=
< > == != <= >=
& && | || ^ ! 
<< >> <<< ~
...
++x x++ --x x-- -x 
```

## Demo code:

* ComplexMath.hx

```
...

@op("+", true) inline static public function add(a:Complex, b:Complex):Complex
{
	return new Complex(a.re + b.re, a.im + b.im);
}

@op("+", true) inline static public function addFloat(a:Complex, b:Float):Complex
{
	return new Complex(a.re + b, a.im);
}

@op("-x") inline static public function neg(a:Complex):Complex
{
	a.re = -a.re;
	a.im = -a.im;
	return a;
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

@op("==", true) public static function eq(a:Complex, b:Complex):Bool
{
	return a.re == b.re && a.im == b.im;
}
...
```

* Main.hx

```
...
class Main implements IOverloadOperator<ComplexMath>
{
	// noOverload - ignore this method
	@noOverload static public function main() 
	{
		var r = new TestRunner();
		r.add(new OverloadTestComplex());
		//r.run();
		
		new Main();
	}
	
	public function new()
	{
		var c = new Complex(0, 1);
		c *= new Complex(0, 1);  // c = ComplexMath.imult(c, new Complex(0, 1));
		trace(c);
	}
}
```