LoginManager = LoginManager or {}
local this = LoginManager

function LoginManager.init()
	require("Logic/LoginViewPanel")
	panelMgr:CreatePanel('LoginView', this.OnCreate)
end

function LoginManager.OnCreate(obj)
	-- body
end