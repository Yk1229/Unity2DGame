
--输出日志--
function log(str)
	Util.Log(str);
end

--错误日志--
function logError(str) 
	Util.LogError(str);
end

--警告日志--
function logWarn(str) 
	Util.LogWarning(str);
end

--查找对象--
function find(str)
	return GameObject.Find(str);
end

function destroy(obj)
	GameObject.Destroy(obj);
end

function newObject(prefab)
	return GameObject.Instantiate(prefab);
end

--创建面板--
function createPanel(name)
	PanelManager:CreatePanel(name);
end

function child(str)
	return transform:FindChild(str);
end

function subGet(childNode, typeName)		
	return child(childNode):GetComponent(typeName);
end

function findPanel(str) 
	local obj = find(str);
	if obj == nil then
		error(str.." is null");
		return nil;
	end
	return obj:GetComponent("BaseLua");
end


---------------------------------------------------------------------------------

local _setmetatableindex
_setmetatableindex = function(t, index)
	if type(t) == "userdata" then
		local peer = tolua.getpeer(t)
		if not peer then
			peer = {}
			tolua.setpeer(t, peer)
		end
		_setmetatableindex(peer, index)
	else
		local mt = getmetatable(t)
		if not mt then mt = {} end
		if not mt.__index then
			mt.__index = index
			setmetatable(t, mt)
		elseif mt.__index ~= index then
			_setmetatableindex(mt, index)
		end
	end
end

function class(classname, ...)
	local cls = {__cname = classname}

	local supers = {...}
	for _, super in ipairs(supers) do
		local superType = type(super)
		assert(superType == "nil" or superType == "table" or superType == "function",
		string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
		tostring(classname), tostring(superType)))

		if superType == "function" then
			assert(cls.__create == nil,
			string.format("class() - create class \"%s\" with more than one creating function",
			classname));
			-- if super is function, set it to __create
			cls.__create = super
		elseif superType == "table" then
			if super[".isclass"] then
				-- super is native class
				assert(cls.__create == nil,
				string.format("class() - create class \"%s\" with more than one creating function or native class",
				classname));
				cls.__create = function() return super:create() end
			else
				-- super is pure lua class
				cls.__supers = cls.__supers or {}
				cls.__supers[#cls.__supers + 1] = super
				if not cls.super then
					-- set first super pure lua class as class.super
					cls.super = super
				end
			end
		else
			error(string.format("class() - create class \"%s\" with invalid super type",
			classname), 0)
		end
	end

	cls.__index = cls
	if not cls.__supers or #cls.__supers == 1 then
		setmetatable(cls, {__index = cls.super})
	else
		setmetatable(cls, {__index = function(_, key)
			local supers = cls.__supers
			for i = 1, #supers do
				local super = supers[i]
				if super[key] then return super[key] end
			end
		end})
	end

	if not cls.Ctor then
		-- add default constructor
		cls.Ctor = function() end
	end
	cls.New = function(...)
		local instance
		if cls.__create then
			instance = cls.__create(...)
		else
			instance = {}
		end
		_setmetatableindex(instance, cls)
		instance.class = cls
		instance:Ctor(...)
		return instance
	end
	cls.Create = function(_, ...)
		return cls.New(...)
	end

	return cls
end

function Len(t)
    if t == nil then
        return -1
    end

    local len = 0
    for k, v in pairs(t) do
        len = len + 1
    end
    return len
end

function TableToString (lua_table, indent)
    if lua_table == nil then
        return "nil"
    end

    local result = "";

    if type(lua_table) == "string" then
        result = result .. lua_table
    else
        indent = indent or 1
        for k, v in pairs(lua_table) do
            if type(k) == "string" then
                k = string.format("%q", k)
            end
            local szSuffix = ""
            if type(v) == "table" then
                szSuffix = "{"
            end
            local szPrefix = string.rep("    ", indent)
            local formatting = szPrefix .. "[" .. k .. "]" .. " = " .. szSuffix
            if type(v) == "table" then
                result = result .. formatting .. "\n";
                result = result .. TableToString(v, indent + 1);
                result = result .. szPrefix.."}," .. "\n";
            else
                local szValue = ""
                if type(v) == "string" then
                    szValue = string.format("%q", v)
                else
                    szValue = tostring(v)
                end
                result = result .. formatting .. szValue .. "," .. "\n";
            end
        end
    end

    return result;
end