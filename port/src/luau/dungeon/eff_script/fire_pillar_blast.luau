--!strict
--- Erupts a fire pillar at the owner effect bone that blows away anything it touches.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Plays the fire pillar motion with a damage area that is removed on first hit or after 48 frames.
function script.on_start()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local get_now_frame_wait: f32 = 0
	local user_id: s32 = 0
	local damage: s32 = 0
	local frame: s32 = 0
	local hit_num: s32 = 0
	user_id = effect.get_owner_character() or user_id
	do
		local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "eff1")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	effect.set_effect_character_position(pos_x, pos_y, pos_z)
	damage = effect.get_script_value(0) or damage
	effect.set_effect_character_scale(0.65, 0.65, 0.65)
	effect.set_effect_character_motion("火柱", -1, 6)
	effect.get_owner_character()
	frame = 0
	effect.create_collision_primitive("吹っ飛び攻撃")
	effect.set_collision_primitive_damage(damage)
	effect.set_collision_primitive_shape(pos_x, pos_y, pos_z, 25.0)
	while frame < 56 do
		hit_num = effect.get_collision_primitive_hit_count() or hit_num
		if hit_num > 0 then
			effect.delete_collision_primitive(-1)
			break
		end
		if frame == 48 then
			effect.delete_collision_primitive(-1)
		end
		vm.wait()
		frame = frame + 1
	end
	while frame < 56 do
		get_now_frame_wait = effect.get_effect_character_motion_progress() or get_now_frame_wait
		if get_now_frame_wait > vm.f32(0.966) then
			effect.delete_collision_primitive(-1)
			return
		end
		if frame == 48 then
			effect.delete_collision_primitive(-1)
		end
		vm.wait()
		frame = frame + 1
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
