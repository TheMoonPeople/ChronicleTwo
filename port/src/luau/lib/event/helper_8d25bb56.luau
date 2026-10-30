--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_8d25bb56()
	local argc: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.set_character_active(8)
	event.set_character_position(8, 2260.0, 0.0, 2233.0)
	event.set_character_rotation(8, 0.0, 3.14, 0.0)
	event.attach_object_handle_to_character(31, 8)
	event.set_object_handle_frame_visible(31, "R_yaiba", 0)
	event.set_object_handle_frame_visible(31, "obj11", 0)
	event.set_object_handle_frame_visible(31, "L_yaiba", 0)
	event.set_object_handle_frame_visible(31, "obj4", 0)
	event.set_character_near_fade_distance(8, 15.0)
	event.set_character_active(9)
	event.set_character_position(9, 1522.37, 4.0, 2978.08)
	event.set_character_rotation(9, 0.0, 1.94, 0.0)
	event.set_character_near_fade_distance(9, 15.0)
	event.set_character_active(10)
	event.set_character_position(10, 2100.0, 0.0, 3200.0)
	event.set_character_rotation(10, 0.0, 3.14, 0.0)
	event.set_character_near_fade_distance(10, 15.0)
	event.set_character_active(11)
	event.set_character_position(11, 2713.25, 4.0, 2224.2)
	event.set_character_rotation(11, 0.0, -0.34, 0.0)
	event.set_character_near_fade_distance(11, 15.0)
	event.set_character_active(12)
	event.set_character_position(12, 2575.78, 4.0, 2107.88)
	event.set_character_rotation(12, 0.0, -0.34, 0.0)
	event.set_character_motion(12, "ゆれて飛ぶ", 5)
	event.set_character_near_fade_distance(12, 15.0)
	argc = event.get_owned_item_count(353) or argc
	flag = event.get_save_flag(2) or flag
	flag_2 = event.get_save_flag(3) or flag_2
	if flag == 1 and flag_2 == 1 and argc >= 1 then
		event.attach_object_handle_to_character(31, 12)
		event.set_object_handle_frame_visible(31, "himonet", 0)
		event.set_object_handle_frame_visible(31, "f2--A01C0S1", 0)
	end
	event.set_character_active(13)
	event.set_character_position(13, 1883.89, 0.0, 3101.53)
	event.set_character_rotation(13, 0.0, -0.58, 0.0)
	event.set_character_motion(13, "立ち", 4)
	event.set_character_near_fade_distance(13, 15.0)
	event.set_character_active(14)
	event.set_character_position(14, 3067.0, 4.0, 2354.0)
	event.set_character_rotation(14, 0.0, -0.13, 0.0)
	event.set_character_motion(14, "立ち", 4)
	event.set_character_near_fade_distance(14, 15.0)
	event.set_character_active(15)
	event.set_character_position(15, 2415.5, 4.0, 2015.94)
	event.set_character_rotation(15, 0.0, -0.74, 0.0)
	event.set_character_motion(15, "立ち", 4)
	event.set_character_near_fade_distance(15, 15.0)
	event.set_character_active(16)
	event.set_character_position(16, 2297.96, 0.0, 3228.8)
	event.set_character_rotation(16, 0.0, -2.88, 0.0)
	event.set_character_motion(16, "立ち", 4)
	event.set_character_near_fade_distance(16, 15.0)
	event.set_character_active(17)
	event.set_character_position(17, 1817.39, 4.0, 2034.82)
	event.set_character_rotation(17, 0.0, 0.02, 0.0)
	event.set_character_motion(17, "立ち", 4)
	event.set_character_near_fade_distance(17, 15.0)
	event.set_character_active(18)
	event.set_character_position(18, 1527.49, 4.0, 2385.88)
	event.set_character_rotation(18, 0.0, 2.06, 0.0)
	event.set_character_motion(18, "立ち", 4)
	event.set_character_near_fade_distance(18, 15.0)
end

return helper_8d25bb56
