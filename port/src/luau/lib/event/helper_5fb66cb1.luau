--!strict
-- Shared event helper used by 114 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_5fb66cb1()
	local active_chr_no: s32 = 0
	local frame: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
		frame = 86
	end
	if active_chr_no == 1 then
		event.load_character_motion_pack(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
		frame = 64
	end
	if active_chr_no == 2 or active_chr_no == 3 then
		vm.wait(1)
		event.finish_event()
		return
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.get_object_handle_rotation(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.turn_object_sequence_toward(0, pos_x, pos_y, pos_z, 6)
	wait_objects(0)
	event.set_object_sequence_motion(0, "だめだめ", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	event.delay_object_sequence_rotation_track(0, frame)
	event.rotate_object_sequence(0, rot_x, rot_y, rot_z, 6)
	wait_objects(0)
	if active_chr_no == 0 or active_chr_no == 1 then
		event.delete_character_extension_packs(0)
	end
	event.finish_event()
end

return helper_5fb66cb1
