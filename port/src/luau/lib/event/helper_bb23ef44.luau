--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local helper_ed4529cf = require("@lib/event/helper_ed4529cf")
local helper_fae95659 = require("@lib/event/helper_fae95659")

--- Helper function.
local function helper_bb23ef44()
	local var0: s32 = 0
	local argc: s32 = 0
	local flag: s32 = 0
	event.initialize_event()
	helper_fae95659()
	var0 = event.get_save_counter(3) or var0
	print("cnt=", var0, "-------------------------------------\n")
	if var0 >= 8 then
		event.attach_object_handle_to_map_part_3(0, "p05_s0501", "s050111-m0")
		event.set_object_handle_visible(0, 1)
		event.set_object_handle_position(0, -2274.43, 37.38, 712.87)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(0, "p05_s0501", "s050102-a")
		event.set_object_handle_position(0, -2274.43, 37.38, 712.87)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(0, "p05_s0501", "s050102-c")
		event.set_object_handle_position(0, -2274.43, 37.38, 712.87)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_function_point_enabled("", "next_floor", 1)
	end
	if var0 > 1 and var0 < 7 then
		print("esaget-------------\n")
		event.set_function_point_enabled("", "itemget_mimi", 1)
	end
	flag = event.get_save_flag(230) or flag
	if flag ~= 0 and var0 < 5 then
		argc = event.get_item_count(291) or argc
		if argc <= 0 then
			print("apple-------------\n")
			event.set_function_point_enabled("", "itemget_paplle", 1)
			event.set_character_active(1, 13)
			event.set_character_active(1, 15)
			event.set_character_active(1, 16)
			event.set_character_active(1, 17)
		else
			event.set_character_active(0, 13)
			event.set_character_active(0, 15)
			event.set_character_active(0, 16)
			event.set_character_active(0, 17)
		end
	end
	if var0 <= 2 then
		argc = event.get_item_count(302) or argc
		if argc <= 0 then
			event.set_function_point_enabled("", "fc_e220", 1)
		end
	end
	flag = event.get_save_flag(230) or flag
	if flag == 0 then
		event.set_function_point_enabled("", "fc_e230", 1)
		return
	end
	if var0 == 3 then
		event.set_function_point_enabled("", "fc_e235", 1)
		return
	end
	if var0 == 5 then
		print("haguhagu on--------------\n")
		event.set_function_point_enabled("", "item_e245", 1)
		return
	end
	if var0 == 6 then
		event.set_function_point_enabled("", "fc_e247", 1)
		helper_ed4529cf()
		return
	end
	if var0 == 7 then
		flag = event.get_save_flag(250) or flag
		if flag == 1 then
			event.set_function_point_enabled("", "fc_e253", 1)
		end
	end
end

return helper_bb23ef44
