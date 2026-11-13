--!strict
--- Drives the actions of the Bomber Head monster form: a melee attack and a self-destruct explosion.

local vm = require("@lib/vm")
local attack = require("@lib/action/attack")
local reaction = require("@lib/action/reaction")

--- Explodes and drops the monster to five percent health when its health is at least half, otherwise ends the program.
local function explode_if_healthy()
	local rate: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	rate = action.get_hp_ratio() or rate
	if rate < 0.5 then
		action.set_program_value(0)
		return
	end
	do
		local out1, out2, out3 = action.get_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	action.create_effect_1("爆発")
	action.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	action.set_effect_value(-1, 0, 2)
	action.set_hp_to_five_percent()
	action.set_program_value(0)
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the attack damage of the Bomber Head form.
function script.init()
	action.add_motion_damage("dcol0", "", "モンスター攻撃", 2.5, 1.0, "攻撃１", 0.3, 0.5)
	action.add_motion_damage("dcol1", "", "モンスター攻撃", 2.5, 1.0, "攻撃１", 0.35, 0.45)
end

--- Starts the Bomber Head form's attacks when the attack or special button is pressed.
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
			explode_if_healthy()
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
