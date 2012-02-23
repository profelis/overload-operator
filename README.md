
```
var c1 = new Complex(1, 2);
var c2 = new Complex(-2, -3);
var c3 = new Complex(4, -5);

OverloadOperator.setMath(ComplexMath);
var c4 = OverloadOperator.calc(c1 + c2 * c3);
```