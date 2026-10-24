--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")

--- Helper function.
local function helper_140e35ad(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"ファブリースの民は、\n自分より秀でた人でないと、\nたのみを聞く事はありません。"
	)
	helper_907fd9a8(arg0, -1, 0, 0)
end

return helper_140e35ad
