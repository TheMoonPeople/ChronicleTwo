--!strict
-- Shared effect helper used by 37 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_8b333653()
	local check_motion_end: s32 = 0
	while true do
		check_motion_end = effect.is_effect_character_motion_finished() or check_motion_end
		if check_motion_end ~= 0 then
			break
		else
			vm.wait()
		end
	end
end

return helper_8b333653
