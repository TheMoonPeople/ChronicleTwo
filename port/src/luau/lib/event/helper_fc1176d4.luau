--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_ff3b9cef = require("@lib/event/helper_ff3b9cef")

--- Helper function.
local function helper_fc1176d4(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: s32 = 0
	var4 = event.JoinPartyMember(1) or var4
	if var4 == 1 then
		helper_ff3b9cef(arg0, arg1, arg2, arg3, 1, 1)
	else
		helper_ff3b9cef(arg0, arg1, arg2, arg3, 1, 0)
	end
	event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
end

return helper_fc1176d4
