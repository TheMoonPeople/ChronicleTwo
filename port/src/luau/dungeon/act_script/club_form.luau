--!strict
--- Drives the actions of the Club monster form: sword attacks.

local vm = require("@lib/vm")
local attack = require("@lib/action/attack")
local reaction = require("@lib/action/reaction")

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the attack damage of each Club variant.
function script.init()
	local monster_id: s32 = 0
	monster_id = action.get_monster_form_id() or monster_id
	if monster_id == 224 then
		action.add_motion_damage("dcol0", "dcol1", "モンスター剣", 2.5, 1.0, "攻撃１", 0.2, 0.25)
		action.add_motion_damage("dcol0", "dcol1", "モンスター剣", 2.5, 1.0, "攻撃１", 0.4, 0.5)
	end
	if monster_id == 228 then
		action.add_motion_damage("dcol0", "", "モンスター攻撃", 3.0, 1.0, "攻撃１", 0.28, 0.35)
	end
	if monster_id == 232 then
		action.add_motion_damage("dcol0", "dcol1", "モンスター剣", 3.0, 1.0, "攻撃１", 0.45, 0.7)
	end
	if monster_id == 236 then
		action.add_motion_damage("dcol0", "dcol1", "モンスター剣", 2.5, 1.0, "攻撃１", 0.48, 0.56)
	end
	if monster_id == 240 then
		action.add_motion_damage("dcol0", "", "モンスター攻撃", 3.0, 1.0, "攻撃１", 0.3, 0.5)
	end
	print("MONS_ID = ", monster_id)
end

--- Starts the Club form's attacks when the attack or special button is pressed.
function script.loop()
	local prog: s32 = 0
	local attack_button: s32 = 0
	action.set_program_value(0)
	while true do
		prog = action.get_program_value() or prog
		if prog >= 100 and prog < 199 then
			action.turn_toward_target(40.0, 5.0)
			attack.run_first_attack()
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
