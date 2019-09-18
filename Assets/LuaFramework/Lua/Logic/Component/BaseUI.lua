BaseUI = class("BaseUI")

BaseUI.widgetsData = {}

function BaseUI:Ctor(gameObject)
	self.gameObject = gameObject
	self.widgets = {}
	self.behaviour = gameObject.transform:GetComponent("LuaBehaviour")
	if self.widgetsData then
		self:RegisterWidgets(self.widgetsData, self.gameObject, self.widgets)
	end
	return self
end

function BaseUI:RegisterWidgets(datas, root, widgets)	--注册组件，添加到widgets列表中
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
				RegisterWidget(data, Util.Child(root.gameObject, data.name));
			end
		end
	end
end

function BaseUI:M_RegisterWidgetEvent(data, widget)
	if not self.behaviour then return end

	local click = data.click;
	if click and self[data.click] then
		self.behaviour:AddClick(widget, function(go)
			-- local uiButton = go.gameObject:GetComponent(typeof(UIButton))
			-- if uiButton == nil or uiButton.type ~= UIButton.ButtonType.Skill then
			-- 	MusicUtil.PlayAudio(MusicConfig.JmClick)
			-- end

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