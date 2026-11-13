--!strict
--- Monster death helpers.

local vm = require("@lib/vm")
local movement = vm.module("@lib/monster/movement")
local timer = vm.module("@lib/monster/timer")

local death = {}

--- Stops the monster, halts its turning and starts its death.
function death.begin()
	monster.stop_moving()
	movement.stop_turning()
	monster.start_death()
end

--- Stops the monster, holds its facing and starts its death for monsters using the alternative command set.
function death.begin_variant()
	monster.call_command(72) -- retail: the handler rejects 0 arguments
	movement.hold_current_facing_variant()
	monster.call_command(141) -- retail: command 141 is not registered
end

--- Spawns the death effects and then keeps ticking forever.
function death.play_death_effects_forever()
	monster.spawn_death_effects()
	while true do
		timer.wait_one_frame()
	end
end

--- Spawns the death effects and then waits forever.
function death.play_effects()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

--- Plays the death effects and then waits forever for monsters using the alternative command set.
function death.play_effects_variant()
	monster.call_command(142) -- retail: command 142 is not registered
	while true do
		vm.wait()
	end
end

--- Starts the death sequence, turns the flying attributes off and plays the damage motion until the monster lands, for up to 900 frames.
function death.start_death_and_fall()
	local frame: s32 = 0
	local height: f32 = 0
	monster.stop_moving()
	movement.stop_turning()
	monster.start_death()
	monster.set_monster_attributes(4, 0)
	monster.set_monster_attributes(256, 0)
	monster.set_monster_attributes(8, 0)
	monster.set_motion("ダメージ", -1, 0)
	frame = 0
	while frame < 900 do
		vm.wait()
		monster.get_position_3()
		height = monster.get_height_above_ground() or height
		if height <= 0.0 then
			break
		else
			frame = frame + 1
		end
	end
end

return death
