--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_6918037c(arg0: s32)
	local check_motion_end: s32 = 0
	while true do
		vm.wait(1)
		check_motion_end = event.is_character_motion_finished(arg0) or check_motion_end
		if check_motion_end ~= 0 then
			break
		end
	end
end

return helper_6918037c
