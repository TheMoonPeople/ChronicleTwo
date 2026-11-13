--!strict
--- Drives the actions of the Guardia monster form: two sword attacks.

local vm = require("@lib/vm")
local attack = require("@lib/action/attack")
local reaction = require("@lib/action/reaction")

--- Runs the wind-up and swing of the second attack.
local function run_second_attack()
	local motion_status: s32 = 0
	local prog: s32 = 0
	prog = action.get_program_value() or prog
	if prog == 200 then
		action.play_motion("攻撃２in", -1, 6)
		vm.wait()
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(201)
		end
		return
	end
	if prog == 201 then
		action.play_motion("攻撃２", -1, 6)
		vm.wait()
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the attack damage of the Guardia form.
function script.init()
	action.add_motion_damage("dcol0", "dcol1", "モンス攻撃B", 2.5, 1.0, "攻撃１", 0.36, 0.5)
	action.add_motion_damage("dcol0", "dcol1", "モンス攻撃B", 2.5, 1.0, "攻撃２", 0.2, 0.28)
	action.add_sword_effect(0, "攻撃１", 0.36, 0.4, "dcol0", "dcol1", 77, 10, 10)
	action.add_sword_effect(0, "攻撃２", 0.2, 0.23, "dcol0", "dcol1", 77, 10, 10)
	action.set_move_speed(1.5)
end

--- Starts the Guardia form's attacks when the attack or special button is pressed.
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
			run_second_attack()
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
