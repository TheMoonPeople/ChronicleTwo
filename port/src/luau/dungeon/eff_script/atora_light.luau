--!strict
--- Shoots a stream of element-coloured sparks from the owner toward a target character and bursts them on arrival.

local vm = require("@lib/vm")

--- Returns 1 when the given point is within reach of the targeted character, otherwise 0.
local function has_reached_character(unused_character_id: any, from_x: f32, from_y: f32, from_z: f32)
	local distance: f32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local character_id: f32 = 0
	character_id = effect.get_script_value_float(1) or character_id
	do
		local out1, out2, out3 = effect.get_scene_character_position(character_id)
		character_x = out1 or character_x
		character_y = out2 or character_y
		character_z = out3 or character_z
	end
	distance = effect.get_distance_between(from_x, from_y, from_z, character_x, character_y + 50.0, character_z) or distance
	if distance <= vm.f32(7.6) then
		return 1
	end
	return 0
end

--- Tints a sprite red, blue or yellow by the effect element and gives it the supplied alpha.
local function set_sprite_element_color(sprite_index: s32, alpha: f32)
	local color_x: f32 = 0
	local color_y: f32 = 0
	local color_z: f32 = 0
	local element: s32 = 0
	element = effect.get_script_value(0) or element
	if element == 0 then
		do
			local out1, out2, out3 = effect.copy_vector(255.0, 0.0, 0.0)
			color_x = out1 or color_x
			color_y = out2 or color_y
			color_z = out3 or color_z
		end
	end
	if element == 1 then
		do
			local out1, out2, out3 = effect.copy_vector(0.0, 0.0, 255.0)
			color_x = out1 or color_x
			color_y = out2 or color_y
			color_z = out3 or color_z
		end
	end
	if element == 2 then
		do
			local out1, out2, out3 = effect.copy_vector(255.0, 255.0, 0.0)
			color_x = out1 or color_x
			color_y = out2 or color_y
			color_z = out3 or color_z
		end
	end
	effect.set_sprite_color(sprite_index, color_x, color_y, color_z, alpha)
end

--- Shows a spark sprite at the start point and sends it flying toward a character at a fixed speed.
local function launch_spark_toward_character(sprite_index: s32, character_id: s32, start_x: f32, start_y: f32, start_z: f32)
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_scene_character_position(character_id)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	velocity_y = vm.f32(velocity_y + 50.0)
	do
		local out1, out2, out3 = effect.subtract_vectors(velocity_x, velocity_y, velocity_z, start_x, start_y, start_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.normalize_vector(velocity_x, velocity_y, velocity_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 3.8)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.set_sprite_visible(sprite_index, 1)
	effect.set_sprite_position(sprite_index, start_x, start_y, start_z)
	set_sprite_element_color(sprite_index, 0.0)
	effect.set_sprite_velocity(sprite_index, velocity_x, velocity_y, velocity_z)
	effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, 3.0)
	effect.set_sprite_scale(sprite_index, 1.0, 1.0, 1.0)
	effect.set_sprite_scale_velocity(sprite_index, 0.02, 0.02)
end

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Spawns sparks from the owner that fly toward the targeted character, recycling a pool of sprites and retiring those that arrive or fade.
function script.on_start()
	local spark_x: f32 = 0
	local spark_y: f32 = 0
	local spark_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local color_red: f32 = 0
	local color_green: f32 = 0
	local color_blue: f32 = 0
	local alpha: f32 = 0
	local owner_x: f32 = 0
	local owner_y: f32 = 0
	local owner_z: f32 = 0
	local owner_id: s32 = 0
	local target_id: s32 = 0
	local status: s32 = 0
	local element: s32 = 0
	local next_spark_index: s32 = 0
	element = 0
	target_id = 0
	status = 0
	status = effect.allocate_sprites_2(16) or status
	if status == 0 then
		return
	end
	effect.set_sprite_texture("b08_ex")
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		spark_x = out1 or spark_x
		spark_y = out2 or spark_y
		spark_z = out3 or spark_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	owner_id = effect.get_owner_character() or owner_id
	element = effect.get_script_value(0) or element
	target_id = effect.get_script_value(1) or target_id
	status = effect.get_script_value(7) or status
	do
		local out1, out2, out3 = effect.normalize_vector(direction_x, direction_y, direction_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	if element == 0 then
		do
			local out1, out2, out3 = effect.copy_vector(255.0, 0.0, 0.0)
			color_red = out1 or color_red
			color_green = out2 or color_green
			color_blue = out3 or color_blue
		end
	end
	if element == 1 then
		do
			local out1, out2, out3 = effect.copy_vector(0.0, 0.0, 255.0)
			color_red = out1 or color_red
			color_green = out2 or color_green
			color_blue = out3 or color_blue
		end
	end
	if element == 2 then
		do
			local out1, out2, out3 = effect.copy_vector(255.0, 255.0, 0.0)
			color_red = out1 or color_red
			color_green = out2 or color_green
			color_blue = out3 or color_blue
		end
	end
	alpha = 12.0
	effect.reset_sprites(0, 15)
	effect.set_sprite_blend_mode(0, 2, 15)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 64.0, 64.0, 15)
	effect.set_sprite_size(0, 24.0, 24.0, 15)
	effect.set_sprite_visible(0, 0, 15)
	effect.set_sprite_position(0, 0.0, 0.0, 0.0, 15)
	effect.set_sprite_color(0, color_red, color_green, color_blue, alpha, 15)
	effect.reset_sprites(15, 1)
	effect.set_sprite_blend_mode(15, 2, 1)
	effect.set_sprite_texture_rect(15, 0.0, 0.0, 64.0, 64.0, 1)
	effect.set_sprite_size(15, 48.0, 48.0, 1)
	effect.set_sprite_visible(15, 1, 1)
	effect.set_sprite_position(15, 0.0, 0.0, 0.0, 1)
	effect.set_sprite_acceleration(15, 0.0, 0.0, 0.0, 1)
	effect.set_sprite_color(15, color_red, color_green, color_blue, alpha, 1)
	next_spark_index = 0
	while true do
		vm.wait()
		do
			local out1, out2, out3 = effect.get_scene_character_position(owner_id)
			owner_x = out1 or owner_x
			owner_y = out2 or owner_y
			owner_z = out3 or owner_z
		end
		effect.set_sprite_position(15, owner_x, owner_y, owner_z)
		target_id = effect.get_script_value(1) or target_id
		for index = 0, 14 do
			status = effect.is_sprite_visible(index) or status
			if status == 1 then
				do
					local out1, out2, out3 = effect.get_sprite_position(index)
					spark_x = out1 or spark_x
					spark_y = out2 or spark_y
					spark_z = out3 or spark_z
				end
				do
					local out1, out2, out3, out4 = effect.get_sprite_color(index)
					color_red = out1 or color_red
					color_green = out2 or color_green
					color_blue = out3 or color_blue
					alpha = out4 or alpha
				end
				if has_reached_character(target_id, spark_x, spark_y, spark_z) ~= 0 then
					effect.set_sprite_visible(index, 0)
				end
				if alpha > 64.0 then
					set_sprite_element_color(index, 64.0)
					effect.set_sprite_color_velocity(index, 0.0, 0.0, 0.0, -2.5)
				end
				if alpha <= 0.0 then
					effect.set_sprite_visible(index, 0)
				end
			end
		end
		status = effect.get_script_value(7) or status
		if status == 0 then
			continue
		end
		launch_spark_toward_character(next_spark_index, target_id, owner_x, owner_y, owner_z)
		next_spark_index = next_spark_index + 1
		if next_spark_index >= 15 then
			next_spark_index = 0
		end
	end
end

--- Fades out the sparks and flares a burst at the target character.
function script.on_finish()
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local color_red: f32 = 0
	local color_green: f32 = 0
	local color_blue: f32 = 0
	local alpha: f32 = 0
	local element: s32 = 0
	local target_id: s32 = 0
	local index: s32 = 0
	element = effect.get_script_value(0) or element
	target_id = effect.get_script_value(1) or target_id
	effect.set_sprite_velocity(0, 0.0, 0.0, 0.0, 15)
	effect.set_sprite_color_velocity(0, 0.0, 0.0, 0.0, -1.5, 15)
	do
		local out1, out2, out3 = effect.get_scene_character_position(target_id)
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	target_y = vm.f32(target_y + 55.0)
	if element == 0 then
		do
			local out1, out2, out3 = effect.copy_vector(255.0, 0.0, 0.0)
			color_red = out1 or color_red
			color_green = out2 or color_green
			color_blue = out3 or color_blue
		end
	end
	if element == 1 then
		do
			local out1, out2, out3 = effect.copy_vector(0.0, 0.0, 255.0)
			color_red = out1 or color_red
			color_green = out2 or color_green
			color_blue = out3 or color_blue
		end
	end
	if element == 2 then
		do
			local out1, out2, out3 = effect.copy_vector(255.0, 255.0, 0.0)
			color_red = out1 or color_red
			color_green = out2 or color_green
			color_blue = out3 or color_blue
		end
	end
	effect.set_sprite_position(15, target_x, target_y, target_z)
	effect.set_sprite_color(15, color_red, color_green, color_blue, 0.0)
	effect.set_sprite_color_velocity(15, 0.0, 0.0, 0.0, 2.0)
	effect.set_sprite_scale(15, 1.0, 1.0, 1.0)
	effect.set_sprite_scale_velocity(15, 0.1, 0.0)
	for frame = 0, 89 do
		index = 0
		while index < 15 do
			do
				local out1, out2, out3, out4 = effect.get_sprite_color(index)
				color_red = out1 or color_red
				color_green = out2 or color_green
				color_blue = out3 or color_blue
				alpha = out4 or alpha
			end
			if alpha <= 0.0 then
				effect.set_sprite_visible(index, 0)
			end
			index = index + 1
			if frame == 45 then
				effect.set_sprite_scale_velocity(15, -0.1, 0.8)
			end
			do
				local out1, out2, out3, out4 = effect.get_sprite_color(15)
				color_red = out1 or color_red
				color_green = out2 or color_green
				color_blue = out3 or color_blue
				alpha = out4 or alpha
			end
			if alpha > 64.0 then
				effect.set_sprite_color(15, color_red, color_green, color_blue, 64.0)
				effect.set_sprite_color_velocity(15, 0.0, 0.0, 0.0, -2.0)
			end
		end
		vm.wait()
	end
end

return script
