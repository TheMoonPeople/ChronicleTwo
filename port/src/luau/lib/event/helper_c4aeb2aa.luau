--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_530db854 = require("@lib/event/helper_530db854")
local helper_684f356d = require("@lib/event/helper_684f356d")

--- Helper function.
local function helper_c4aeb2aa()
	local var0: s32 = 0
	local var1: s32 = 0
	print("IN go_shop_up()\n")
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	helper_684f356d(var1, -1, 0, 0)
	helper_530db854(15)
	helper_530db854(1)
	helper_530db854(6)
	helper_530db854(0)
	helper_530db854(4)
	helper_530db854(31)
	helper_530db854(35)
	helper_530db854(36)
	helper_530db854(37)
end

return helper_c4aeb2aa
