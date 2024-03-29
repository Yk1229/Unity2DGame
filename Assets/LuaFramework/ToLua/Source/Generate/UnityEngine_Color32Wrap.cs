﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class UnityEngine_Color32Wrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(UnityEngine.Color32), null);
		L.RegFunction("Lerp", Lerp);
		L.RegFunction("LerpUnclamped", LerpUnclamped);
		L.RegFunction("ToString", ToString);
		L.RegFunction("New", _CreateUnityEngine_Color32);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("r", get_r, set_r);
		L.RegVar("g", get_g, set_g);
		L.RegVar("b", get_b, set_b);
		L.RegVar("a", get_a, set_a);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUnityEngine_Color32(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 4)
			{
				byte arg0 = (byte)LuaDLL.luaL_checknumber(L, 1);
				byte arg1 = (byte)LuaDLL.luaL_checknumber(L, 2);
				byte arg2 = (byte)LuaDLL.luaL_checknumber(L, 3);
				byte arg3 = (byte)LuaDLL.luaL_checknumber(L, 4);
				UnityEngine.Color32 obj = new UnityEngine.Color32(arg0, arg1, arg2, arg3);
				ToLua.PushValue(L, obj);
				return 1;
			}
			else if (count == 0)
			{
				UnityEngine.Color32 obj = new UnityEngine.Color32();
				ToLua.PushValue(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: UnityEngine.Color32.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Lerp(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			UnityEngine.Color32 arg0 = StackTraits<UnityEngine.Color32>.Check(L, 1);
			UnityEngine.Color32 arg1 = StackTraits<UnityEngine.Color32>.Check(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			UnityEngine.Color32 o = UnityEngine.Color32.Lerp(arg0, arg1, arg2);
			ToLua.PushValue(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LerpUnclamped(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			UnityEngine.Color32 arg0 = StackTraits<UnityEngine.Color32>.Check(L, 1);
			UnityEngine.Color32 arg1 = StackTraits<UnityEngine.Color32>.Check(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			UnityEngine.Color32 o = UnityEngine.Color32.LerpUnclamped(arg0, arg1, arg2);
			ToLua.PushValue(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToString(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1)
			{
				UnityEngine.Color32 obj = (UnityEngine.Color32)ToLua.CheckObject(L, 1, typeof(UnityEngine.Color32));
				string o = obj.ToString();
				LuaDLL.lua_pushstring(L, o);
				return 1;
			}
			else if (count == 2)
			{
				UnityEngine.Color32 obj = (UnityEngine.Color32)ToLua.CheckObject(L, 1, typeof(UnityEngine.Color32));
				string arg0 = ToLua.CheckString(L, 2);
				string o = obj.ToString(arg0);
				LuaDLL.lua_pushstring(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: UnityEngine.Color32.ToString");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_r(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Color32 obj = (UnityEngine.Color32)o;
			byte ret = obj.r;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index r on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_g(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Color32 obj = (UnityEngine.Color32)o;
			byte ret = obj.g;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index g on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_b(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Color32 obj = (UnityEngine.Color32)o;
			byte ret = obj.b;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index b on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_a(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Color32 obj = (UnityEngine.Color32)o;
			byte ret = obj.a;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index a on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_r(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Color32 obj = (UnityEngine.Color32)o;
			byte arg0 = (byte)LuaDLL.luaL_checknumber(L, 2);
			obj.r = arg0;
			ToLua.SetBack(L, 1, obj);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index r on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_g(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Color32 obj = (UnityEngine.Color32)o;
			byte arg0 = (byte)LuaDLL.luaL_checknumber(L, 2);
			obj.g = arg0;
			ToLua.SetBack(L, 1, obj);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index g on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_b(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Color32 obj = (UnityEngine.Color32)o;
			byte arg0 = (byte)LuaDLL.luaL_checknumber(L, 2);
			obj.b = arg0;
			ToLua.SetBack(L, 1, obj);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index b on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_a(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Color32 obj = (UnityEngine.Color32)o;
			byte arg0 = (byte)LuaDLL.luaL_checknumber(L, 2);
			obj.a = arg0;
			ToLua.SetBack(L, 1, obj);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index a on a nil value");
		}
	}
}

