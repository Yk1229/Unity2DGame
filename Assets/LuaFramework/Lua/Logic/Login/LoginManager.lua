LoginManager = LoginManager or {}
local this = LoginManager

function LoginManager.init()
	require("Logic/Login/LoginViewPanel")
	panelMgr:CreatePanel("LoginView")
end