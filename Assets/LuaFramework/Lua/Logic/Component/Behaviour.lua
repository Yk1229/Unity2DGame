Behaviour = class("Behaviour")

Behaviour.needBehaviour = true; -- 是否需要注册LuaBehaviour脚本，注册的话，具备Monobehaviour的update和按钮点击等功能，不注册的话，单纯的只是个lua脚本
Behaviour.widgetsData = {};		-- 预制体上的组件信息

--[[
Behaviour: 类MonoBehaviour写法，实质有LuaBehaviour驱动
gameObject：脚本挂载体，可以是预制体，可以是组件
gameObjectName：脚本在LuaBehaviour上显示的名字，默认显示类名，主要用于debug。
调用顺序：OnInitPos -> OnInit -> OnAwake -> OnEnable -> Start -> Update -> OnDestroy
]]
function Behaviour:Ctor(gameObject, gameObjectName)
	assert(nil ~= gameObject, "can not create a 'nil' target")

	self.gameObject = gameObject;

	self.transform = self.gameObject.transform;

	self:M_InitPos();

	self.widgets = {};

	if self.needBehaviour then
		self.behaviour = self.gameObject:AddComponent(typeof(LuaFramework.LuaBehaviour))

		self.behaviour:InitBehaviour(
		Handler(self, self.Start),
		Handler(self, self.Enable),
		Handler(self, self.Disable),
		Handler(self, self.Destroy));

		if gameObjectName == nil then
			self.behaviour:SetName(self.__cname);	--classname
		else
			self.behaviour:SetName(gameObjectName);
		end
	end

	if nil ~= self.widgetsData then
		self:RegisterWidgets(self.widgetsData, self.gameObject, self.widgets);	--注册添加组件
	end

	self:M_Init();

	if self.needBehaviour then
		self:M_Awake();
		if self.gameObject.activeInHierarchy then
			self:Enable();
		end
	end;
end

function Behaviour:M_InitPos()
	if nil ~= self.OnInitPos then
		self:OnInitPos();
	end
end

function Behaviour:RegisterWidgets(datas, root, widgets)	--注册组件，添加到widgets列表中
	widgets = widgets or root;
	local function RegisterWidget(data, widget)
		if widget then
			widgets[data.name] = widget;
			if nil ~= widget then
				if nil ~= data.component then
					widget = widget.gameObject:GetComponent(typeof(data.component));
					widgets[data.name] = widget;
				elseif nil ~= data.components then
					for key,component in pairs(data.components) do
						local childWidget = widget.gameObject:GetComponent(typeof(component));
						widgets[data.name][key] = childWidget;
					end
				elseif nil ~= data.class then
					widgets[data.name] = data.class.New(widget);
					widget[data.class.__cname] = widgets[data.name];
				else
					widget = widget.gameObject;			--默认添加为gameObject类型
					widgets[data.name] = widget.gameObject;
				end
			end
			self:M_RegisterWidgetEvent(data, widget.gameObject);	--注册click/press/等事件
		end
	end

	for __, data in ipairs(datas) do
		data.name = data.name or data[1];

		if data.len and data.len > 0 then
			local array = {};
			local tmpDatas = {};
			for i = 1, data.len do
				local tmpData = {};
				simpleCopy(tmpData, data);
				tmpData.len = nil;
				tmpData.name = tmpData.name..i;
				table.insert(tmpDatas, tmpData);
			end
			self:RegisterWidgets(tmpDatas, root, array);
			widgets[data.name.."s"] = {};

			for i = 1, data.len do
				widgets[data.name.."s"][i] = array[data.name..i];
			end
		else
			assert(nil ~= data.name, "cannot find the name property! make sure your type");
			if "self" == data.name then
				RegisterWidget(data, self.gameObject);
			elseif data.url then
				RegisterWidget(data, Util.GetChildByUrl(root.gameObject, data.url));
			else
				RegisterWidget(data, Util.GetChildGameObject(root.gameObject, data.name, true));
			end
		end
	end
end

function Behaviour:M_RegisterWidgetEvent(data, widget)
	if not self.behaviour then return end

	local click = data.click;
	if click and self[data.click] then
		self.behaviour:AddClick(widget, function(go)
			local uiButton = go.gameObject:GetComponent(typeof(UIButton))
			if uiButton == nil or uiButton.type ~= UIButton.ButtonType.Skill then
				MusicUtil.PlayAudio(MusicConfig.JmClick)
			end

			self[click](self, go, data.args);
		end)
	end

	local press = data.press;
	if press and self[data.press] then
		self.behaviour:AddPress(widget, function(go, state)
			self[press](self, go, state);
		end)
	end

	local valueChange = data.valueChange;
	if valueChange and self[valueChange] then
		self.behaviour:AddValueChange(widget, typeof(data.component), function (go, Bool)
			self[valueChange](self, go, Bool)
		end)
	end

	local beginDrag = data.beginDrag
	if beginDrag and self[data.beginDrag] then
		self.behaviour:AddBeginDrag(widget, function(go)
			self[beginDrag](self, go);
		end)
	end

	local endDrag = data.endDrag
	if endDrag and self[data.endDrag] then
		self.behaviour:AddEndDrag(widget, function(go)
			self[endDrag](self, go);
		end)
	end
end

function Behaviour:M_Awake()
	if nil ~= self.OnAwake then
		self:OnAwake();
	end
end

function Behaviour:Start()
	if nil ~= self.OnStart then
		self:OnStart();
	end
end

function Behaviour:Enable()
	if nil ~= self.OnEnable then
		self:OnEnable();
	end

	if nil ~= self.OnFixUpdate then
		FixedUpdateBeat:Add(self.OnFixUpdate, self);
	end

	if nil ~= self.OnUpdate then
		UpdateBeat:Add(self.OnUpdate, self);
	end

	if nil ~= self.OnLateUpdate then
		LateUpdateBeat:Add(self.OnLateUpdate, self);
	end
end

function Behaviour:Disable()
	if nil ~= self.OnFixUpdate then
		FixedUpdateBeat:Remove(self.OnFixUpdate, self);
	end

	if nil ~= self.OnUpdate then
		UpdateBeat:Remove(self.OnUpdate, self)
	end

	if nil ~= self.OnLateUpdate then
		LateUpdateBeat:Remove(self.OnLateUpdate, self);
	end

	if nil ~= self.cors then
		for k, v in pairs(self.cors) do
			coroutine.stop(v);
		end
	end
	self.cors = nil;

	if nil ~= self.OnDisable then
		self:OnDisable();
	end
end

function Behaviour:Destroy()
	--print(tostring(self))
	self.destroyed = true
	if nil ~= self.OnDestroy then
		self:OnDestroy();
	end
	self.transform = nil
	self.gameObject = nil
	self.widgets = nil
	self.behaviour = nil
	self = nil;
end

function Behaviour:M_Init()
	if nil ~= self.OnInit then
		self:OnInit();
	end
end

function Behaviour:StartCoroutine(name, f, ...)
	assert(nil ~= name and nil ~= f, "name or function can not be nil");
	assert("string" == type(name), "name must be string type")

	if nil == self.cors then
		self.cors = {};
	elseif nil ~= self.cors[name] then
		self:StopCoroutine(name);
	end
	local handler = Handler(self, f);
	local co = coroutine.start(handler, ...);
	self.cors[name] = co;
end

function Behaviour:YieldSeconds(s)
	coroutine.wait(s);
end

function Behaviour:YieldWWW(www)
	coroutine.www(www);
end

function Behaviour:YieldFrames(frame)
	coroutine.step(frame);
end

function Behaviour:StopCoroutine(name)
	if nil ~= self.cors then
		local co = self.cors[name];

		if nil ~= co then
			coroutine.stop(co);
			self.cors[name] = nil;
		end
	end
end