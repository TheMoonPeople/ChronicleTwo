--!strict
--- Billowing smoke that appears in front of Tore.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Spawns ten smoke puffs one after another in front of the owner and fades them in and out.
function script.on_start()
	local alpha_limits: { f32 } = table.create(10, 0)
	local active_count: s32 = 0
	local frame: s32 = 0
	local user_id: s32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local puff_x: f32 = 0
	local value: f32 = 0
	local puff_z: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local color_w: f32 = 0
	user_id = effect.get_owner_character() or user_id
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, out3 = effect.get_scene_character_rotation_4(user_id)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	do
		local out1, out2, out3 = effect.get_direction_vector(rot_x, rot_y, rot_z)
		offset_x = out1 or offset_x
		offset_y = out2 or offset_y
		offset_z = out3 or offset_z
	end
	do
		local out1, out2, out3 = effect.normalize_vector(offset_x, offset_y, offset_z)
		offset_x = out1 or offset_x
		offset_y = out2 or offset_y
		offset_z = out3 or offset_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(offset_x, offset_y, offset_z, 25.0)
		offset_x = out1 or offset_x
		offset_y = out2 or offset_y
		offset_z = out3 or offset_z
	end
	effect.set_sprite_texture("smoke_tore")
	effect.allocate_sprites_1(10)
	effect.reset_sprites(0, 10)
	effect.set_sprite_blend_mode(0, 2, 10)
	effect.set_sprite_visible(0, 0, 10)
	effect.set_sprite_size(0, 32.0, 32.0, 10)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 128.0, 128.0, 10)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 10)
	effect.set_sprite_visible(0, 1, 10)
	frame = 0
	while frame < 10 do
		alpha_limits[frame + 1] = 56.0
		frame = frame + 1
	end
	frame = 0
	active_count = 0
	while frame < 90 do
		if frame > 4 * active_count and active_count < 10 then
			value = effect.get_random_number(25.0) or value
			value_2 = effect.get_random_number(360.0) or value_2
			value_3 = effect.get_random_number(10.0) or value_3
			effect.set_sprite_visible(active_count, 1)
			value_3 = vm.f32(value_3 + 5.0)
			puff_x = vm.f32(
				vm.f32(work_vect1_x + offset_x)
					+ vm.f32(value_3 * vm.sin(vm.f32(vm.f32(value_2 / 180.0) * vm.f32(3.1415927))))
			)
			value = vm.f32(vm.f32(work_vect1_y + offset_y) + -12.5)
			puff_z = vm.f32(
				vm.f32(work_vect1_z + offset_z)
					+ vm.f32(value_3 * vm.cos(vm.f32(vm.f32(value_2 / 180.0) * vm.f32(3.1415927))))
			)
			effect.set_sprite_position(active_count, puff_x, value + 10.0, puff_z)
			active_count = active_count + 1
		end
		for puff_index = 0, active_count - 1 do
			do
				local _, _, _, out4 = effect.get_sprite_color(puff_index)
				color_w = out4 or color_w
			end
			if color_w < alpha_limits[puff_index + 1] then
				effect.offset_sprite_color(puff_index, 128.0, 128.0, 128.0, 7.5)
			else
				effect.offset_sprite_color(puff_index, 128.0, 128.0, 128.0, -3.5)
				alpha_limits[puff_index + 1] = -1.0
			end
		end
		vm.wait()
		frame = frame + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
