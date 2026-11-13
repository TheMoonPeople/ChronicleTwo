--!strict
--- Drives the actions of the sewer rat monster form: a bite and a dodging attack.

local vm = require("@lib/vm")
local attack = require("@lib/action/attack")
local reaction = require("@lib/action/reaction")

--- Dashes forward in a dodging attack.
local function run_dodge_attack()
	local motion_status: s32 = 0
	local prog: s32 = 0
	local motion_progress: f32 = 0
	prog = action.get_program_value() or prog
	if prog == 200 then
		action.play_motion("避け攻撃", -1, 6)
		vm.wait()
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.01) and motion_progress <= vm.f32(0.3) then
			action.set_move_impulse(2.0, 0.0, 2)
		end
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

--- Registers the rat's frames, bite damage and body collisions.
function script.init()
	action.add_object_frame(0, "dcol00")
	action.add_object_frame(1, "ef00")
	action.add_object_frame(2, "bcol00")
	action.add_object_frame(3, "bcol01")
	action.add_object_frame(4, "keri_R")
	action.add_object_frame(5, "nage")
	action.add_motion_damage("dcol00", "", "モンスター攻撃", 2.5, 1.0, "攻撃１", 0.1, 0.9)
	action.add_motion_damage("dcol01", "", "モンス攻撃B", 2.5, 1.0, "避け攻撃", 0.3, 0.43)
	action.add_body_collision(2, 5.0)
	action.add_body_collision(3, 4.0)
end

--- Starts the sewer rat form's attacks when the attack or special button is pressed.
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
			run_dodge_attack()
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
