--!strict
--- Shows an explosion at a given point whose size, radius and damage depend on the explosion kind.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no initialisation.
function script.init() end

--- Plays the explosion at the impact point and damages targets in the kind's radius until a target is hit or thirty frames pass.
function script.on_start()
	local explosion_kind: s32 = 0
	local impact_x: f32 = 0
	local impact_y: f32 = 0
	local impact_z: f32 = 0
	local frame: s32 = 0
	local hit_count: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		impact_x = out1 or impact_x
		impact_y = out2 or impact_y
		impact_z = out3 or impact_z
	end
	explosion_kind = effect.get_script_value(0) or explosion_kind
	effect.set_effect_character_position(impact_x, impact_y, impact_z)
	effect.set_effect_character_motion("爆発", -1, 6)
	effect.play_battle_sound(11, impact_x, impact_y, impact_z)
	hit_count = 0
	frame = 0
	if explosion_kind == 1 then
		effect.create_collision_primitive("爆発")
		effect.set_collision_primitive_shape(impact_x, impact_y, impact_z, 24.0)
		effect.set_collision_primitive_damage(100)
	end
	if explosion_kind == 2 then
		effect.create_collision_primitive("爆発")
		effect.set_collision_primitive_shape(impact_x, impact_y, impact_z, 33.6)
		effect.set_collision_primitive_damage(400)
		effect.set_effect_character_scale(1.4, 1.4, 1.4)
	end
	if explosion_kind == 3 then
		effect.create_collision_primitive("爆発")
		effect.set_collision_primitive_shape(impact_x, impact_y, impact_z, 43.199997)
		effect.set_collision_primitive_damage(800)
		effect.set_effect_character_scale(1.8, 1.8, 1.8)
	end
	if explosion_kind == 4 then
		effect.create_collision_primitive("爆発")
		effect.set_collision_primitive_shape(impact_x, impact_y, impact_z, 18.0)
		effect.set_collision_primitive_damage(40)
	end
	if explosion_kind == 5 then
		effect.create_collision_primitive("宝箱爆発")
		effect.set_collision_primitive_shape(impact_x, impact_y, impact_z, 33.6)
		effect.set_effect_character_scale(1.8, 1.8, 1.8)
	end
	while frame < 114 do
		if explosion_kind ~= 0 and hit_count <= 0 then
			hit_count = effect.get_collision_primitive_hit_count() or hit_count
			if hit_count > 0 or frame == 30 then
				hit_count = 1
				effect.delete_collision_primitive(-1)
			end
		end
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
