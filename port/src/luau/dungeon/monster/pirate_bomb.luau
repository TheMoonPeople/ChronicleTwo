--!strict
--- Controls the pirate bomb, which is lobbed toward the player, pulses while its fuse burns and explodes on contact or when the fuse runs out.

local vm = require("@lib/vm")
local movement = require("@lib/monster/movement")

--- Detonates the bomb with the pirate bomb explosion effect at its position or the target position.
local function on_death()
	local attack: s32 = 0
	local blast_x: f32 = 0
	local blast_y: f32 = 0
	local blast_z: f32 = 0
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
		blast_x = out1 or blast_x
		blast_y = out2 or blast_y
		blast_z = out3 or blast_z
	end
	if blast_x == 0.0 and blast_y == -2.0 and blast_z == 0.0 then
		do
			local out1, out2, out3 = monster.get_target_position()
			blast_x = out1 or blast_x
			blast_y = out2 or blast_y
			blast_z = out3 or blast_z
		end
		blast_y = vm.f32(blast_y + 25.0)
	end
	monster.play_sound(8)
	monster.create_effect_1("海賊爆弾爆発")
	monster.set_effect_first_vector(-1, blast_x, blast_y, blast_z)
	monster.set_effect_value(-1, 0, attack)
	monster.play_sound(8)
	while true do
		vm.wait()
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Sets the bomb attributes and clears the monster variables.
function script.init()
	monster.set_monster_attributes(1, 1)
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 0)
	monster.set_clip_distance(10000000.0)
end

--- Lobs the bomb along an arc toward the target, then burns the fuse while pulsing and explodes.
function script.loop()
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local target_distance: f32 = 0
	local horizontal_offset: f32 = 0
	local vertical_offset: f32 = 0
	local launch_speed: f32 = 0
	local flight_time: f32 = 0
	local launch_angle_radians: f32 = 0
	local gravity: f32 = 0
	local flight_frame: s32 = 0
	local character_number: s32 = 0
	local horizontal_distance: f32 = 0
	local pulse_scale: f32 = 0
	local pulse_phase: f32 = 0
	local fuse_elapsed_frames: s32 = 0
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
		current_x = out1 or current_x
		current_y = out2 or current_y
		current_z = out3 or current_z
	end
	target_distance = monster.get_target_distance() or target_distance
	do
		local out1, out2, out3 = monster.copy_vector(target_x, target_y, target_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, current_x, current_y, current_z)
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
	horizontal_distance = monster.get_distance_between(current_x, 0.0, current_z, target_x, 0.0, target_z) or horizontal_distance
	if horizontal_distance < 30.0 then
		do
			local out1, out2, out3 = monster.copy_vector(0.0, 1.0, 0.0)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		monster.set_position(current_x, current_y - 15.0, current_z)
		current_y = vm.f32(current_y - 15.0)
	end
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(16, 1)
	launch_speed = 2.5
	launch_angle_radians = vm.f32(0.3926991)
	gravity = vm.f32(0.27)
	monster.stop_moving()
	flight_frame = 0
	while flight_frame < 120 do
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 50.0 then
			on_death()
		end
		flight_time = flight_frame
		launch_speed = vm.f32(launch_speed - vm.f32(0.04))
		horizontal_offset = vm.f32(vm.f32(launch_speed * vm.cos(launch_angle_radians)) * flight_time)
		vertical_offset =
			vm.f32(vm.f32(vm.f32(launch_speed * vm.sin(launch_angle_radians)) * flight_time) - vm.f32(vm.f32(vm.f32(gravity * flight_time) * flight_time) / 2.0))
		do
			local out1, out2, out3 = monster.copy_vector(direction_x, direction_y, direction_z)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(offset_x, offset_y, offset_z, horizontal_offset)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
		end
		offset_y = vm.f32(1.0 * vertical_offset)
		do
			local out1, out2, out3 = monster.add_vectors(current_x, current_y, current_z, offset_x, offset_y, offset_z)
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		if launch_speed < 0.0 then
			break
		elseif current_y < target_y then
			break
		else
			if flight_frame == 5 then
				monster.set_monster_attributes(16, 0)
			end
			monster.set_position(current_x, current_y, current_z)
			vm.wait()
			flight_frame = flight_frame + 1
		end
	end
	monster.play_sound(6)
	monster.set_monster_attributes(4, 0)
	character_number = monster.get_character_number() or character_number
	pulse_phase = 0.0
	fuse_elapsed_frames = 0
	while fuse_elapsed_frames < 195 do
		if fuse_elapsed_frames >= 165 then
			if fuse_elapsed_frames == 165 then
				monster.start_palette_pulse(128, 128, 255, 4, 30)
			end
			pulse_scale = vm.f32(vm.f32(vm.sin(pulse_phase) / 10.0) + 1.0)
			pulse_phase = vm.f32(pulse_phase + vm.f32(0.4))
			if pulse_phase >= vm.f32(3.1415927) then
				monster.play_monster_sound(character_number, 7)
				pulse_phase = 0.0
			end
			monster.set_scale(pulse_scale, pulse_scale, pulse_scale)
		end
		fuse_elapsed_frames = monster.get_variable(2) or fuse_elapsed_frames
		fuse_elapsed_frames = vm.i32(fuse_elapsed_frames + 1)
		monster.set_variable(2, fuse_elapsed_frames)
		vm.wait()
	end
	on_death()
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores hits so the engine skips its default flinch.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores knockdowns so the engine skips its default.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores guards so the engine skips its default.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores dodges so the engine skips its default.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores dodges so the engine skips its default.
function script.on_dodge_2() end

script.on_death = on_death

--- Burns the fuse down with a flashing color while held, then explodes.
function script.on_caught()
	local color_red: f32 = 0
	local color_green: f32 = 0
	local color_blue: f32 = 0
	local color_alpha: f32 = 0
	local pulse_phase: f32 = 0
	local fuse_elapsed_frames: s32 = 0
	local character_number: s32 = 0
	monster.stop_moving()
	monster.set_monster_attributes(4, 0)
	monster.stop_palette_pulse()
	monster.set_variable(1, 1)
	pulse_phase = 0.0
	fuse_elapsed_frames = 0
	color_red = 128.0
	color_green = 8.0
	color_blue = 8.0
	color_alpha = 128.0
	print("kita-----------\n")
	character_number = monster.get_character_number() or character_number
	fuse_elapsed_frames = monster.get_variable(2) or fuse_elapsed_frames
	while fuse_elapsed_frames < 195 do
		if fuse_elapsed_frames >= 165 then
			if fuse_elapsed_frames == 165 then
				monster.set_model_lighting(0)
			end
			color_red = 128.0
			color_green = 128.0
			color_blue = 128.0
			if vm.imod(fuse_elapsed_frames, 6) == 0 then
				monster.play_monster_sound(character_number, 7)
				color_red = 196.0
				color_green = 128.0
			end
			if vm.imod(fuse_elapsed_frames, 6) == 2 then
				color_red = 172.0
				color_green = 172.0
			end
			if vm.imod(fuse_elapsed_frames, 6) == 4 then
				color_red = 168.0
				color_green = 168.0
			end
			monster.set_model_color(color_red, color_green, color_blue, color_alpha)
			pulse_phase = vm.f32(pulse_phase + vm.f32(0.4))
			if pulse_phase >= vm.f32(3.1415927) then
				monster.play_sound(7)
				pulse_phase = 0.0
			end
		end
		fuse_elapsed_frames = monster.get_variable(2) or fuse_elapsed_frames
		fuse_elapsed_frames = vm.i32(fuse_elapsed_frames + 1)
		monster.set_variable(2, fuse_elapsed_frames)
		vm.wait()
	end
	on_death()
	while true do
		vm.wait()
	end
end

--- Explodes when the bomb lands after being thrown.
function script.on_land()
	monster.stop_moving()
	monster.end_throw()
	on_death()
end

--- Stuns the monster.
script.on_stun = on_death

return script
