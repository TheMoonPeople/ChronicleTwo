--!strict
--- Drives the actions of the Gemron monster form: an elemental bullet attack.

local vm = require("@lib/vm")
local reaction = require("@lib/action/reaction")
local timing = require("@lib/action/timing")

--- Fires a fire, ice, thunder, wind or holy bullet according to the monster form.
local function fire_elemental_bullet()
	local muzzle_x: f32 = 0
	local muzzle_y: f32 = 0
	local muzzle_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local front_x: f32 = 0
	local front_y: f32 = 0
	local front_z: f32 = 0
	local attack_power: s32 = 0
	local monster_id: s32 = 0
	action.get_program_value()
	action.play_motion("攻撃１", -1, 6)
	action.play_motion("攻撃１", -1, 6)
	timing.wait_motion_progress_between(vm.f32(0.4), vm.f32(0.45))
	do
		local out1, out2, out3 = action.get_object_position("dcol0")
		muzzle_x = out1 or muzzle_x
		muzzle_y = out2 or muzzle_y
		muzzle_z = out3 or muzzle_z
	end
	do
		local out1, out2, out3 = action.get_facing_direction()
		front_x = out1 or front_x
		front_y = out2 or front_y
		front_z = out3 or front_z
	end
	do
		local out1, out2, out3 = action.get_rotation()
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	attack_power = action.get_weapon_attack(0) or attack_power
	monster_id = action.get_monster_form_id() or monster_id
	if monster_id == 112 then
		action.create_effect_1("火弾Ｆ")
	end
	if monster_id == 116 then
		action.create_effect_1("氷弾Ｆ")
	end
	if monster_id == 120 then
		action.create_effect_1("雷弾Ｆ")
	end
	if monster_id == 124 then
		action.create_effect_1("風弾Ｆ")
	end
	if monster_id == 128 then
		action.create_effect_1("聖弾Ｆ")
	end
	action.set_effect_first_vector(-1, muzzle_x, muzzle_y - vm.f32(2.6), muzzle_z)
	action.set_effect_second_vector(-1, rot_x, rot_y, rot_z)
	timing.wait_motion_progress_between(vm.f32(0.45), vm.f32(0.52))
	if monster_id == 112 then
		action.create_effect_1("火弾Ｌ３")
	end
	if monster_id == 116 then
		action.create_effect_1("氷弾Ｌ２")
	end
	if monster_id == 120 then
		action.create_effect_1("雷弾Ｌ２")
	end
	if monster_id == 124 then
		action.create_effect_1("風弾Ｌ２")
	end
	if monster_id == 128 then
		action.create_effect_1("聖弾Ｌ２")
	end
	action.set_effect_first_vector(-1, muzzle_x, muzzle_y - vm.f32(2.6), muzzle_z)
	action.set_effect_second_vector(-1, front_x, front_y, front_z)
	action.set_effect_value(-1, 0, attack_power)
	action.set_effect_value_float(-1, 1, 12.0)
	timing.wait_frames(2)
	action.set_program_value(0)
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Sets the Gemron form's move speed.
function script.init()
	action.set_move_speed(3.4)
end

--- Starts the Gemron form's attacks when the attack or special button is pressed.
function script.loop()
	local prog: s32 = 0
	local attack_button: s32 = 0
	action.set_program_value(0)
	while true do
		prog = action.get_program_value() or prog
		if prog >= 100 and prog < 199 then
			action.turn_toward_target(40.0, 5.0)
			fire_elemental_bullet()
		end
		prog = action.get_program_value() or prog
		if prog == 0 then
			action.run_movement()
			attack_button = action.get_button_state_2(50) or attack_button
			if attack_button ~= 0 then
				prog = 100
			end
			action.set_program_value(prog)
		end
		vm.wait()
	end
end

--- Reacts to a small hit.
script.on_small_damage = reaction.take_damage

--- Holds the character in place.
script.on_hold = reaction.take_damage

--- Reacts to a large hit.
script.on_large_damage = reaction.get_blown_away

--- Follows up a melee hit that the character has landed.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, replacing the engine's default melee hit reaction.
function script.on_melee_hit() end

--- Runs the character's death.
script.on_death = reaction.die

return script
