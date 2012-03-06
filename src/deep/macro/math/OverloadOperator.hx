package deep.macro.math;

#if macro
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;
#end

import deep.math.ComplexMath;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

class OverloadOperator 
{
	#if macro
	public static function build():Array<Field>
	{
		addMath(getDataType(Context.getLocalClass().get()));
		
		var fields = Context.getBuildFields();
		var nfields = new Array<Field>();
		for (f in fields)
		{
			var ignore = false;
			for (m in f.meta) 
			{
				if (m.name == "noOverload")
				{
					ignore = true;
					break;
				}
			}
			if (ignore) continue;
			
			switch (f.kind)
			{
				case FVar(t, e):
					if (e != null)
					{
						f.kind = FieldType.FVar(t, parseExpr(e, []));
						nfields.push(f);
					}
				case FProp(get, set, t, e):
					if (e != null)
					{
						f.kind = FProp(get, set, t, parseExpr(e, []));
						nfields.push(f);
					}
				
				case FFun(fn):
					if (fn.expr != null)
					{
						fn.expr = parseExpr(fn.expr, []);
						nfields.push(f);
					}
				default:
			}
		}
		
		return nfields;
	}
	
	static function getDataType(cls:ClassType):haxe.macro.Type
	{
		for (i in cls.interfaces)
		{
			if (i.t.get().name == "IOverloadOperator")
			return i.params[0];
		}
		
		return Context.error("Must implement IOverloadOperator.", Context.currentPos());
	}	

	static public function addMath(type)
	{
		var pos = Context.currentPos();
		var typeExp:Expr;
		if (math == null) math = new Hash<Expr>();
		switch (type)
		{
			case TInst(t, params):
				var ct = t.get();
				
				for (p in ct.pack)
				{
					if (typeExp == null) typeExp = { expr:EConst(CIdent(p)), pos:pos };
					else typeExp = { expr:EField(typeExp, p), pos:pos };
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
						var ts = new Array<String>();
						switch (Context.follow(method.type))
						{
							case TFun(args, ret):
								for (a in args) ts.push(typeName(a.t));
							default:
						}
						var key = o + ":";
						for (t in ts) key += t + "->";
						if (ts.length > 0) key = key.substr(0, key.length - 2);
						
						var value = { expr:EField(typeExp, method.name), pos:pos };
						//trace(key + "    " + value);
						if (math.exists(key)) 
							Context.warning("Overriding existing method " + key, pos);
						math.set(key, value);
						
						if (com && ts.length == 2 && ts[0] != ts[1])
						{
							key = "C:" + o + ":";
							ts.push(ts.shift());
							for (t in ts) key += t + "->";
							if (ts.length > 0) key = key.substr(0, key.length - 2);
							//trace(key + "    " + value);
							if (math.exists(key))
								Context.warning("Overriding existing method " + key, pos);
							math.set(key, value);
						}
					}
				}
			default:
		}
		if (typeExp == null) Context.error("Can't parse math", pos);
		
		return {expr:EConst(CIdent("null")), pos:pos};
	}
	

	static function parseExpr(e:Expr, ctx:IdentDef):Expr
	{
		//trace(e);
		if (e == null) return e;
		var pos = e.pos;
		switch (e.expr)
		{
			case EConst(c):
				return e;
				
			case EUnop(op, postFix, e1):
				var o = defaultOp.get(op);
				if (postFix) o = o.substr(-1) + o.substr(0, o.length - 1);
				e1 = parseExpr(e1, ctx);
				var t1 = typeOf(e1, ctx);
				if (t1 == null) Context.error("can't recognize type (EUnop)", e1.pos);
				
				var key = o + ":" + typeName(t1);
				if (math.exists(key))
				{
					var call = { expr:ECall( math.get(key), [e1]), pos:pos };
					if (canAssign(e1))
						return { expr:EBinop(OpAssign, e1, call ), pos:pos };
					else
						return call;
				}
				
				return e;
				
			case EBinop(op, e1, e2):
				var assign = false;
				switch (op)
				{
					case OpAssign:
						return { expr:EBinop(OpAssign, parseExpr(e1, ctx), parseExpr(e2, ctx)), pos:pos };
						
					case OpAssignOp(op2):
						assign = true;
						op = op2;
					default:
				}
				var o = defaultOp.get(op) + (assign ? "=" : "");
				e1 = parseExpr(e1, ctx);
				var t1 = typeOf(e1, ctx);
				if (t1 == null) Context.error("can't recognize type (EBinop,1)", e1.pos);
				
				e2 = parseExpr(e2, ctx);
				
				var t2 = typeOf(e2, ctx);
				if (t2 == null) Context.error("can't recognize type (EBinop,2)", e2.pos);

				var key = o + ":" + typeName(t1) + "->" + typeName(t2);
				if (math.exists(key))
				{
					
					var call = { expr:ECall( math.get(key), [e1, e2]), pos:pos };
					if (assign && canAssign(e1))
						return { expr:EBinop(OpAssign, e1, call), pos:pos };
					else
						return call;
				}
				else
				{
					key = "C:" + key;
					if (math.exists(key))
					{
						var call = { expr:ECall( math.get(key), [e2, e1]), pos:pos };
						if (assign && canAssign(e1))
							return { expr:EBinop(OpAssign, e1, call), pos:pos };
						else
							return call;
					}
				}
				
				return e;
				
			case EParenthesis(e):
				return { expr:EParenthesis(parseExpr(e, ctx)), pos:pos };
				
			case EBlock(exprs):
				var nexprs = new Array<Expr>();
				var innerCtx = [];
				for (i in exprs)
					nexprs.push(parseExpr(i, innerCtx));
				return { expr:EBlock(nexprs), pos:pos };
				
			case EArray(e1, e2):
				return { expr:EArray(parseExpr(e1, ctx), parseExpr(e2, ctx)), pos:pos };
				
			case EArrayDecl(values):
				var nvalues = new Array<Expr>();
				for (i in values)
					nvalues.push(parseExpr(i, ctx));
				return { expr:EArrayDecl(nvalues), pos:pos };
				
			case EVars(vars):
				for (i in vars)
				{
					ctx.push(i);
					i.expr = parseExpr(i.expr, ctx);
				}
				return { expr:EVars(vars), pos:pos };
				
			case EUntyped(e):
				return { expr:EUntyped(parseExpr(e, ctx)), pos:pos };
				
			case ECall(e, params):
				var nparams = new Array<Expr>();
				for (i in params)
					nparams.push(parseExpr(i, ctx));
				return { expr:ECall(e, nparams), pos:pos };
				
			case ENew(t, params):
				var nparams = new Array<Expr>();
				for (i in params)
					nparams.push(parseExpr(i, ctx));
				return { expr:ENew(t, nparams), pos:pos };
				
			case EField(e, field):
				return { expr:EField(parseExpr(e, ctx), field), pos:pos };
				
			case EType(e, field):
				return { expr:EType(parseExpr(e, ctx), field), pos:pos };
				
			case EObjectDecl(fields):
				for (i in fields) i.expr = parseExpr(i.expr, ctx);
				return { expr:EObjectDecl(fields), pos:pos };
				
			case EIf(econd, eif, eelse):
				return { expr:EIf(parseExpr(econd, ctx), parseExpr(eif, ctx), parseExpr(eelse, ctx)), pos:pos };
				
			case ETernary(econd, eif, eelse):
				return { expr:ETernary(parseExpr(econd, ctx), parseExpr(eif, ctx), parseExpr(eelse, ctx)), pos:pos };
				
			case EFor(it, expr):
				return { expr:EFor(parseExpr(it, ctx), parseExpr(expr, ctx)), pos:pos };
				
			case EWhile(econd, e, normalWhile):
				return { expr:EWhile(parseExpr(econd, ctx), parseExpr(e, ctx), normalWhile), pos:pos };
				
			case EIn(e1, e2):
				return { expr:EIn(parseExpr(e1, ctx), parseExpr(e2, ctx)), pos:pos };
				
			case ESwitch(e, cases, edef):
				if (edef != null) edef = parseExpr(edef, ctx);
				for (c in cases)
				{
					c.expr = parseExpr(c.expr, ctx);
					var nvalues = new Array<Expr>();
					for (i in c.values) nvalues.push(parseExpr(i, ctx));
					c.values = nvalues;
				}
				return { expr:ESwitch(parseExpr(e, ctx), cases, edef), pos:pos };
				
			case ETry(e, catches):
				for (c in catches) c.expr = parseExpr(c.expr, ctx);
				return { expr:ETry(parseExpr(e, ctx), catches), pos:pos };
				
			case EReturn(e):
				return { expr:EReturn(e != null ? parseExpr(e, ctx) : e), pos:pos };
				
			case EThrow(e):
				return { expr:EThrow(parseExpr(e, ctx)), pos:pos };
				
			case ECast(e, t):
				return { expr:ECast(parseExpr(e, ctx), t), pos:pos };
				
			default: return e;
		}
		return e;
	}
	
	static var math:Hash<Expr>;
	
	static var defaultOp:Map < Dynamic, String > = {
		defaultOp = new Map<Dynamic, String>();
		// http://haxe.org/api/haxe/macro/binop
		//defaultOp.set(OpAssign, "=");
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
		defaultOp;
	}
	
	static function canAssign(e:Expr):Bool
	{
		switch (e.expr)
		{
			case EConst(ec):
				switch (ec)
				{
					case CIdent(cid), CType(cid): return true;
					default:
				}
			case EArray(e1, e2):
				return true;
			case EField(e, field):
				return true;
			default:
		}
		return false;
	}
	
	static function typeName(t:Type):String
	{
		t = Context.follow(t);
		var type:BaseType;
		switch (t)
		{
			case TMono(t2):
				if (t2 != null) t = t2.get();
				
			case TFun(args, ret):
				t = ret;
				
			case TDynamic(t2):
				t = t2;
				
			default:
		}
		
		switch (t)
		{		
			case TInst(t, params):
				type = t.get();
			
			case TEnum(t, params):
				type = t.get();
				
			case TType(t, params):
				type = t.get();
				
			default:
		}
		if (type == null)
		{
			Context.error("unknown type name '" + t + "'", Context.currentPos());
		}
		return type.pack.join(".") + (type.pack.length > 0 ? "." : "") + type.name;
	}
	
	static function typeOf(e:Expr, ctx:IdentDef):Type
	{
		var t = Context.typeof({pos:e.pos, expr:EBlock([{pos:e.pos, expr:EVars(ctx)}, e])});
		return Context.follow(t);
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

typedef IdentDef = Array<{ name : String, type : Null<ComplexType>, expr : Null<Expr> }>; 

#end