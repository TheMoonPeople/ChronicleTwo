--!strict
--- Keeps emitting smoke puffs at the owner character while the effect runs.

local vm = require("@lib/vm")
local particles = require("@lib/effect/particles")
local timing = require("@lib/effect/timing")

--- Places one smoke sprite at a random offset around a position and sets it rising and fading.
local function spawn_smoke_sprite(sprite_index: s32, origin_x: f32, origin_y: f32, origin_z: f32, sway_angle: f32, range: f32)
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local sway_factor: f32 = 0
	local radius: f32 = 0
	local angle_radians: f32 = 0
	local spin_speed: f32 = 0
	local rise_speed: f32 = 0
	radius = effect.get_random_number(range) or radius
	angle_radians = effect.get_random_number(360.0) or angle_radians
	spin_speed = effect.get_random_number(0.01) or spin_speed
	rise_speed = effect.get_random_number(1.0) or rise_speed
	rise_speed = vm.f32(rise_speed + 4.0)
	angle_radians = vm.f32(vm.f32(angle_radians / 180.0) * vm.f32(3.1415927))
	sway_factor = vm.sin(sway_angle)
	position_x = vm.f32(origin_x + vm.f32(vm.sin(angle_radians) * radius))
	position_y = origin_y
	position_z = vm.f32(origin_z + vm.f32(vm.cos(angle_radians) * radius))
	velocity_x = vm.f32(vm.f32(0.4) * sway_factor)
	velocity_y = rise_speed
	velocity_z = vm.f32(vm.f32(0.4) * sway_factor)
	effect.set_sprite_visible(sprite_index, 1)
	effect.set_sprite_position(sprite_index, position_x, position_y, position_z)
	effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0)
	effect.set_sprite_velocity(sprite_index, velocity_x, velocity_y, velocity_z)
	effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, 2.0)
	effect.set_sprite_angular_velocity(sprite_index, spin_speed)
end

local script = {}

--- Runs when the script loads; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Allocates the smoke sprites, then emits smoke puffs and sprite puffs around the owner every few frames and hides faded sprites.
function script.on_start()
	local owner_x: f32 = 0
	local owner_y: f32 = 0
	local owner_z: f32 = 0
	local alpha: f32 = 0
	local owner_id: s32 = 0
	local smoke_index: s32 = 0
	local sprite_index: s32 = 0
	local sprites_allocated: s32 = 0
	local tick: s32 = 0
	local spawn_count: s32 = 0
	owner_id = effect.get_owner_character() or owner_id
	sprites_allocated = effect.allocate_sprites_2(16) or sprites_allocated
	if sprites_allocated == 0 then
		return
	end
	effect.set_sprite_texture("effect00")
	effect.reset_sprites(0, 15)
	effect.set_sprite_blend_mode(0, 2, 15)
	effect.set_sprite_texture_rect(0, 0.1, 161.0, 95.0, 95.0, 15)
	effect.set_sprite_size(0, 128.0, 128.0, 15)
	effect.set_sprite_visible(0, 0, 15)
	effect.set_sprite_position(0, 0.0, 0.0, 0.0, 15)
	effect.reset_sprites(15, 1)
	effect.set_sprite_blend_mode(15, 2, 1)
	effect.set_sprite_texture_rect(15, 161.0, 161.0, 95.0, 95.0, 1)
	effect.set_sprite_size(15, 194.0, 194.0, 1)
	effect.set_sprite_visible(15, 0, 1)
	effect.set_sprite_position(15, 0.0, 0.0, 0.0, 1)
	tick = 0
	smoke_index = 0
	sprite_index = 15
	while true do
		for index = 0, 15 do
			do
				local _, _, _, out4 = effect.get_sprite_color(index)
				alpha = out4 or alpha
			end
			if index < 15 then
				if alpha > 96.0 then
					effect.set_sprite_color(index, 96.0, 96.0, 96.0, 96.0)
					effect.set_sprite_color_velocity(index, 0.0, 0.0, 0.0, -0.4)
				end
				if alpha <= 0.0 then
					effect.set_sprite_visible(index, 0)
				end
			else
				if alpha > 64.0 then
					effect.set_sprite_color(index, 64.0, 64.0, 64.0, 64.0)
					effect.set_sprite_color_velocity(index, 0.0, 0.0, 0.0, -0.4)
				end
				if alpha <= 0.0 then
					effect.set_sprite_visible(index, 0)
				end
			end
		end
		do
			local out1, out2, out3 = effect.get_scene_character_position(owner_id)
			owner_x = out1 or owner_x
			owner_y = out2 or owner_y
			owner_z = out3 or owner_z
		end
		spawn_count = 0
		particles.spawn_smoke(smoke_index, owner_x, owner_y, owner_z, 0.0, 0.0)
		smoke_index = smoke_index + 1
		if smoke_index >= 15 then
			smoke_index = 0
		end
		spawn_count = spawn_count + 1
		if vm.imod(tick, 4) == 0 then
			spawn_smoke_sprite(sprite_index, owner_x, owner_y, owner_z, 0.0, 0.0)
		end
		if vm.imod(tick, 4) == 0 then
			sprite_index = 0
			if sprite_index >= 16 then
				sprite_index = 15
				tick = 0
			end
		end
		timing.wait_frames(3)
		tick = vm.i32(tick + 1)
		vm.wait()
	end
	effect.set_sprite_visible(0, 0, 16)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Empty finish handler; the effect needs no cleanup.
function script.on_finish() end

return script
