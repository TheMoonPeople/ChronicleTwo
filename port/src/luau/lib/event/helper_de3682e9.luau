--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_31d563c9 = require("@lib/event/helper_31d563c9")
local helper_84d8fb65 = require("@lib/event/helper_84d8fb65")
local helper_9ced6ae4 = require("@lib/event/helper_9ced6ae4")
local helper_c2b3f540 = require("@lib/event/helper_c2b3f540")
local helper_de28248b = require("@lib/event/helper_de28248b")

--- Helper function.
local function helper_de3682e9()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var13: s32 = 0
	local var20: f32 = 0
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	helper_84d8fb65(var0, var1, 0)
	helper_9ced6ae4(0, -1, var1, var0, 0)
	helper_31d563c9(var1, -1, 0, 0)
	helper_9ced6ae4(0, -1, var1, var0, 0)
	helper_de28248b(var13, var20)
	helper_9ced6ae4(0, -1, var1, var13, 0)
	helper_c2b3f540(30)
	helper_c2b3f540(28)
	helper_c2b3f540(29)
end

return helper_de3682e9
