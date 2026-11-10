--!strict
-- map/d/d06/b02/d06b02_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_080dd419 = require("@lib/event/helper_080dd419")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_3ab19c66 = require("@lib/event/helper_3ab19c66")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_4cedea73 = require("@lib/event/helper_4cedea73")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_add029f7 = require("@lib/event/helper_add029f7")
local helper_c057f6fd = require("@lib/event/helper_c057f6fd")
local helper_f9ac3902 = require("@lib/event/helper_f9ac3902")
local wait_frames = require("@lib/event/wait_frames")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event_99()
		flag = event.get_save_flag(728) or flag
		if flag == 1 then
			at = 1
			helper_add029f7()
			event.load_map_sounds(7691)
			event.set_character_visible(1, 1)
			event.set_character_visible(2, 1)
			event.show_dungeon_status_bar(1, 1.0)
			var1 = event.get_sound_id(4) or var1
			print("btl_snd_id = ", var1, "\n")
			event.set_action_character_second_sound_bank(0, var1)
			event.copy_action_character_sound_to_parts(0)
			helper_9dafbc83(vm.f32(3846.1), vm.f32(1622.3), vm.f32(-2002.6), vm.f32(0.69))
			event.set_camera_position(3744.75, 1652.31, -2126.35)
			event.set_camera_look_at(3846.14, 1652.31, -2002.58)
			event.reset_follow_camera(0)
			event.load_dungeon_monster(603, 1)
			event.place_dungeon_monster(603, 4034.9, 1622.3, -1778.2, 0.0, -2.46, 0.0)
		end
		event.fade_in_screen(30)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 1 then
			print("btl_snd_id = ", var1, "\n")
			helper_43f02c95(vm.f32(3846.1), vm.f32(1622.3), vm.f32(-2002.6), vm.f32(0.69))
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-1")
	helper_080dd419()
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-3")
	helper_080dd419()
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-5")
	helper_080dd419()
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-7")
	helper_080dd419()
end

--- Event 504, which map data, a script or the engine runs by number.
function script.event_504()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-9")
	helper_080dd419()
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		at = 1
		wait_frames(20)
		at = 2
		helper_c057f6fd()
		event.set_function_point_enabled("", "2f", 0)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-2")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-3")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.load_dungeon_monster(604, 1)
		event.place_dungeon_monster(604, 3220.8, 2411.4, 3458.1, 0.0, 1.91, 0.0)
		event.set_character_position(0, 3482.7, 2411.4, 3361.8)
		event.set_character_rotation(0, 0.0, -1.21, 0.0)
		event.set_camera_position(3776.37, 2452.2, 3256.29)
		event.set_camera_look_at(3625.59, 2441.42, 3309.81)
		event.reset_follow_camera(0)
		event.fade_in_screen(20)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_c057f6fd()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "2f", 0)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-2")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-3")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.load_dungeon_monster(604, 1)
					event.place_dungeon_monster(604, 3220.8, 2411.4, 3458.1, 0.0, 1.91, 0.0)
					event.set_character_position(0, 3482.7, 2411.4, 3361.8)
					event.set_character_rotation(0, 0.0, -1.21, 0.0)
					event.set_camera_position(3776.37, 2452.2, 3256.29)
					event.set_camera_look_at(3625.59, 2441.42, 3309.81)
					event.reset_follow_camera(0)
					event.fade_in_screen(20)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 551, which map data, a script or the engine runs by number.
function script.event_551()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		at = 1
		wait_frames(20)
		at = 2
		helper_f9ac3902()
		event.set_function_point_enabled("", "3f", 0)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-4")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-5")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.load_dungeon_monster(605, 1)
		event.place_dungeon_monster(605, -5000.8, 3914.3, 1335.4, 0.0, 0.5, 0.0)
		event.set_character_position(0, -4878.4, 3914.3, 1557.6)
		event.set_character_rotation(0, 0.0, -2.64, 0.0)
		event.set_camera_position(-4801.28, 3960.04, 1697.72)
		event.set_camera_look_at(-4878.44, 3944.32, 1557.56)
		event.reset_follow_camera(0)
		event.fade_in_screen(20)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_f9ac3902()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "3f", 0)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-4")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-5")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.load_dungeon_monster(605, 1)
					event.place_dungeon_monster(605, -5000.8, 3914.3, 1335.4, 0.0, 0.5, 0.0)
					event.set_character_position(0, -4878.4, 3914.3, 1557.6)
					event.set_character_rotation(0, 0.0, -2.64, 0.0)
					event.set_camera_position(-4801.28, 3960.04, 1697.72)
					event.set_camera_look_at(-4878.44, 3944.32, 1557.56)
					event.reset_follow_camera(0)
					event.fade_in_screen(20)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 552, which map data, a script or the engine runs by number.
function script.event_552()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		at = 1
		wait_frames(20)
		at = 2
		helper_4cedea73()
		event.set_function_point_enabled("", "4f", 0)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-6")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-7")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.load_dungeon_monster(606, 1)
		event.place_dungeon_monster(606, -1126.9, 5303.1, -3005.0, 0.0, -1.78, 0.0)
		event.set_character_position(0, -1380.3, 5303.1, -3061.2)
		event.set_character_rotation(0, 0.0, 1.37, 0.0)
		event.set_camera_position(-1537.07, 5363.09, -3093.39)
		event.set_camera_look_at(-1380.34, 5333.14, -3061.24)
		event.reset_follow_camera(0)
		event.fade_in_screen(20)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_4cedea73()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "4f", 0)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-6")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-7")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.load_dungeon_monster(606, 1)
					event.place_dungeon_monster(606, -1126.9, 5303.1, -3005.0, 0.0, -1.78, 0.0)
					event.set_character_position(0, -1380.3, 5303.1, -3061.2)
					event.set_character_rotation(0, 0.0, 1.37, 0.0)
					event.set_camera_position(-1537.07, 5363.09, -3093.39)
					event.set_camera_look_at(-1380.34, 5333.14, -3061.24)
					event.reset_follow_camera(0)
					event.fade_in_screen(20)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 553, which map data, a script or the engine runs by number.
function script.event_553()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		at = 1
		wait_frames(20)
		at = 2
		helper_3ab19c66()
		event.set_function_point_enabled("", "5f", 0)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-8")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-9")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
		event.load_dungeon_monster(607, 1)
		event.load_dungeon_monster(608, 0)
		event.place_dungeon_monster(607, -3980.8, 7277.16, 3321.3, 0.0, 1.46, 0.0)
		event.place_dungeon_monster(608, -3947.0, 7277.16, 3460.7, 0.0, 2.07, 0.0)
		event.set_character_position(0, -3745.89, 7277.16, 3354.1)
		event.set_character_rotation(0, 0.0, -1.38, 0.0)
		event.set_camera_position(-3588.72, 7334.8, 3324.13)
		event.set_camera_look_at(-3745.89, 7307.16, 3354.1)
		event.reset_follow_camera(0)
		event.fade_in_screen(20)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_3ab19c66()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "5f", 0)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-8")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-9")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					event.set_object_handle_position(0, pos_x, pos_y + 200.0, pos_z)
					event.load_dungeon_monster(607, 1)
					event.load_dungeon_monster(608, 0)
					event.place_dungeon_monster(607, -3980.8, 7277.16, 3321.3, 0.0, 1.46, 0.0)
					event.place_dungeon_monster(608, -3947.0, 7277.16, 3460.7, 0.0, 2.07, 0.0)
					event.set_character_position(0, -3745.89, 7277.16, 3354.1)
					event.set_character_rotation(0, 0.0, -1.38, 0.0)
					event.set_camera_position(-3588.72, 7334.8, 3324.13)
					event.set_camera_look_at(-3745.89, 7307.16, 3354.1)
					event.reset_follow_camera(0)
					event.fade_in_screen(20)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 554, which map data, a script or the engine runs by number.
function script.event_554()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.fade_out_screen(20)
	wait_frames(20)
	event.load_dungeon_map("d06b03")
	event.load_event_script("d06b03/d06b03.stb", 100)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_2a1e9b48(0)
end

--- Event 27020, which map data, a script or the engine runs by number.
function script.event_27020()
	event.initialize_event()
	event.set_save_flag(728, 1)
	event.load_dungeon_monster(603, 1)
	event.place_dungeon_monster(603, 4034.9, 1622.3, -1778.2, 0.0, -2.46, 0.0)
	helper_9dafbc83(3760.0, vm.f32(1622.3), -2117.0, vm.f32(0.68))
	event.set_camera_position(3660.11, 1666.73, -2241.34)
	event.set_camera_look_at(3760.76, 1652.31, -2116.96)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Event 27030, which map data, a script or the engine runs by number.
function script.event_27030()
	event.initialize_event()
	event.set_save_flag(728, 1)
	event.load_dungeon_monster(604, 1)
	event.place_dungeon_monster(604, 3220.8, 2411.4, 3458.1, 0.0, 1.91, 0.0)
	event.set_character_position(0, 3482.7, 2411.4, 3361.8)
	event.set_character_rotation(0, 0.0, -1.21, 0.0)
	event.set_camera_position(3776.37, 2452.2, 3256.29)
	event.set_camera_look_at(3625.59, 2441.42, 3309.81)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Event 27040, which map data, a script or the engine runs by number.
function script.event_27040()
	event.initialize_event()
	event.set_save_flag(728, 1)
	event.load_dungeon_monster(605, 1)
	event.place_dungeon_monster(605, -5000.8, 3914.3, 1335.4, 0.0, 0.5, 0.0)
	event.set_character_position(0, -4878.4, 3914.3, 1557.6)
	event.set_character_rotation(0, 0.0, -2.64, 0.0)
	event.set_camera_position(-4801.28, 3960.04, 1697.72)
	event.set_camera_look_at(-4878.44, 3944.32, 1557.56)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Event 27050, which map data, a script or the engine runs by number.
function script.event_27050()
	event.initialize_event()
	event.set_save_flag(728, 1)
	event.load_dungeon_monster(606, 1)
	event.place_dungeon_monster(606, -1126.9, 5303.1, -3005.0, 0.0, -1.78, 0.0)
	event.set_character_position(0, -1380.3, 5303.1, -3061.2)
	event.set_character_rotation(0, 0.0, 1.37, 0.0)
	event.set_camera_position(-1537.07, 5363.09, -3093.39)
	event.set_camera_look_at(-1380.34, 5333.14, -3061.24)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Event 27060, which map data, a script or the engine runs by number.
function script.event_27060()
	event.initialize_event()
	event.set_save_flag(728, 1)
	event.load_dungeon_monster(607, 1)
	event.load_dungeon_monster(608, 0)
	event.place_dungeon_monster(607, -3980.8, 7277.16, 3321.3, 0.0, 1.46, 0.0)
	event.place_dungeon_monster(608, -3947.0, 7277.16, 3460.7, 0.0, 2.07, 0.0)
	event.set_character_position(0, -3745.89, 7277.16, 3354.1)
	event.set_character_rotation(0, 0.0, -1.38, 0.0)
	event.set_camera_position(-3588.72, 7334.8, 3324.13)
	event.set_camera_look_at(-3745.89, 7307.16, 3354.1)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

return script
