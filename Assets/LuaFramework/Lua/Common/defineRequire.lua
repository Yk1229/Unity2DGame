LuaHelper = LuaFramework.LuaHelper
Util = LuaFramework.Util
panelMgr = LuaHelper.GetPanelManager()
resMgr = LuaHelper.GetResManager()
Event = require "events"

SceneManager = UnityEngine.SceneManagement.SceneManager
ScreenWidth = UnityEngine.Screen.width
ScreenHeight = UnityEngine.Screen.height
Button = UnityEngine.UI.Button
Image = UnityEngine.UI.Image

require "Common/functions"
require "Logic/Component/BaseUI"
require "Logic/Login/LoginManager"