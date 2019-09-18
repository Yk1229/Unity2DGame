LoginViewPanel = LoginViewPanel or {}
local this = LoginViewPanel

function LoginViewPanel.Awake(obj)
	obj.transform.sizeDelta = Vector2.New(ScreenWidth, ScreenHeight)
	local img = obj.Find("Image").transform:GetComponent("Image")
	local imgBundle = resMgr:LoadAssetBundle('login_atlas'):LoadAsset("circle",typeof(UnityEngine.Sprite))
	img.sprite = imgBundle
end