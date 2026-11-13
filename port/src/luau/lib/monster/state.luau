--!strict
--- Monster variables, lock flags and attribute helpers for monster scripts.

local vm = require("@lib/vm")
local movement = vm.module("@lib/monster/movement")
local reaction = vm.module("@lib/monster/reaction")
local timer = vm.module("@lib/monster/timer")

local state = {}

--- Clears an attribute, locks the monster's masks, stops it and resets its motion.
function state.clear_attribute_and_lock()
	monster.set_monster_attributes(32, 0)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	movement.stop_turning()
	monster.reset_motion()
end

--- Clears an attribute, locks the masks, stops the monster and resets its motion for monsters using the alternative command set.
function state.clear_attribute_and_lock_variant()
	monster.set_photo_opportunity(32, 0)
	monster.call_command(119, 1, 1) -- retail: the handler rejects 2 arguments
	monster.call_command(119, 2, 1) -- retail: the handler rejects 2 arguments
	monster.call_command(72) -- retail: the handler rejects 0 arguments
	movement.hold_current_facing_variant()
	monster.get_attack_power_0()
end

--- Returns the flag value with every bit that is also set in the mask cleared.
function state.clear_flags(flags: s32, mask: s32)
	local bit: s32 = 0
	bit = 1
	for i = 0, 31 do
		if (if vm.i32(bit32.band(flags, bit)) ~= 0 then vm.i32(bit32.band(mask, bit)) else 0) ~= 0 then
			flags = vm.i32(flags - bit)
		end
		bit = vm.i32(bit * 2)
	end
	return flags
end

--- Clears mask flag 2 on the monster.
function state.clear_mask_flag_2()
	monster.set_mask_flags(2, 0)
end

--- Sets monster variables 1 to 4 to -1.
function state.clear_variables_1_to_4()
	monster.set_variable(1, -1)
	monster.set_variable(2, -1)
	monster.set_variable(3, -1)
	monster.set_variable(4, -1)
end

--- Does nothing and serves as an empty placeholder hook.
function state.do_nothing() end

--- Does nothing and serves as a second empty placeholder hook.
function state.do_nothing_hook() end

--- Returns the stored flight clearance distance.
function state.get_flight_clearance(result: f32)
	local clearance: f32 = 0
	clearance = monster.get_secondary_variable_float(16) or clearance
	result = clearance
	return result
end

--- Returns the stored maximum height above the ground a flying monster may fly at.
function state.get_max_flight_height(result: f32)
	local max_height: f32 = 0
	max_height = monster.get_secondary_variable_float(17) or max_height
	result = max_height
	return result
end

--- Returns secondary float variable 8.
function state.get_secondary_float(secondary_float: f32)
	local stored_value: f32 = 0
	stored_value = monster.get_secondary_variable_float(8) or stored_value
	secondary_float = stored_value
	return secondary_float
end

--- Returns monster variable 20.
function state.get_state_flag(state_flag: s32)
	local stored_value: s32 = 0
	stored_value = monster.get_variable(20) or stored_value
	state_flag = stored_value
	return state_flag
end

--- Adds one to the frame counter variable.
function state.increment_frame_counter()
	local frame_count: s32 = 0
	frame_count = monster.get_variable(7) or frame_count
	monster.set_variable(7, vm.i32(frame_count + 1))
end

--- Initializes flight height, clearance, clip distance and flying attributes.
function state.initialize_flying()
	state.set_max_flight_height(vm.f32(999.9))
	state.set_flight_clearance(35.0)
	monster.set_clip_distance(600.0)
	state.set_flying_attributes(1)
end

--- Sets the maximum flight height and flight clearance, sets the clip distance to 600 and turns the flying attributes on.
function state.initialize_flying_defaults()
	state.set_max_flight_height(vm.f32(999.9))
	state.set_flight_clearance(30.0)
	monster.set_clip_distance(600.0)
	state.set_flying_attributes(1)
end

--- Locks the masks, resets the motion, stops the monster, faces the target and sets the action status.
function state.lock_and_face_target()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	timer.wait_one_frame()
	monster.set_action_status(1)
end

--- Locks the masks, resets the motion, stops the monster, faces the target and sets the action status while updating the guard state.
function state.lock_and_face_target_guarded()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	reaction.update_and_wait_frame()
	monster.set_action_status(1)
end

--- Locks the masks, resets the motion, stops the monster and snaps it to face the target for monsters using the alternative command set.
function state.lock_and_face_target_variant()
	monster.call_command(119, 1, 1) -- retail: the handler rejects 2 arguments
	monster.call_command(119, 2, 1) -- retail: the handler rejects 2 arguments
	monster.get_attack_power_0()
	monster.call_command(72) -- retail: the handler rejects 0 arguments
	movement.hold_current_facing_variant()
	movement.face_target_instantly_variant()
	vm.wait()
end

--- Locks the monster's masks, resets its motion, halts its turning and stops it moving.
function state.lock_and_reset_motion()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	movement.stop_turning()
	monster.stop_moving()
end

--- Locks the monster's masks and resets its motion for monsters using the alternative command set.
function state.lock_and_reset_motion_variant()
	monster.call_command(119, 1, 1) -- retail: the handler rejects 2 arguments
	monster.call_command(119, 2, 1) -- retail: the handler rejects 2 arguments
	monster.get_attack_power_0()
end

--- Locks the monster's masks, resets its motion, stops it moving and halts its turning.
function state.lock_and_stop_moving()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
end

--- Restores the monster's mask flags, motion, attributes and action status to the idle state.
function state.reset_to_idle()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	movement.stop_turning()
	timer.wait_frame()
	state.set_flying_attributes(0)
	monster.set_action_status(1)
end

--- Sets monster variables 1 to 3 to -1.
function state.reset_variables()
	monster.set_variable(1, -1)
	monster.set_variable(2, -1)
	monster.set_variable(3, -1)
end

--- Sets mask flag 2, resets the motion, stops moving and stops turning.
function state.restore_mask_flag_2_and_stand()
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
end

--- Stores the clearance distance a flying monster keeps ahead of itself.
function state.set_flight_clearance(clearance: f32)
	monster.set_secondary_variable_float(16, clearance)
end

--- Stores a float in monster variable 15.
function state.set_float_state(value: f32)
	monster.set_variable_float(15, value)
end

--- Stores three values in the monster's first three float variables.
function state.set_float_variables(first_value: f32, second_value: f32, third_value: f32)
	monster.set_variable_float(0, first_value)
	monster.set_variable_float(1, second_value)
	monster.set_variable_float(2, third_value)
end

--- Sets or clears the attributes that make the monster fly.
function state.set_flying_attributes(enabled: s32)
	if enabled ~= 0 then
		monster.set_monster_attributes(4, 1)
		monster.set_monster_attributes(256, 1)
		monster.set_monster_attributes(8, 1)
	else
		monster.set_monster_attributes(4, 0)
		monster.set_monster_attributes(256, 0)
		monster.set_monster_attributes(8, 0)
	end
end

--- Sets the maximum flight height, flight clearance, clip distance and flying attributes of a flying monster.
function state.set_flying_defaults()
	state.set_max_flight_height(vm.f32(999.9))
	state.set_flight_clearance(42.0)
	monster.set_clip_distance(600.0)
	state.set_flying_attributes(1)
end

--- Stores the maximum height above the ground a flying monster may fly at.
function state.set_max_flight_height(max_height: f32)
	monster.set_secondary_variable_float(17, max_height)
end

--- Stores a value in secondary variable 11.
function state.set_secondary_flag(value: s32)
	monster.set_secondary_variable(11, value)
end

--- Stores a value in monster variable 20.
function state.set_state_flag(state_flag: s32)
	monster.set_variable(20, state_flag)
end

--- Stores a value in the monster's secondary float variable 8.
function state.set_unknown_float_8(value: f32)
	monster.set_secondary_variable_float(8, value)
end

--- Stores a value in the monster's secondary float variable 9.
function state.set_unknown_float_9(value: f32)
	monster.set_secondary_variable_float(9, value)
end

--- Sets the monster's default sensing ranges and a 600 unit clip distance.
function state.setup_default_ranges()
	state.set_max_flight_height(vm.f32(999.9))
	state.set_flight_clearance(50.0)
	monster.set_clip_distance(600.0)
	state.set_flying_attributes(1)
end

--- Stops the monster, halts its turning, resets its motion and clears its action status.
function state.stop_and_clear_action()
	monster.stop_moving()
	movement.stop_turning()
	monster.reset_motion()
	monster.set_action_status(0)
end

--- Stops the monster, holds its facing, resets its motion and clears its action status for monsters using the alternative command set.
function state.stop_and_clear_action_variant()
	monster.call_command(72) -- retail: the handler rejects 0 arguments
	movement.hold_current_facing_variant()
	monster.get_attack_power_0()
	monster.set_model_lighting(0)
end

--- Resets the motion, stops the monster and holds its facing for monsters using the alternative command set.
function state.stop_and_reset_motion_variant()
	monster.get_attack_power_0()
	monster.call_command(72) -- retail: the handler rejects 0 arguments
	movement.hold_current_facing_variant()
end

--- Resets the motion and turns the flying attributes off.
function state.stop_flying_and_reset_motion()
	monster.reset_motion()
	state.set_flying_attributes(0)
end

--- Unlocks the monster's masks.
function state.unlock()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Unlocks the monster's masks and clears its action status.
function state.unlock_and_clear_action()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
end

--- Unlocks the monster's masks for monsters using the alternative command set.
function state.unlock_variant()
	monster.call_command(119, 1, 0) -- retail: the handler rejects 2 arguments
	monster.call_command(119, 2, 0) -- retail: the handler rejects 2 arguments
end

--- Waits until the monster's life is no longer zero.
function state.wait_until_alive()
	local life: s32 = 0
	while true do
		vm.wait()
		life = monster.get_life_int() or life
		if life ~= 0 then
			return
		end
	end
end

return state
