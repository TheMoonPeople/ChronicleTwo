--!strict
--- Drives the red Atramilia light orb that rises above Shingala and circles it.

local vm = require("@lib/vm")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Moves the orb to a point above its owner over 60 frames and marks the rise as done.
local function rise_above_owner()
	local value: s32 = 0
	local frame: s32 = 0
	local owner_x: f32 = 0
	local owner_y: f32 = 0
	local owner_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local scale: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	monster.set_variable(27, 1)
	value = monster.get_variable(31) or value
	do
		local out1, out2, out3 = monster.get_monster_position(value)
		owner_x = out1 or owner_x
		owner_y = out2 or owner_y
		owner_z = out3 or owner_z
	end
	monster.get_monster_yaw_2(value)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	target_x = owner_x
	target_y = vm.f32(owner_y + 100.0)
	target_z = owner_z
	scale = movement.get_travel_frames(scale, target_x, target_y, target_z, 60.0)
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
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
	frame = 0
	while frame < vm.ftoi(60.0) do
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, step_x, step_y, step_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.set_position(position_x, position_y, position_z)
		vm.wait()
		frame = frame + 1
	end
	monster.set_variable(27, 2)
end

--- Moves the orb to its starting point on the orbit ring around itself over 45 frames.
local function drift_to_orbit_start()
	local frame: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local ring_x: f32 = 0
	local ring_y: f32 = 0
	local ring_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local distance: f32 = 0
	local scale: f32 = 0
	monster.set_variable(27, 8)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	ring_x = vm.f32(position_x + vm.f32(vm.sin(0.0) * 30.0))
	ring_y = position_y
	ring_z = vm.f32(position_z + vm.f32(vm.cos(0.0) * 30.0))
	distance = monster.get_distance_between(ring_x, ring_y, ring_z, position_x, position_y, position_z) or distance
	scale = vm.f32(distance / 45.0)
	do
		local out1, out2, out3 = monster.copy_vector(ring_x, ring_y, ring_z)
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
	frame = 0
	while frame < vm.ftoi(45.0) do
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, step_x, step_y, step_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.set_position(position_x, position_y, position_z)
		vm.wait()
		frame = frame + 1
	end
	monster.set_variable(27, 16)
end

--- Spawns the orb's light effect and circles the owner with it for 150 frames.
local function circle_owner_with_light()
	local value: s32 = 0
	local slot: s32 = 0
	local chara_type: s32 = 0
	local value_2: s32 = 0
	local owner_x: f32 = 0
	local owner_y: f32 = 0
	local owner_z: f32 = 0
	local center_x: f32 = 0
	local center_y: f32 = 0
	local center_z: f32 = 0
	local rot_y: f32 = 0
	monster.set_variable(27, 32)
	value = monster.get_variable(31) or value
	do
		local out1, out2, out3 = monster.get_monster_position(value)
		owner_x = out1 or owner_x
		owner_y = out2 or owner_y
		owner_z = out3 or owner_z
	end
	rot_y = monster.get_monster_yaw_2(value) or rot_y
	monster.get_position_3()
	chara_type = monster.get_character_number() or chara_type
	value_2 = monster.get_variable(31) or value_2
	slot = monster.create_effect_2("アトラの光") or slot
	monster.set_variable(24, slot)
	monster.set_effect_owner(slot, chara_type)
	monster.set_effect_value(slot, 0, 0)
	monster.set_effect_value(slot, 1, value_2)
	monster.set_effect_value(slot, 7, 1)
	center_x = owner_x
	center_y = vm.f32(owner_y + 100.0)
	center_z = owner_z
	rot_y = 0.0
	for frame = 0, 149 do
		rot_y = vm.f32(rot_y + vm.f32(0.19634955))
		owner_x = vm.f32(center_x + vm.f32(vm.sin(rot_y) * 30.0))
		owner_y = center_y
		owner_z = vm.f32(center_z + vm.f32(vm.cos(rot_y) * 30.0))
		monster.set_position(owner_x, owner_y, owner_z)
		vm.wait()
	end
	monster.finish_effect(slot)
	monster.set_variable(27, 64)
end

--- Flies the orb to its orbit position around the owner over 60 frames using the stored orbit angles.
local function fly_to_owner_orbit()
	local value: s32 = 0
	local frame: s32 = 0
	local owner_x: f32 = 0
	local owner_y: f32 = 0
	local owner_z: f32 = 0
	local angle_a: f32 = 0
	local angle_b: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local scale: f32 = 0
	local sin_a: f32 = 0
	local cos_a: f32 = 0
	local sin_b: f32 = 0
	local cos_b: f32 = 0
	do
		local out1, out2, _ = monster.copy_vector(0.0, 0.0, 0.0)
		angle_a = out1 or angle_a
		angle_b = out2 or angle_b
	end
	value = monster.get_variable(31) or value
	angle_a = monster.get_variable_float(0) or angle_a
	angle_b = monster.get_variable_float(1) or angle_b
	monster.get_variable_float(2)
	do
		local out1, out2, out3 = monster.get_monster_position(value)
		owner_x = out1 or owner_x
		owner_y = out2 or owner_y
		owner_z = out3 or owner_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	sin_a = vm.f32(vm.sin(angle_a) * 50.0)
	cos_a = vm.f32(vm.cos(angle_a) * 50.0)
	sin_b = vm.f32(vm.sin(angle_b) * 50.0)
	cos_b = vm.f32(vm.cos(angle_b) * 50.0)
	target_x = vm.f32(owner_x + sin_b)
	target_y = vm.f32(vm.f32(owner_y + 50.0) + sin_a)
	target_z = vm.f32(vm.f32(owner_z + cos_a) + cos_b)
	scale = movement.get_travel_frames(scale, target_x, target_y, target_z, 60.0)
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
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
	frame = 0
	while frame < vm.ftoi(60.0) do
		do
			local out1, out2, out3 = monster.add_vectors(position_x, position_y, position_z, step_x, step_y, step_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		monster.set_position(position_x, position_y, position_z)
		vm.wait()
		frame = frame + 1
	end
end

--- Places the orb on its orbit around the owner and advances the stored orbit angles by the given step.
local function advance_orbit(angle_step: f32)
	local value: s32 = 0
	local owner_x: f32 = 0
	local owner_y: f32 = 0
	local owner_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local angle_a: f32 = 0
	local angle_b: f32 = 0
	local sin_a: f32 = 0
	local cos_a: f32 = 0
	local sin_b: f32 = 0
	local cos_b: f32 = 0
	do
		local out1, out2, _ = monster.copy_vector(0.0, 0.0, 0.0)
		angle_a = out1 or angle_a
		angle_b = out2 or angle_b
	end
	value = monster.get_variable(31) or value
	angle_a = monster.get_variable_float(0) or angle_a
	angle_b = monster.get_variable_float(1) or angle_b
	do
		local out1, out2, out3 = monster.get_monster_position(value)
		owner_x = out1 or owner_x
		owner_y = out2 or owner_y
		owner_z = out3 or owner_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	sin_a = vm.f32(vm.sin(angle_a) * 50.0)
	cos_a = vm.f32(vm.cos(angle_a) * 50.0)
	sin_b = vm.f32(vm.sin(angle_b) * 50.0)
	cos_b = vm.f32(vm.cos(angle_b) * 50.0)
	pos_x = vm.f32(owner_x + sin_b)
	pos_y = vm.f32(vm.f32(owner_y + 50.0) + sin_a)
	pos_z = vm.f32(vm.f32(owner_z + cos_a) + cos_b)
	monster.set_position(pos_x, pos_y, pos_z)
	angle_a = vm.f32(angle_a + angle_step)
	angle_b = vm.f32(angle_b + angle_step)
	state.set_float_variables(angle_a, angle_b, 0.0)
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Sets the orb up as a non-targetable floating light bound to its owner.
function script.init()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	movement.stop_at_current_position()
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(8, 1)
	monster.set_variable_float(0, 0.0)
	monster.set_variable_float(1, 0.0)
	monster.set_variable_float(2, 0.0)
	monster.get_variable(31)
	monster.load_effect_script("アトラの光")
	monster.set_clip_distance(9999.9)
	monster.set_monster_attributes(512, 1)
	monster.set_monster_attributes(16, 1)
	monster.set_variable(27, 0)
end

--- Cycles the orb through its rise, orbit and return stages while it sways.
function script.loop()
	local value: s32 = 0
	local value_2: s32 = 0
	local sway_angle: f32 = 0
	local sway_speed: f32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	monster.set_motion("ループ", -1, 0)
	sway_angle = vm.f32(0.049087387)
	sway_speed = vm.f32(0.0002)
	while true do
		value = monster.get_variable(30) or value
		if value == 4 then
			if sway_angle < vm.f32(0.0004) or sway_angle > vm.f32(-0.0004) then
				rise_above_owner()
			end
		end
		value_2 = monster.get_variable(27) or value_2
		if value_2 == 2 then
			drift_to_orbit_start()
			monster.set_variable(27, 16)
		end
		value_2 = monster.get_variable(27) or value_2
		if value_2 == 16 then
			circle_owner_with_light()
		end
		value_2 = monster.get_variable(27) or value_2
		if value_2 == 64 then
			fly_to_owner_orbit()
			monster.set_variable(27, 4)
			sway_angle = 0.0
			sway_speed = vm.f32(0.0002)
		end
		sway_angle = vm.f32(sway_angle + sway_speed)
		if sway_angle > vm.f32(0.09817477) then
			sway_angle = vm.f32(0.09817477)
			sway_speed = vm.f32(sway_speed * -1.0)
		end
		if sway_angle < vm.f32(-0.09817477) then
			sway_angle = vm.f32(-0.09817477)
			sway_speed = vm.f32(sway_speed * -1.0)
		end
		advance_orbit(sway_angle)
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores damage so the orb stays in place.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores knockdown so the orb stays in place.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores guard reactions.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores the first kind of dodge reaction.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores the second kind of dodge reaction.
function script.on_dodge_2() end

--- Fades the orb out, releases its light effect and plays the death animation.
function script.on_death()
	local value: s32 = 0
	death.begin()
	monster.set_variable(27, 128)
	monster.set_monster_attributes(2, 1)
	monster.set_monster_attributes(4, 0)
	monster.set_monster_attributes(8, 0)
	monster.set_monster_attributes(16, 0)
	value = monster.get_variable(24) or value
	monster.finish_effect(value)
	monster.set_motion("死に入り", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("死に", -1, 4)
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
	death.play_effects()
end

--- Plays the struggling motion while the orb is held.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Recovers the orb after a throw and stands it back up.
function script.on_land()
	combat.finish_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	state.do_nothing_hook()
	return 1
end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores stun so the orb stays in place.
function script.on_stun() end

return script
