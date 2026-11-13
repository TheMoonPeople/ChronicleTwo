--!strict
--- Drives the actions of the Gourgon monster form: a melee attack and a petrifying bullet.

local vm = require("@lib/vm")
local attack = require("@lib/action/attack")
local reaction = require("@lib/action/reaction")
local timing = require("@lib/action/timing")

--- Casts a petrifying bullet effect from the monster's magic collider.
local function cast_petrify_bullet()
	local magic_x: f32 = 0
	local magic_y: f32 = 0
	local magic_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local attack_power: s32 = 0
	action.play_motion("攻撃２", -1, 6)
	timing.wait_motion_progress_between(vm.f32(0.48), vm.f32(0.52))
	do
		local out1, out2, out3 = action.get_object_position("dcol02")
		magic_x = out1 or magic_x
		magic_y = out2 or magic_y
		magic_z = out3 or magic_z
	end
	do
		local out1, out2, out3 = action.get_rotation()
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	attack_power = action.get_weapon_attack(0) or attack_power
	action.create_effect_1("石化弾Ｌ")
	action.set_effect_first_vector(-1, magic_x, magic_y, magic_z)
	action.set_effect_second_vector(-1, rot_x, rot_y, rot_z)
	action.set_effect_value(-1, 0, attack_power)
	timing.wait_motion_finished()
	action.set_program_value(0)
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the attack damage of the Gourgon form.
function script.init()
	action.add_motion_damage("dcol01", "null73", "モンスター剣", 2.5, 1.0, "攻撃１", 0.54, 0.58)
end

--- Starts the Gourgon form's attacks when the attack or special button is pressed.
function script.loop()
	local prog: s32 = 0
	local attack_button: s32 = 0
	local special_button: s32 = 0
	action.set_program_value(0)
	while true do
		prog = action.get_program_value() or prog
		if prog >= 100 and prog < 199 then
			action.turn_toward_target(40.0, 5.0)
			attack.run_first_attack()
		end
		if prog >= 200 and prog < 299 then
			action.turn_toward_target(40.0, 5.0)
			cast_petrify_bullet()
		end
		prog = action.get_program_value() or prog
		if prog == 0 then
			action.run_movement()
			attack_button = action.get_button_state_2(50) or attack_button
			special_button = action.get_button_state_2(51) or special_button
			if attack_button ~= 0 then
				prog = 100
			end
			if special_button ~= 0 then
				prog = 200
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
