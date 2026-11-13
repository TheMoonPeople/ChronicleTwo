--!strict
--- Plays an explosion whose size, damage and blast radius depend on a size class.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Starts the blast with the size class's damage area and ends it on the first hit or after 30 frames.
function script.on_start()
	local size_class: s32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local frame: s32 = 0
	local hit_num: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	size_class = effect.get_script_value(0) or size_class
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.set_effect_character_motion("爆発", -1, 6)
	effect.play_battle_sound(11, work_vect1_x, work_vect1_y, work_vect1_z)
	hit_num = 0
	frame = 0
	if size_class == 1 then
		effect.create_collision_primitive("爆発")
		effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 24.0)
		effect.set_collision_primitive_damage(100)
	end
	if size_class == 2 then
		effect.create_collision_primitive("爆発")
		effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 33.6)
		effect.set_collision_primitive_damage(400)
		effect.set_effect_character_scale(1.4, 1.4, 1.4)
	end
	if size_class == 3 then
		effect.create_collision_primitive("爆発")
		effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 43.199997)
		effect.set_collision_primitive_damage(800)
		effect.set_effect_character_scale(1.8, 1.8, 1.8)
	end
	if size_class == 4 then
		effect.create_collision_primitive("爆発")
		effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 18.0)
		effect.set_collision_primitive_damage(40)
	end
	if size_class == 5 then
		effect.create_collision_primitive("宝箱爆発")
		effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 33.6)
		effect.set_effect_character_scale(1.8, 1.8, 1.8)
	end
	while frame < 114 do
		if size_class ~= 0 and hit_num <= 0 then
			hit_num = effect.get_collision_primitive_hit_count() or hit_num
			if hit_num > 0 or frame == 30 then
				hit_num = 1
				effect.delete_collision_primitive(-1)
			end
		end
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
