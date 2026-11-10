--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_a57b0158()
	local flag: s32 = 0
	local debug_flag: s32 = 0
	flag = event.get_save_flag(306) or flag
	if flag ~= 1 then
		debug_flag = event.get_debug_flag() or debug_flag
		if debug_flag == 0 then
			event.set_character_active(0, 120)
			event.set_character_active(0, 121)
		end
	end
	event.run_georama_command(2)
end

return helper_a57b0158
