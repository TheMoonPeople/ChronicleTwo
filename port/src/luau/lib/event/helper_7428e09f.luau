--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_24bece14 = require("@lib/event/helper_24bece14")

--- Helper function.
local function helper_7428e09f()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	helper_24bece14()
	event.set_character_active(1, 24)
	event.set_function_point_enabled("", "fc_event_e108c", 0)
	var0 = event.get_save_data_value(0) or var0
	flag = event.get_save_flag(7) or flag
	if var0 == 3 and flag == 0 then
		print("LOAD_STEAVE------------------\n")
		event.load_character(4, "event/e100/e105/e105_steve.gltf", "info", 25)
		event.set_character_active(1, 25)
		event.load_character(4, "event/e100/e105/back01.gltf", "info", 26)
		event.set_character_active(0, 26)
		flag_2 = event.get_save_flag(107) or flag_2
		if flag == 0 and flag_2 == 1 then
			print("e107 ikou--------------------\n")
			event.set_character_active(0, 24)
			event.set_character_active(1, 25)
			event.set_character_position(25, -116.62, -12.11, -221.76)
			event.set_character_rotation(25, 0.0, 0.16, 0.0)
			event.set_function_point_enabled("", "fc_event_e108c", 1)
		else
			event.set_character_position(25, 62.85, 11.43, -176.07)
			event.set_character_rotation(25, 0.0, -0.72, 0.0)
		end
		flag_3 = event.get_save_flag(20) or flag_3
		if flag_3 ~= 0 then
			event.set_character_active(1, 26)
			event.attach_character_to_frame(25, "back", 26)
		end
	end
end

return helper_7428e09f
