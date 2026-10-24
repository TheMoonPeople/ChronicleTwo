--!strict
-- Shared event helper used by 100 scripts, translated by tools/luau/stb2luau.

local helper_76f23193 = require("@lib/event/helper_76f23193")

--- Helper function.
local function helper_ab0a8186(arg0: s32, arg1: f32, arg2: s32, arg3: s32)
	if arg3 ~= 0 then
		helper_76f23193(arg0, arg1)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	if arg2 ~= 0 then
		event.SetCrossfade(10)
	end
end

return helper_ab0a8186
