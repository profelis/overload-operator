package deep.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
#end
/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

class OverloadOperator 
{

	@:macro public static function calc(e:Expr):Expr
	{
		if (math == null)
		{
			Context.error("set math first", Context.currentPos());
		}
		//trace(e);
		return parseExpr(e);
	}
	
	@:macro public static function setMath(m:ExprRequire<Class<Dynamic>>)
	{
		if (defaultOp == null) init();
		var type = getType(m);
		var ct:ClassType;
		var op = new Hash<String>();
		switch (type)
		{
			case Type.TInst(t, params):
				ct = t.get();
				
				for (method in ct.statics.get())
				{
					for (meta in method.meta.get())
					{
						if (meta.name != "op") continue;

						var param = meta.params[0];
						var o:String = null;
						switch (param.expr)
						{
							case EConst(c):
								switch (c)
								{
									case CString(s): o = s;
									default:
								}
							default:
						}
						if (o != null)
						{
							trace(o + "  " + method.name);
							op.set(o, method.name);
						}
						break;
					}
				}
			default:
		}
		if (ct == null)
		{
			Context.error("Can't parse math", Context.currentPos());
		}
		var typeExp:Expr;
		var pos = Context.currentPos();
		for (p in ct.pack)
		{
			if (typeExp == null)
			{
				typeExp = { expr:EConst(CIdent(p)), pos:pos };
			}
			else
			{
				typeExp = { expr:EField(typeExp, p), pos:pos };
			}
		}
		typeExp = { expr:EType(typeExp, ct.name), pos:pos };
		
		math = { typeExp:typeExp, op:op };
		
		return {expr:EConst(CIdent("null")), pos:Context.currentPos()}; // null; :)
	}
	
	#if macro
	
	static function parseExpr(e:Expr):Expr
	{
		var pos = Context.currentPos();
		switch (e.expr)
		{
			case EBinop(op, o1, o2):
				switch (op)
				{
					case OpAssign:
						return { expr:EBinop(OpAssign, parseExpr(o1), parseExpr(o2)), pos:pos };
						
					case OpAssignOp(op2):
						var method = defaultOp.get(op2);
						if (method != null && math.op.exists(method + "="))
						{
							return { expr:ECall( {expr:EField(math.typeExp, math.op.get(method + "=")), pos:pos}, [parseExpr(o1), parseExpr(o2)]), pos:pos };
						}
						
					default:
				}
				var method = defaultOp.get(op);
				if (method != null && math.op.exists(method))
				{
					return { expr:ECall( {expr:EField(math.typeExp, math.op.get(method)), pos:pos}, [parseExpr(o1), parseExpr(o2)]), pos:pos };
				}
			case EParenthesis(e2):
				return { expr:EParenthesis(parseExpr(e2)), pos:pos };
			case EBlock(ls):
				var rls = new Array();
				for (i in ls)
					rls.push(parseExpr(i));
				return { expr:EBlock(rls), pos:pos };
			default:
		}
		return e;
	}
	
	static var math:MathType;
	
	static var defaultOp:Map<Dynamic, String>;
	
	static function init()
	{
		defaultOp = new Map<Dynamic, String>();
		defaultOp.set(OpAdd, "+");
		defaultOp.set(OpSub, "-");
		defaultOp.set(OpMult, "*");
		defaultOp.set(OpDiv, "/");
	}
	
	static function getType(math:ExprRequire<Class<Dynamic>>):haxe.macro.Type
	{
		switch (math.expr)
		{
			case EConst(c):
				switch (c)
				{
					case CType(s): return Context.getType(s);
					default:
				}
			default:
		}
		return null;
	}
	#end
}

#if macro

typedef MathType = 
{
	typeExp:Expr,
	op:Hash<String>
}

class Map<K, V>
{
	var keys:Array<K>;
	var values:Array<V>;
	
	public function new()
	{
		keys = new Array<K>();
		values = new Array<V>();
	}
	
	public function set(k:K, v:V)
	{
		var pos = Lambda.indexOf(keys, k);
		if (pos != -1)
		{
			keys.splice(pos, 1);
			values.splice(pos, 1);
		}
		keys.push(k);
		values.push(v);
	}
	
	public function get(k:K):V
	{
		var pos = Lambda.indexOf(keys, k);
		return (pos < 0) ? null : values[pos];
	}
	
	public function exists(k:K):Bool
	{
		return Lambda.indexOf(keys, k) > -1;
	}
	
}
#end