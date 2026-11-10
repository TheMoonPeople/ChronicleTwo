--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_bb794e6a(se_id: s32)
	local count: s32 = 0
	count = event.get_sphida_par() or count
	event.set_sphida_par(count)
	if count <= 0 then
		event.delete_character(8)
		event.delete_character(9)
		event.delete_character(10)
		event.delete_character(11)
		event.set_sphida_playing(0)
		if se_id ~= -1 then
			event.play_sound_effect(se_id, 19)
		end
	end
end

return helper_bb794e6a
