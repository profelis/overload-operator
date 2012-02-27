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
			Context.error("add math first", Context.currentPos());
		
		return parseExpr(e);
	}
	
	@:macro public static function clearMath():Expr
	{
		math = null;
		return {expr:EConst(CIdent("null")), pos:Context.currentPos()};
	}
	
	@:macro public static function addMath(m:ExprRequire<Class<Dynamic>>)
	{
		if (defaultOp == null) init();
		var type:Type;
		var pos = m.pos;
		switch (m.expr)
		{
			case EConst(c):
				switch (c)
				{
					case CType(s):
						type = Context.getType(s);
					default:
				}
			case EType(e, field):
				type = Context.getType(field);
				
			default:
		}
		if (type == null)
			Context.error("Math is unknown", pos);
		
		var typeExp:Expr;
		if (math == null) math = new Hash<Expr>();
		switch (type)
		{
			case Type.TInst(t, params):
				var ct = t.get();
				
				for (p in ct.pack)
				{
					if (typeExp == null)
						typeExp = { expr:EConst(CIdent(p)), pos:pos };
					else
						typeExp = { expr:EField(typeExp, p), pos:pos };
				}
				typeExp = { expr:EType(typeExp, ct.name), pos:pos };
				
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
						var com = false;
						param = meta.params[1];
						if (param != null)
						{
							switch (param.expr)
							{
								case EConst(c):
									switch (c)
									{
										case CIdent(i): com = i == "true";
										default:
									}
								default:
							}
						}
						var t = method.type;
						var ts = new Array<Type>();
						switch (t)
						{
							case TFun(args, ret):
								for (a in args) ts.push(a.t);
							default:
						}
						var h = "";
						for (t in ts) h += typeName(t) + "->";
						h = h.substr(0, h.length - 2);
						
						var key = o + ":" + h;
						var value = { expr:EField(typeExp, method.name), pos:pos };
						//trace(key + "    " + value);
						if (math.exists(key)) trace("Overriding existing method " + key);
						math.set(key, value);
						
						if (com && ts.length == 2)
						{
							ts.push(ts.shift());
							h = "";
							for (t in ts) h += typeName(t) + "->";
							h = h.substr(0, h.length-2);
							key = "C:" + o + ":" + h;
							//trace(key + "    " + value);
							if (math.exists(key)) trace("Overriding existing method " + key);
							math.set(key, value);
						}
					}
				}
			default:
		}
		if (typeExp == null) Context.error("Can't parse math", pos);
		
		return {expr:EConst(CIdent("null")), pos:pos};
	}
	
	#if macro
	
	static function parseExpr(e:Expr):Expr
	{
		var pos = e.pos;
		switch (e.expr)
		{
			case EUnop(op, postFix, e1):
				var o = defaultOp.get(op);
				if (postFix) o = o.substr( -1) + o.substr(0, o.length - 1);
				e1 = parseExpr(e1);
				var t1 = typeOf(e1);
				if (t1 == null) Context.error("can't recognize type", e1.pos);
				
				var h = typeName(t1);
				var key = o + ":" + h;
				if (math.exists(key)) return { expr:ECall( math.get(key), [e1]), pos:pos };
				
				return { expr:EUnop(op, postFix, e1), pos:pos };
				
			case EBinop(op, e1, e2):
				switch (op)
				{
					case OpAssign:
						return { expr:EBinop(OpAssign, parseExpr(e1), parseExpr(e2)), pos:pos };
						
					case OpAssignOp(op2):
						var o = defaultOp.get(op2) + "=";
						e1 = parseExpr(e1);
						e2 = parseExpr(e2);
						var t1 = typeOf(e1);
						var t2 = typeOf(e2);
						
						if (t1 == null) Context.error("can't recognize type", e1.pos);
						if (t2 == null) Context.error("can't recognize type", e2.pos);
							
						var h = typeName(t1) + "->" + typeName(t2);
						var key = o + ":" + h;
						if (math.exists(key))
						{
							return { expr:ECall( math.get(key), [e1, e2]), pos:pos };
						}
						else
						{
							key = "C:" + key;
							if (math.exists(key)) return { expr:ECall( math.get(key), [e2, e1]), pos:pos };
						}
						return { expr:EBinop(OpAssignOp(op2), e1, e2), pos:pos };
						
					default:
				}
				var o = defaultOp.get(op);
				e1 = parseExpr(e1);
				e2 = parseExpr(e2);
				var t1 = typeOf(e1);
				var t2 = typeOf(e2);
				
				if (t1 == null)
					Context.error("can't recognize type", e1.pos);
				if (t2 == null)
					Context.error("can't recognize type", e2.pos);
					
				var h = typeName(t1) + "->" + typeName(t2);
				var key = o + ":" + h;
				if (math.exists(key))
				{
					return { expr:ECall( math.get(key), [e1, e2]), pos:pos };
				}
				else
				{
					key = "C:" + key;
					if (math.exists(key)) return { expr:ECall( math.get(key), [e2, e1]), pos:pos };
				}
				
				return { expr:EBinop(op, e1, e2), pos:pos };
				
			case EParenthesis(e):
				return { expr:EParenthesis(parseExpr(e)), pos:pos };
				
			case EBlock(exprs):
				var nexprs = new Array<Expr>();
				for (i in exprs)
					nexprs.push(parseExpr(i));
				return { expr:EBlock(nexprs), pos:pos };
				
			case EArrayDecl(values):
				var nvalues = new Array<Expr>();
				for (i in values)
					nvalues.push(parseExpr(i));
				return { expr:EArrayDecl(nvalues), pos:pos };
				
			case EVars(vars):
				for (i in vars)
					i.expr = parseExpr(i.expr);
				return { expr:EVars(vars), pos:pos };
			default:
				
			case EUntyped(e):
				return { expr:EUntyped(parseExpr(e)), pos:pos };
				
			case ECall(e, params):
				var nparams = new Array<Expr>();
				for (i in params)
					nparams.push(parseExpr(i));
				return { expr:ECall(e, nparams), pos:pos };
				
			case ENew(t, params):
				var nparams = new Array<Expr>();
				for (i in params)
					nparams.push(parseExpr(i));
				return { expr:ENew(t, nparams), pos:pos };
		}
		return e;
	}
	
	static var math:Hash<Expr>;
	
	static var defaultOp:Map<Dynamic, String>;
	
	static function init()
	{
		if (defaultOp != null) return;
		defaultOp = new Map<Dynamic, String>();
		// http://haxe.org/api/haxe/macro/binop
		defaultOp.set(OpAdd, "+");
		defaultOp.set(OpSub, "-");
		defaultOp.set(OpMult, "*");
		defaultOp.set(OpDiv, "/");
		defaultOp.set(OpEq, "==");
		defaultOp.set(OpNotEq, "!=");
		defaultOp.set(OpGt, ">");
		defaultOp.set(OpGte, ">=");
		defaultOp.set(OpLt, "<");
		defaultOp.set(OpLte, "<=");
		defaultOp.set(OpAnd, "&");
		defaultOp.set(OpBoolAnd, "&&");
		defaultOp.set(OpOr, "|");
		defaultOp.set(OpBoolOr, "||");
		defaultOp.set(OpXor, "^");
		defaultOp.set(OpShl, ">>");
		defaultOp.set(OpShr, "<<");
		defaultOp.set(OpUShr, "<<<");
		defaultOp.set(OpMod, "%");
		defaultOp.set(OpInterval, "...");
		
		defaultOp.set(OpIncrement, "++x"); // "x++" postfix
		defaultOp.set(OpDecrement, "--x"); // "x--" postfix
		defaultOp.set(OpNot, "!");
		defaultOp.set(OpNeg, "-x");
		defaultOp.set(OpNegBits, "~");
	}
	
	static function typeName(t:Type):String
	{
		t = Context.follow(t, false);
		var type:BaseType;
		switch (t)
		{
			case TInst(t, params):
				type = t.get();
			
			case TEnum(t, params):
				type = t.get();
				
			default:
		}
		if (type == null)
		{
			trace(t);
			Context.error("unknown type name '" + t + "'", Context.currentPos());
		}
		return type.pack.join(".") + (type.pack.length > 0 ? "." : "") + type.name;
	}
	
	static function typeOf(e:Expr):Type
	{
		try 
		{
			return Context.typeof(e);
		}
		catch (e:Dynamic)
		{
			return null;
		}
	}

	#end
}

#if macro

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