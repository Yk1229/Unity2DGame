LoginManager = LoginManager or {}
local this = LoginManager

function LoginManager.init()
	require("Logic/Login/LoginViewPanel")
	panelMgr:CreatePanel('LoginView', this.OnCreate)
end

function LoginManager.OnCreate(obj)
	LoginViewPanel:initPanel(obj)
end