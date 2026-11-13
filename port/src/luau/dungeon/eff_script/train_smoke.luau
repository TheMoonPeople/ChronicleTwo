--!strict
--- Pours a continuous plume of smoke from a train chimney object.

local vm = require("@lib/vm")
local particles = require("@lib/effect/particles")
local timing = require("@lib/effect/timing")

--- Launches one smoke particle sprite at a random spot around a point, drifting upward.
local function spawn_smoke_particle(sprite_index: s32, origin_x: f32, origin_y: f32, origin_z: f32, wind_angle: f32, range: f32)
	local particle_x: f32 = 0
	local particle_y: f32 = 0
	local particle_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local drift_factor: f32 = 0
	local offset_distance: f32 = 0
	local angle: f32 = 0
	local spin_speed: f32 = 0
	local rise_speed: f32 = 0
	offset_distance = effect.get_random_number(range) or offset_distance
	angle = effect.get_random_number(360.0) or angle
	spin_speed = effect.get_random_number(0.01) or spin_speed
	rise_speed = effect.get_random_number(1.0) or rise_speed
	rise_speed = vm.f32(rise_speed + 2.0)
	angle = vm.f32(vm.f32(angle / 180.0) * vm.f32(3.1415927))
	drift_factor = vm.sin(wind_angle)
	particle_x = vm.f32(origin_x + vm.f32(vm.sin(angle) * offset_distance))
	particle_y = origin_y
	particle_z = vm.f32(origin_z + vm.f32(vm.cos(angle) * offset_distance))
	velocity_x = vm.f32(vm.f32(0.4) * drift_factor)
	velocity_y = rise_speed
	velocity_z = vm.f32(vm.f32(0.4) * drift_factor)
	effect.set_sprite_visible(sprite_index, 1)
	effect.set_sprite_position(sprite_index, particle_x, particle_y, particle_z)
	effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0)
	effect.set_sprite_velocity(sprite_index, velocity_x, velocity_y, velocity_z)
	effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, 2.0)
	effect.set_sprite_angular_velocity(sprite_index, spin_speed)
end

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Keeps spawning smoke particles at the chimney while the script active flag is set and fades old ones out.
function script.on_start()
	local smoke_x: f32 = 0
	local smoke_y: f32 = 0
	local smoke_z: f32 = 0
	local color_w: f32 = 0
	local smoke_index: s32 = 0
	local puff_index: s32 = 0
	local has_sprites: s32 = 0
	local tick: s32 = 0
	local object_id: s32 = 0
	local is_active: s32 = 0
	is_active = 1
	effect.set_script_value_int(1, 1)
	object_id = effect.get_script_value(0) or object_id
	has_sprites = effect.allocate_sprites_2(181) or has_sprites
	if has_sprites == 0 then
		return
	end
	effect.set_sprite_texture("kemuri_train")
	effect.reset_sprites(0, 180)
	effect.set_sprite_blend_mode(0, 1, 180)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 64.0, 64.0, 180)
	effect.set_sprite_size(0, 64.0, 64.0, 180)
	effect.set_sprite_visible(0, 0, 180)
	effect.set_sprite_position(0, 0.0, 0.0, 0.0, 180)
	effect.reset_sprites(180, 1)
	effect.set_sprite_blend_mode(180, 1, 1)
	effect.set_sprite_texture_rect(180, 0.0, 0.0, 64.0, 64.0, 1)
	effect.set_sprite_size(180, 194.0, 194.0, 1)
	effect.set_sprite_visible(180, 0, 1)
	effect.set_sprite_position(180, 0.0, 0.0, 0.0, 1)
	tick = 0
	smoke_index = 0
	puff_index = 180
	while true do
		for sprite_index = 0, 180 do
			do
				local _, _, _, out4 = effect.get_sprite_color(sprite_index)
				color_w = out4 or color_w
			end
			if sprite_index < 180 then
				if color_w > 96.0 then
					effect.set_sprite_color(sprite_index, 96.0, 96.0, 96.0, 96.0)
					effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, -0.4)
				end
				if color_w <= 0.0 then
					effect.set_sprite_visible(sprite_index, 0)
				end
			else
				if color_w > 64.0 then
					effect.set_sprite_color(sprite_index, 64.0, 64.0, 64.0, 64.0)
					effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, -0.4)
				end
				if color_w <= 0.0 then
					effect.set_sprite_visible(sprite_index, 0)
				end
			end
		end
		is_active = effect.get_script_value(1) or is_active
		if is_active ~= 0 then
			do
				local out1, out2, out3 = effect.get_event_object_position(object_id)
				smoke_x = out1 or smoke_x
				smoke_y = out2 or smoke_y
				smoke_z = out3 or smoke_z
			end
			do
				local out1, out2, out3 = effect.add_vectors(smoke_x, smoke_y, smoke_z, 0.0, 189.914, 30.725)
				smoke_x = out1 or smoke_x
				smoke_y = out2 or smoke_y
				smoke_z = out3 or smoke_z
			end
			for i = 0, 3 do
				particles.spawn_smoke(smoke_index, smoke_x, smoke_y, smoke_z, 0.0, 45.0)
				smoke_index = smoke_index + 1
				if smoke_index >= 180 then
					smoke_index = 0
				end
			end
			if vm.imod(tick, 4) == 0 then
				spawn_smoke_particle(puff_index, smoke_x, smoke_y, smoke_z, 0.0, 0.0)
			end
			puff_index = 0
			if puff_index >= 181 then
				puff_index = 180
				tick = 0
			end
		end
		timing.wait_frames(3)
		tick = vm.i32(tick + 1)
		vm.wait()
	end
	effect.set_sprite_visible(0, 0, 181)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
