--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_c2ca38b7(se_id: s32)
	local count: s32 = 0
	count = event.get_sphida_par() or count
	count = vm.i32(count - 1)
	event.set_sphida_par(count)
	if count <= 0 then
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		if se_id ~= -1 then
			event.play_sound_effect(se_id, 19)
		end
	end
end

return helper_c2ca38b7
