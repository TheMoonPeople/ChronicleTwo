--!strict
--- Drives the actions of the Pumpkinhead monster form: a melee attack and a thrown pumpkin bomb.

local vm = require("@lib/vm")
local attack = require("@lib/action/attack")
local reaction = require("@lib/action/reaction")
local timing = require("@lib/action/timing")

--- Throws a pumpkin bomb effect from the monster's pumpkin.
local function throw_pumpkin_bomb()
	local bomb_x: f32 = 0
	local bomb_y: f32 = 0
	local bomb_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local attack_power: s32 = 0
	action.get_program_value()
	action.play_motion("攻撃２", -1, 6)
	vm.wait()
	timing.wait_motion_progress_between(vm.f32(0.64), vm.f32(0.68))
	attack_power = action.get_weapon_attack(0) or attack_power
	do
		local out1, out2, out3 = action.get_object_position("kabo")
		bomb_x = out1 or bomb_x
		bomb_y = out2 or bomb_y
		bomb_z = out3 or bomb_z
	end
	do
		local out1, out2, out3 = action.get_rotation()
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	action.create_effect_1("かぼちゃ爆弾")
	action.set_effect_first_vector(-1, bomb_x, bomb_y, bomb_z)
	action.set_effect_second_vector(-1, rot_x, rot_y, rot_z)
	action.set_effect_value(-1, 0, attack_power)
	timing.wait_motion_finished()
	action.set_program_value(0)
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the attack damage of the Pumpkinhead form.
function script.init()
	action.add_motion_damage("dcol0", "dcol1", "モンスター剣", 2.5, 1.0, "攻撃１", 0.27, 0.7)
end

--- Starts the Pumpkinhead form's attacks when the attack or special button is pressed.
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
			throw_pumpkin_bomb()
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
