--!strict
--- Controls a pirate bomb that is lobbed at the target, pulses and explodes.

local vm = require("@lib/vm")
local movement = require("@lib/monster/movement")

--- Explodes in a pirate bomb blast carrying the monster's attack power.
local function on_death()
	local attack: s32 = 0
	local explosion_x: f32 = 0
	local explosion_y: f32 = 0
	local explosion_z: f32 = 0
	monster.end_throw()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_monster_attributes(86, 1)
	monster.set_life_int(0)
	monster.start_death()
	monster.spawn_death_effects()
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_position_3()
		explosion_x = out1 or explosion_x
		explosion_y = out2 or explosion_y
		explosion_z = out3 or explosion_z
	end
	if explosion_x == 0.0 and explosion_y == -2.0 and explosion_z == 0.0 then
		do
			local out1, out2, out3 = monster.get_target_position()
			explosion_x = out1 or explosion_x
			explosion_y = out2 or explosion_y
			explosion_z = out3 or explosion_z
		end
		explosion_y = vm.f32(explosion_y + 25.0)
	end
	monster.play_sound(8)
	monster.create_effect_1("海賊爆弾爆発")
	monster.set_effect_first_vector(-1, explosion_x, explosion_y, explosion_z)
	monster.set_effect_value(-1, 0, attack)
	monster.play_sound(8)
	while true do
		vm.wait()
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Clears the launch state.
function script.init()
	monster.set_monster_attributes(1, 1)
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 0)
	monster.set_clip_distance(10000000.0)
end

--- Lobs the bomb toward the target, then pulses and explodes.
function script.loop()
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local target_distance: f32 = 0
	local scale: f32 = 0
	local vertical_offset: f32 = 0
	local launch_speed: f32 = 0
	local flight_time: f32 = 0
	local launch_angle: f32 = 0
	local gravity: f32 = 0
	local frame: s32 = 0
	local ground_distance: f32 = 0
	local pulse_scale: f32 = 0
	local pulse_phase: f32 = 0
	local fuse_frames: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	vm.wait()
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	target_distance = monster.get_target_distance() or target_distance
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, pos_x, pos_y, pos_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(direction_x, direction_y, direction_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	ground_distance = monster.get_distance_between(pos_x, 0.0, pos_z, target_x, 0.0, target_z) or ground_distance
	if ground_distance < 30.0 then
		do
			local out1, out2, out3 = monster.copy_vector(0.0, 1.0, 0.0)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		monster.set_position(pos_x, pos_y - 15.0, pos_z)
		pos_y = vm.f32(pos_y - 15.0)
	end
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(16, 1)
	launch_speed = 2.5
	launch_angle = vm.f32(0.3926991)
	gravity = vm.f32(0.27)
	monster.stop_moving()
	frame = 0
	while frame < 120 do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 30.0 then
			on_death()
		end
		flight_time = frame
		launch_speed = vm.f32(launch_speed - vm.f32(0.04))
		scale = vm.f32(vm.f32(launch_speed * vm.cos(launch_angle)) * flight_time)
		vertical_offset =
			vm.f32(vm.f32(vm.f32(launch_speed * vm.sin(launch_angle)) * flight_time) - vm.f32(vm.f32(vm.f32(gravity * flight_time) * flight_time) / 2.0))
		do
			local out1, out2, out3 = monster.copy_vector(direction_x, direction_y, direction_z)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(offset_x, offset_y, offset_z, scale)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
		end
		offset_y = vm.f32(1.0 * vertical_offset)
		do
			local out1, out2, out3 = monster.add_vectors(pos_x, pos_y, pos_z, offset_x, offset_y, offset_z)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		if launch_speed < 0.0 then
			break
		elseif pos_y < target_y then
			break
		else
			if frame == 5 then
				monster.set_monster_attributes(16, 0)
			end
			monster.set_position(pos_x, pos_y, pos_z)
			vm.wait()
			frame = frame + 1
		end
	end
	monster.play_sound(6)
	monster.set_monster_attributes(4, 0)
	pulse_phase = 0.0
	fuse_frames = 0
	while fuse_frames < 195 do
		if fuse_frames >= 165 then
			if fuse_frames == 165 then
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
		fuse_frames = monster.get_variable(2) or fuse_frames
		fuse_frames = vm.i32(fuse_frames + 1)
		monster.set_variable(2, fuse_frames)
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

--- Flashes the bomb until the fuse runs out and then explodes.
function script.on_caught()
	local red: f32 = 0
	local green: f32 = 0
	local blue: f32 = 0
	local alpha: f32 = 0
	local pulse_phase: f32 = 0
	local fuse_frames: s32 = 0
	monster.stop_moving()
	monster.set_monster_attributes(4, 0)
	monster.stop_palette_pulse()
	monster.set_variable(1, 1)
	pulse_phase = 0.0
	fuse_frames = 0
	red = 128.0
	green = 8.0
	blue = 8.0
	alpha = 128.0
	fuse_frames = monster.get_variable(2) or fuse_frames
	while fuse_frames < 195 do
		if fuse_frames >= 165 then
			if fuse_frames == 165 then
				monster.set_model_lighting(0)
			end
			red = 128.0
			green = 128.0
			blue = 128.0
			if vm.imod(fuse_frames, 6) == 0 then
				monster.play_sound(7)
				red = 196.0
				green = 128.0
			end
			if vm.imod(fuse_frames, 6) == 2 then
				red = 172.0
				green = 172.0
			end
			if vm.imod(fuse_frames, 6) == 4 then
				red = 168.0
				green = 168.0
			end
			monster.set_model_color(red, green, blue, alpha)
			pulse_phase = vm.f32(pulse_phase + vm.f32(0.4))
			if pulse_phase >= vm.f32(3.1415927) then
				monster.play_sound(7)
				pulse_phase = 0.0
			end
		end
		fuse_frames = monster.get_variable(2) or fuse_frames
		fuse_frames = vm.i32(fuse_frames + 1)
		monster.set_variable(2, fuse_frames)
		vm.wait()
	end
	on_death()
	while true do
		vm.wait()
	end
end

--- Explodes when it lands after a throw.
function script.on_land()
	monster.stop_moving()
	monster.end_throw()
	on_death()
end

--- Stuns the monster.
script.on_stun = on_death

return script
