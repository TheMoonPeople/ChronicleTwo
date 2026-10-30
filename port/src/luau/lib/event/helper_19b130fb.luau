--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_19b130fb()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.get_save_flag(202) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.set_character_active(1, 122)
		event.set_character_active(1, 123)
	else
		event.set_character_active(0, 122)
		event.set_character_active(0, 123)
	end
end

return helper_19b130fb
