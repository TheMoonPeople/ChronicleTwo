--!strict
--- Player character damage, knockdown and death reactions.

local vm = require("@lib/vm")
local timing = vm.module("@lib/action/timing")

local reaction = {}

--- Plays the death motion and waits for the confirm button before returning to idle.
function reaction.die()
	local is_button_pressed: s32 = 0
	action.release_held_object(0)
	action.play_motion("死に", -1, 6)
	timing.wait_motion_finished()
	while true do
		is_button_pressed = action.get_button_state_2(50) or is_button_pressed
		if is_button_pressed ~= 0 then
			break
		else
			vm.wait()
		end
	end
	action.set_program_value(0)
end

--- Knocks the character back, plays the blown away and get up motions, and returns to idle.
function reaction.get_blown_away()
	action.start_knockback(5.0, 0.0, 10)
	action.face_against_knockback()
	action.release_held_object(0)
	action.play_motion("吹っ飛び", -1, 6)
	timing.wait_motion_finished()
	timing.wait_frames(8)
	action.play_motion("起き上がり", -1, 6)
	timing.wait_motion_finished()
	timing.wait_frames(2)
	action.set_program_value(0)
end

--- Plays the damage reaction with a knockback and returns to idle.
function reaction.take_damage()
	print("DAMAGE!\n")
	action.set_charge_effect_mode(0)
	action.start_knockback(5.0, 0.0, 3)
	action.release_held_object(0)
	action.play_motion("ダメージ後", -1, 2)
	timing.wait_frames(8)
	action.set_program_value(0)
end

return reaction
