LoginViewPanel = class("LoginViewPanel", BaseUI)

LoginViewPanel.widgetsData = {
	{name = "Image", component = Image},
	{name = "startBtn", component = Button, click = "onStartClick"}
}

function LoginViewPanel.Awake(obj)
	self = LoginViewPanel
	BaseUI.Ctor(self, obj)
	obj.transform.sizeDelta = Vector2.New(ScreenWidth, ScreenHeight)
	self:initPanel()
end

function LoginViewPanel:initPanel()
	Util.SetImage(self.widgets.Image, "login_atlas", "circle")
end

function LoginViewPanel:onStartClick(go)
	print("=========================")
end