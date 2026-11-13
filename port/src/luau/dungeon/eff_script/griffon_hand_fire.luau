--!strict
--- Emits flames from both hands of the owning character.

local vm = require("@lib/vm")

--- Starts a flame sprite near a hand position that rises, shrinks and fades in.
local function spawn_flame_particle(sprite_index: s32, hand_x: f32, hand_y: f32, hand_z: f32)
	local particle_x: f32 = 0
	local particle_y: f32 = 0
	local particle_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local angle: f32 = 0
	local random_amount: f32 = 0
	local speed_scale: f32 = 0
	effect.get_owner_character()
	angle = 0.0
	random_amount = 0.0
	speed_scale = vm.f32(1.2)
	angle = effect.get_random_number(6.2831855) or angle
	random_amount = effect.get_random_number(1.0) or random_amount
	speed_scale = effect.get_random_number(0.5) or speed_scale
	speed_scale = vm.f32(speed_scale + vm.f32(0.8))
	random_amount = vm.f32(random_amount + 5.0)
	velocity_x = 0.0
	velocity_y = random_amount
	velocity_z = 0.0
	do
		local out1, out2, out3 = effect.normalize_vector(velocity_x, velocity_y, velocity_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, speed_scale)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	angle = effect.get_random_number(6.2831855) or angle
	random_amount = effect.get_random_number(5.0) or random_amount
	random_amount = vm.f32(random_amount + 3.0)
	particle_x = vm.f32(hand_x + vm.f32(vm.sin(angle) * random_amount))
	particle_y = hand_y
	particle_z = vm.f32(hand_z + vm.f32(vm.cos(angle) * random_amount))
	velocity_y = vm.f32(velocity_y + 1.0)
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, speed_scale)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.set_sprite_visible(sprite_index, 1)
	effect.set_sprite_position(sprite_index, particle_x, particle_y - 7.0, particle_z)
	effect.set_sprite_scale(sprite_index, 1.0, 1.0)
	effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0)
	effect.set_sprite_rotation(sprite_index, 0.25)
	effect.set_sprite_velocity(sprite_index, velocity_x, velocity_y, velocity_z)
	effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, 4.0)
	effect.set_sprite_scale_velocity(sprite_index, -0.07, -0.07)
end

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Alternately spawns flame sprites at the owner's hands each frame and retires faded ones.
function script.on_start()
	local hand_x: f32 = 0
	local hand_y: f32 = 0
	local hand_z: f32 = 0
	local scale_x: f32 = 0
	local alpha: f32 = 0
	local owner_id: s32 = 0
	local status: s32 = 0
	local next_sprite_index: s32 = 0
	status = 0
	status = effect.allocate_sprites_2(160) or status
	if status == 0 then
		return
	end
	effect.set_sprite_texture("b10a_handfire")
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		hand_x = out1 or hand_x
		hand_y = out2 or hand_y
		hand_z = out3 or hand_z
	end
	effect.get_second_work_vector()
	owner_id = effect.get_owner_character() or owner_id
	effect.reset_sprites(0, 160)
	effect.set_sprite_blend_mode(0, 2, 160)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 128.0, 128.0, 160)
	effect.set_sprite_size(0, 32.0, 32.0, 160)
	effect.set_sprite_visible(0, 0, 160)
	effect.set_sprite_position(0, 0.0, 0.0, 0.0, 160)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 160)
	while true do
		for index = 0, 159 do
			do
				local out1, _ = effect.get_sprite_scale(index)
				scale_x = out1 or scale_x
			end
			do
				local _, _, _, out4 = effect.get_sprite_color(index)
				alpha = out4 or alpha
			end
			if alpha > 64.0 then
				effect.set_sprite_color(index, 128.0, 128.0, 128.0, 16.0)
				effect.set_sprite_color_velocity(index, 128.0, 128.0, 128.0, -1.2)
			end
			if alpha <= 0.0 or scale_x < 0.0 then
				effect.set_sprite_visible(index, 0)
			end
		end
		for i = 0, 3 do
			if vm.imod(next_sprite_index, 2) == 0 then
				do
					local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "dcol_r")
					hand_x = out1 or hand_x
					hand_y = out2 or hand_y
					hand_z = out3 or hand_z
				end
			end
			if vm.imod(next_sprite_index, 2) == 1 then
				do
					local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "dcol_l")
					hand_x = out1 or hand_x
					hand_y = out2 or hand_y
					hand_z = out3 or hand_z
				end
			end
			spawn_flame_particle(next_sprite_index, hand_x, hand_y, hand_z)
			next_sprite_index = next_sprite_index + 1
			if next_sprite_index >= 160 then
				next_sprite_index = 0
			end
		end
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
