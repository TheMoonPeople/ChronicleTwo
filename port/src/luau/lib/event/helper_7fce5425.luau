--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_62f923e1 = require("@lib/event/helper_62f923e1")

--- Helper function.
local function helper_7fce5425(arg0: s32)
	event.SetMesPreset(1, 4)
	helper_125385ee(1, 4)
	if arg0 == 0 then
		return helper_62f923e1(1, 1000 + arg0, 7, 0, 0, 2, 0)
	end
	if arg0 == 1 then
		return helper_62f923e1(1, 1000 + arg0, 7, 0, 0, 3, 0)
	end
	return 0
end

return helper_7fce5425
