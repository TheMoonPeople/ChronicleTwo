--!strict
--- Controls the RoBomb, which lobs itself at the target, pulses and explodes.

local vm = require("@lib/vm")
local movement = require("@lib/monster/movement")

--- Moves the monster along a gravity arc between two positions over a number of frames.
local function fly_along_arc(start_x: f32, start_y: f32, start_z: f32, end_x: f32, end_y: f32, end_z: f32, gravity: f32, frame_count: f32)
	local frame: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local vertical_velocity: f32 = 0
	frame = 0
	while frame < frame_count do
		vertical_velocity = vm.f32(
			vm.fdiv(vm.f32(vm.f32(vm.f32(end_y - start_y) * 2.0) - vm.f32(vm.f32(gravity * frame_count) * frame_count)), vm.f32(frame_count * 2.0))
		)
		y = start_y
		for i = 0, frame - 1 do
			vertical_velocity = vm.f32(vertical_velocity + gravity)
			y = vm.f32(y + vertical_velocity)
		end
		x = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(end_x - start_x) * frame), frame_count)) + start_x)
		z = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(end_z - start_z) * frame), frame_count)) + start_z)
		if y < end_y then
			y = end_y
		end
		monster.set_position(x, y, z)
		frame = vm.i32(frame + 1)
		vm.wait()
	end
end

--- Explodes in a missile blast that carries the monster's attack power.
local function on_death()
	local attack_power: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local was_caught: s32 = 0
	monster.stop_moving()
	movement.stop_turning()
	monster.set_monster_attributes(86, 1)
	monster.set_life_int(0)
	monster.start_death()
	monster.spawn_death_effects()
	attack_power = monster.get_attack_power_1() or attack_power
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("ロボミサイル爆発")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_value(-1, 0, attack_power)
	was_caught = monster.get_variable(1) or was_caught
	if was_caught == 1 then
		monster.set_effect_owner(-1, 0)
	end
	monster.play_sound(8)
	while true do
		vm.wait()
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the flower object and clears the launch state.
function script.init()
	monster.register_entry_object(0, "hana_obj")
	monster.set_clip_distance(120.0)
	monster.set_monster_attributes(1, 1)
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
end

--- Lobs the bomb toward the target, then pulses and explodes.
function script.loop()
	local launch_state: s32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local landing_x: f32 = 0
	local landing_y: f32 = 0
	local landing_z: f32 = 0
	local distance: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local gravity: f32 = 0
	local flight_frames: f32 = 0
	local pulse_scale: f32 = 0
	local pulse_phase: f32 = 0
	local frame: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	vm.wait()
	launch_state = monster.get_variable(0) or launch_state
	if launch_state == 0 then
		monster.set_variable(0, 1)
		monster.set_variable(1, 0)
		monster.set_monster_attributes(4, 1)
		do
			local out1, out2, out3 = monster.get_position_3()
			start_x = out1 or start_x
			start_y = out2 or start_y
			start_z = out3 or start_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(offset_x, offset_y, offset_z, start_x, start_y, start_z)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
		end
		distance = monster.get_vector_length(offset_x, 0.0, offset_z) or distance
		distance = monster.get_target_distance() or distance
		if distance < 80.0 then
			distance = 80.0
		end
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, distance)
			landing_x = out1 or landing_x
			landing_y = out2 or landing_y
			landing_z = out3 or landing_z
		end
		landing_y = 0.0
		gravity = vm.f32(vm.f32(-0.8) + vm.f32(distance * vm.f32(0.0001)))
		flight_frames = vm.f32(vm.f32(distance / 16.0) + 6.0)
		fly_along_arc(start_x, start_y, start_z, landing_x, landing_y, landing_z, gravity, flight_frames)
		monster.play_sound(6)
		monster.set_monster_attributes(4, 0)
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, 16.0)
			landing_x = out1 or landing_x
			landing_y = out2 or landing_y
			landing_z = out3 or landing_z
		end
		landing_y = vm.f32(3.2)
		monster.move_toward_position(landing_x, landing_y, landing_z, 3.2, 3.2)
	end
	pulse_phase = 0.0
	frame = 0
	while frame < 80 do
		if frame >= 50 then
			if frame == 50 then
				monster.start_palette_pulse(128, 128, 255, 4, 30)
			end
			pulse_scale = vm.f32(vm.f32(vm.sin(pulse_phase) / 10.0) + 1.0)
			pulse_phase = vm.f32(pulse_phase + vm.f32(0.4))
			if pulse_phase >= vm.f32(3.1415927) then
				monster.play_sound(7)
				pulse_phase = 0.0
			end
			monster.set_scale(pulse_scale, pulse_scale, pulse_scale)
		end
		frame = frame + 1
		vm.wait()
	end
	on_death()
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
--- Reacts to a staggering hit.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Reacts to a knockdown hit.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Reacts to guarding against a hit.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Reacts to dodging the first kind of attack.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Reacts to dodging the second kind of attack.
function script.on_dodge_2() end

script.on_death = on_death

--- Holds the bomb still while it is carried.
function script.on_caught()
	monster.stop_moving()
	monster.set_monster_attributes(4, 0)
	monster.set_monster_attributes(32, 1)
	monster.stop_palette_pulse()
	monster.set_variable(1, 1)
	while true do
		vm.wait()
	end
end

--- Explodes when it lands after a throw.
function script.on_land()
	monster.stop_moving()
	monster.end_throw()
	monster.set_monster_attributes(32, 0)
	on_death()
end

--- Stuns the monster.
script.on_stun = on_death

return script
