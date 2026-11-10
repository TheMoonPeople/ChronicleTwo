--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_c2b5f8fb = require("@lib/event/helper_c2b5f8fb")

--- Helper function.
local function helper_81af0537(arg0: s32, arg1: f32, arg2: f32)
	local var3: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	do
		local out1, _, out3 = event.get_character_position(arg0)
		var3 = out1 or var3
		var5 = out3 or var5
	end
	var6 = event.get_look_angle(arg1 - var3, arg2 - var5) or var6
	helper_c2b5f8fb(arg0, var6)
end

return helper_81af0537
