LoginViewPanel = LoginViewPanel or {}
local this = LoginViewPanel

function LoginViewPanel.Awake(obj)
	obj.transform.sizeDelta = Vector2.New(ScreenWidth, ScreenHeight)
	local img = obj.Find("Image").transform:GetComponent("Image")
	local imgBundle = resMgr:LoadAssetBundle('login_atlas'):LoadAsset("circle",typeof(UnityEngine.Sprite))
	img.sprite = imgBundle
end

function LoginViewPanel:initPanel(obj)
	self.startBtn = obj.Find("startBtn")
	obj.transform:GetComponent("LuaBehaviour"):AddClick(self.startBtn,function()
		print("======================")
	end)
end