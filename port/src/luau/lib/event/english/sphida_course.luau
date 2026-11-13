--!strict
--- English text and flow for ending Sphida course holes.

local vm = require("@lib/vm")
local message = vm.module("@lib/event/message")
local minigame = vm.module("@lib/event/minigame")
local wait = vm.module("@lib/event/wait")

local sphida_course = {}

--- Ends a Sphida hole by resetting the player and camera, awarding the dungeon floor medal or recording the bonus course score, and loading the next hole or the final results.
function sphida_course.finish_hole(hole_cleared: s32)
	local is_bonus_course: s32 = 0
	local saved_hole: s32 = 0
	local par: s32 = 0
	local next_saved_hole: s32 = 0
	local stage_id: s32 = 0
	local floor_number: s32 = 0
	local floor_state: s32 = 0
	local reward_camera_x: f32 = 0
	local reward_camera_y: f32 = 0
	local reward_camera_z: f32 = 0
	local current_par: s32 = 0
	local sphere_lost_camera_x: f32 = 0
	local sphere_lost_camera_y: f32 = 0
	local sphere_lost_camera_z: f32 = 0
	event.set_sphida_status_panel_visible(0)
	event.delete_character(12)
	event.clear_effect_manager()
	event.delete_character_extension_packs(0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 1)
	event.set_camera_control_enabled(1)
	event.delete_sword_afterimage()
	is_bonus_course = event.is_sphida_bonus_course() or is_bonus_course
	saved_hole = event.get_sphida_saved_hole() or saved_hole
	if hole_cleared == 1 and is_bonus_course == 1 then
		par = event.get_sphida_par() or par
		if saved_hole ~= 8 then
			event.set_sphida_hole_score(-1, vm.i32(par + 3))
		end
		minigame.delete_sphida_objects()
		next_saved_hole = event.get_sphida_saved_hole() or next_saved_hole
		if next_saved_hole == 8 then
			minigame.open_sphida_menu()
			return
		else
			minigame.load_saved_sphida_hole_script()
		end
		return
	end
	if is_bonus_course == 0 then
		event.show_dungeon_status_bar(1, 0.1)
	end
	event.start_crossfade(15)
	if hole_cleared == 1 then
		if is_bonus_course == 0 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			floor_number = event.get_dungeon_floor() or floor_number
			floor_state = event.get_dungeon_floor_info(stage_id, floor_number, 4) or floor_state
			if floor_state == 1 then
				event.set_dungeon_floor_info(stage_id, floor_number, 5, 128)
				event.add_yarikomi_medals(1)
				do
					local out1, out2, out3 = event.get_previous_camera_next_position()
					reward_camera_x = out1 or reward_camera_x
					reward_camera_y = out2 or reward_camera_y
					reward_camera_z = out3 or reward_camera_z
				end
				event.set_camera_position(reward_camera_x, reward_camera_y, reward_camera_z)
				do
					local out1, out2, out3 = event.get_previous_camera_next_look_at()
					reward_camera_x = out1 or reward_camera_x
					reward_camera_y = out2 or reward_camera_y
					reward_camera_z = out3 or reward_camera_z
				end
				event.set_camera_look_at(reward_camera_x, reward_camera_y, reward_camera_z)
				event.set_message_window_mode(0, 4)
				message.show_and_wait(0, 2010, 8, 0, 0)
				event.reset_follow_camera(0)
			end
		end
	end
	current_par = event.get_sphida_par() or current_par
	if hole_cleared == 0 and current_par <= 0 then
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			sphere_lost_camera_x = out1 or sphere_lost_camera_x
			sphere_lost_camera_y = out2 or sphere_lost_camera_y
			sphere_lost_camera_z = out3 or sphere_lost_camera_z
		end
		event.set_camera_position(sphere_lost_camera_x, sphere_lost_camera_y, sphere_lost_camera_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			sphere_lost_camera_x = out1 or sphere_lost_camera_x
			sphere_lost_camera_y = out2 or sphere_lost_camera_y
			sphere_lost_camera_z = out3 or sphere_lost_camera_z
		end
		event.set_camera_look_at(sphere_lost_camera_x, sphere_lost_camera_y, sphere_lost_camera_z)
		event.set_message_window_mode(0, 4)
		if is_bonus_course == 0 then
			message.show_and_wait(0, 2003, 8, 0, 0)
		else
			if saved_hole == 8 then
				message.show_and_wait(0, 2003, 8, 0, 0)
				minigame.show_sphida_hole_score()
				minigame.delete_sphida_objects()
				minigame.open_sphida_menu()
				return
			else
				event.open_message_window_2(0, "The Sphere has disappeared.\nProceed to the next course.")
				message.show_and_wait(0, -1, 8, 0, 0)
			end
			event.fade_out_screen(30)
			wait.frames(30)
			minigame.delete_sphida_objects()
			minigame.load_saved_sphida_hole_script()
			return
		end
		event.reset_follow_camera(0)
	end
	event.finish_event()
end

return sphida_course
