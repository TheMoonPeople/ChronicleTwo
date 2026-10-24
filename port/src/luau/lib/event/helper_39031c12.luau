--!strict
-- Shared event helper used by 141 scripts, translated by tools/luau/stb2luau.

local helper_cfca3481 = require("@lib/event/helper_cfca3481")

--- Helper function.
local function helper_39031c12(arg0: any, arg1: f32, arg2: any, arg3: any)
	if arg3 ~= 0 then
		helper_cfca3481(arg0, arg1)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	if arg2 ~= 0 then
		event.SetCrossfade(10)
	end
end

return helper_39031c12
