--!strict
--- Moon that drifts away from the origin and requests a cutscene event once its event timer runs out.

local vm = require("@lib/vm")
local state = require("@lib/monster/state")

--- Uses a short clip distance for ordinary monsters and an unlimited one for bosses.
local function configure_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

local script = {}

--- Does nothing for this monster.
function script.setup() end

--- Sets the monster attributes, resets the event flag and links the moon to its map part.
function script.init()
	configure_clip_distance()
	monster.set_clip_distance(999999.9)
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(8, 1)
	monster.set_monster_attributes(16, 1)
	monster.set_monster_attributes(1, 1)
	monster.set_variable(0, 0)
	monster.link_map_part("p06_d06b03-0")
end

--- Moves the moon steadily away from the origin and requests the cutscene event once the event timer runs out.
function script.loop()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local distance: f32 = 0
	local scale: f32 = 0
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local remaining_time: s32 = 0
	local event_requested: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(position_x, position_y, position_z)
		destination_x = out1 or destination_x
		destination_y = out2 or destination_y
		destination_z = out3 or destination_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(destination_x, destination_y, destination_z)
		destination_x = out1 or destination_x
		destination_y = out2 or destination_y
		destination_z = out3 or destination_z
	end
	do
		local out1, out2, out3 = monster.scale_vector(destination_x, destination_y, destination_z, 5000.0)
		destination_x = out1 or destination_x
		destination_y = out2 or destination_y
		destination_z = out3 or destination_z
	end
	distance = monster.get_distance_between(destination_x, destination_y, destination_z, position_x, position_y, position_z) or distance
	scale = vm.f32(vm.fdiv(distance, 9000))
	do
		local out1, out2, out3 = monster.copy_vector(destination_x, destination_y, destination_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(step_x, step_y, step_z, position_x, position_y, position_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(step_x, step_y, step_z)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	do
		local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, scale)
		step_x = out1 or step_x
		step_y = out2 or step_y
		step_z = out3 or step_z
	end
	while true do
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, step_x, step_y, step_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.get_variable(0)
		distance = monster.get_distance_between(destination_x, destination_y, destination_z, position_x, position_y, position_z) or distance
		event_requested = monster.get_variable(0) or event_requested
		remaining_time = monster.get_event_info_2(0) or remaining_time
		if remaining_time <= 0 and event_requested == 0 then
			monster.set_variable(0, 1)
			do
				local out1, out2, out3 = monster.copy_vector(0.0, 0.0, 0.0)
				step_x = out1 or step_x
				step_y = out2 or step_y
				step_z = out3 or step_z
			end
			monster.request_event_script(1201)
		end
		monster.set_position(position_x, position_y, position_z)
		vm.wait()
	end
end

--- Cancels the current action and does nothing.
function script.on_damage()
	state.stop_and_clear_action()
	state.do_nothing()
end

--- Faces the target and releases the action.
function script.on_knockdown()
	state.lock_and_face_target()
	state.unlock_and_clear_action()
end

--- Restores the mask flags and clears the guard state.
function script.on_guard()
	state.restore_mask_flag_2_and_stand()
	state.clear_mask_flag_2()
end

--- Locks and resets the motion, then unlocks.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Locks and resets the motion, then unlocks.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Runs the monster's death.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing on death.
function script.on_death() end

--- Waits forever when caught.
function script.on_caught()
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when landing.
function script.on_land() end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when stunned.
function script.on_stun() end

return script
