--!strict
--- Event script for the second Moon Flower Palace boss map, with the spiral rock sinking events and the boss area intro cutscenes.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local moon_flower_palace_boss_2 = require("@lib/event/moon_flower_palace_boss_2")
local wait = require("@lib/event/wait")

--- Placeholder hook run on map entry that does nothing.
local function on_map_loaded() end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

script.on_map_loaded = on_map_loaded
script[99] = script.on_map_loaded

--- Plays the boss intro cutscene and spawns the first boss when the boss flag is set, then fades in.
function script.default_event()
	local boss_flag: s32 = 0
	local battle_sound_id: s32 = 0
	local step: number = 0
	return vm.guard(function()
		on_map_loaded()
		boss_flag = event.get_save_flag(728) or boss_flag
		if boss_flag == 1 then
			step = 1
			moon_flower_palace_boss_2.play_boss_intro_cutscene_1()
			event.load_map_sounds(7691)
			event.set_character_visible(1, 1)
			event.set_character_visible(2, 1)
			event.show_dungeon_status_bar(1, 1.0)
			battle_sound_id = event.get_sound_id(4) or battle_sound_id
			print("btl_snd_id = ", battle_sound_id, "\n")
			event.set_action_character_second_sound_bank(0, battle_sound_id)
			event.copy_action_character_sound_to_parts(0)
			character.place_standing_and_reset_cloth(vm.f32(3846.1), vm.f32(1622.3), vm.f32(-2002.6), vm.f32(0.69))
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
		if step <= 1 then
			print("btl_snd_id = ", battle_sound_id, "\n")
			cutscene.ignore_coordinates(vm.f32(3846.1), vm.f32(1622.3), vm.f32(-2002.6), vm.f32(0.69))
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.key_open() end

--- Sinks the first spiral rock.
function script.sink_spiral_rock_1()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-1")
	moon_flower_palace_boss_2.sink_spiral_rock()
end
script[500] = script.sink_spiral_rock_1

--- Sinks the second spiral rock.
function script.sink_spiral_rock_2()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-3")
	moon_flower_palace_boss_2.sink_spiral_rock()
end
script[501] = script.sink_spiral_rock_2

--- Sinks the third spiral rock.
function script.sink_spiral_rock_3()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-5")
	moon_flower_palace_boss_2.sink_spiral_rock()
end
script[502] = script.sink_spiral_rock_3

--- Sinks the fourth spiral rock.
function script.sink_spiral_rock_4()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-7")
	moon_flower_palace_boss_2.sink_spiral_rock()
end
script[503] = script.sink_spiral_rock_4

--- Sinks the fifth spiral rock.
function script.sink_spiral_rock_5()
	event.initialize_event()
	event.attach_object_handle_to_map_part_2(0, "p11_d06b02-9")
	moon_flower_palace_boss_2.sink_spiral_rock()
end
script[504] = script.sink_spiral_rock_5

--- Plays the second boss intro cutscene, raises the area rocks and spawns the boss.
function script.cutscene_boss_intro_2()
	local rock_x: f32 = 0
	local rock_y: f32 = 0
	local rock_z: f32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		step = 1
		wait.frames(20)
		step = 2
		moon_flower_palace_boss_2.play_boss_intro_cutscene_2()
		event.set_function_point_enabled("", "2f", 0)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-2")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			rock_x = out1 or rock_x
			rock_y = out2 or rock_y
			rock_z = out3 or rock_z
		end
		event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-3")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			rock_x = out1 or rock_x
			rock_y = out2 or rock_y
			rock_z = out3 or rock_z
		end
		event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
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
		if step <= 2 then
			if step <= 1 then
				step = 2
				moon_flower_palace_boss_2.play_boss_intro_cutscene_2()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "2f", 0)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-2")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						rock_x = out1 or rock_x
						rock_y = out2 or rock_y
						rock_z = out3 or rock_z
					end
					event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-3")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						rock_x = out1 or rock_x
						rock_y = out2 or rock_y
						rock_z = out3 or rock_z
					end
					event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
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
script[550] = script.cutscene_boss_intro_2

--- Plays the third boss intro cutscene, raises the area rocks and spawns the boss.
function script.cutscene_boss_intro_3()
	local rock_x: f32 = 0
	local rock_y: f32 = 0
	local rock_z: f32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		step = 1
		wait.frames(20)
		step = 2
		moon_flower_palace_boss_2.play_boss_intro_cutscene_3()
		event.set_function_point_enabled("", "3f", 0)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-4")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			rock_x = out1 or rock_x
			rock_y = out2 or rock_y
			rock_z = out3 or rock_z
		end
		event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-5")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			rock_x = out1 or rock_x
			rock_y = out2 or rock_y
			rock_z = out3 or rock_z
		end
		event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
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
		if step <= 2 then
			if step <= 1 then
				step = 2
				moon_flower_palace_boss_2.play_boss_intro_cutscene_3()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "3f", 0)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-4")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						rock_x = out1 or rock_x
						rock_y = out2 or rock_y
						rock_z = out3 or rock_z
					end
					event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-5")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						rock_x = out1 or rock_x
						rock_y = out2 or rock_y
						rock_z = out3 or rock_z
					end
					event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
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
script[551] = script.cutscene_boss_intro_3

--- Plays the fourth boss intro cutscene, raises the area rocks and spawns the boss.
function script.cutscene_boss_intro_4()
	local rock_x: f32 = 0
	local rock_y: f32 = 0
	local rock_z: f32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		step = 1
		wait.frames(20)
		step = 2
		moon_flower_palace_boss_2.play_boss_intro_cutscene_4()
		event.set_function_point_enabled("", "4f", 0)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-6")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			rock_x = out1 or rock_x
			rock_y = out2 or rock_y
			rock_z = out3 or rock_z
		end
		event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-7")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			rock_x = out1 or rock_x
			rock_y = out2 or rock_y
			rock_z = out3 or rock_z
		end
		event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
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
		if step <= 2 then
			if step <= 1 then
				step = 2
				moon_flower_palace_boss_2.play_boss_intro_cutscene_4()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "4f", 0)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-6")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						rock_x = out1 or rock_x
						rock_y = out2 or rock_y
						rock_z = out3 or rock_z
					end
					event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-7")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						rock_x = out1 or rock_x
						rock_y = out2 or rock_y
						rock_z = out3 or rock_z
					end
					event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
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
script[552] = script.cutscene_boss_intro_4

--- Plays the twin boss landing cutscene, raises the area rocks and spawns both bosses.
function script.cutscene_twin_boss_landing()
	local rock_x: f32 = 0
	local rock_y: f32 = 0
	local rock_z: f32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(20)
		step = 1
		wait.frames(20)
		step = 2
		moon_flower_palace_boss_2.play_twin_boss_landing_cutscene()
		event.set_function_point_enabled("", "5f", 0)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-8")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			rock_x = out1 or rock_x
			rock_y = out2 or rock_y
			rock_z = out3 or rock_z
		end
		event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
		event.attach_object_handle_to_map_part_2(0, "p11_d06b02-9")
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			rock_x = out1 or rock_x
			rock_y = out2 or rock_y
			rock_z = out3 or rock_z
		end
		event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
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
		if step <= 2 then
			if step <= 1 then
				step = 2
				moon_flower_palace_boss_2.play_twin_boss_landing_cutscene()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "5f", 0)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-8")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						rock_x = out1 or rock_x
						rock_y = out2 or rock_y
						rock_z = out3 or rock_z
					end
					event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
					event.attach_object_handle_to_map_part_2(0, "p11_d06b02-9")
					do
						local out1, out2, out3 = event.get_object_handle_position(0)
						rock_x = out1 or rock_x
						rock_y = out2 or rock_y
						rock_z = out3 or rock_z
					end
					event.set_object_handle_position(0, rock_x, rock_y + 200.0, rock_z)
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
script[553] = script.cutscene_twin_boss_landing

--- Fades out and moves to the final boss map.
function script.exit_to_d06b03()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.fade_out_screen(20)
	wait.frames(20)
	event.load_dungeon_map("d06b03")
	event.load_event_script("d06b03/d06b03.stb", 100)
end
script[554] = script.exit_to_d06b03

--- Handles the party being defeated without dialogue.
function script.on_party_defeated()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_party_defeated

--- Respawns the first boss and places the party at its area.
function script.retry_boss_fight_1()
	event.initialize_event()
	event.set_save_flag(728, 1)
	event.load_dungeon_monster(603, 1)
	event.place_dungeon_monster(603, 4034.9, 1622.3, -1778.2, 0.0, -2.46, 0.0)
	character.place_standing_and_reset_cloth(3760.0, vm.f32(1622.3), -2117.0, vm.f32(0.68))
	event.set_camera_position(3660.11, 1666.73, -2241.34)
	event.set_camera_look_at(3760.76, 1652.31, -2116.96)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end
script[27020] = script.retry_boss_fight_1

--- Respawns the second boss and places the party at its area.
function script.retry_boss_fight_2()
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
script[27030] = script.retry_boss_fight_2

--- Respawns the third boss and places the party at its area.
function script.retry_boss_fight_3()
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
script[27040] = script.retry_boss_fight_3

--- Respawns the fourth boss and places the party at its area.
function script.retry_boss_fight_4()
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
script[27050] = script.retry_boss_fight_4

--- Respawns both twin bosses and places the party at their area.
function script.retry_twin_boss_fight()
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
script[27060] = script.retry_twin_boss_fight

return script
