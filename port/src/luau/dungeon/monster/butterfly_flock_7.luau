--!strict
--- Controls a spare butterfly of the boss flock with the default behaviour.

local vm = require("@lib/vm")
local sense = require("@lib/monster/sense")
local timer = require("@lib/monster/timer")

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Sets the butterfly up with its default attributes and body.
function script.init()
	monster.call_command(161, 1, 0) -- retail: the handler rejects 2 arguments
	monster.call_command(152, 1, 0) -- retail: the handler rejects 2 arguments
	monster.call_command(152, 2, 0) -- retail: the handler rejects 2 arguments
	monster.call_command(151, 0) -- retail: the handler rejects 1 arguments
	monster.get_attack_power(999)
	monster.set_life_int(0)
	monster.get_circle_line_intersections(0, "bcol00")
	monster.call_command(14, 0, 6.0) -- retail: the handler rejects 2 arguments
end

--- Searches for the player forever.
function script.loop()
	while true do
		sense.search_for_player()
	end
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores staggering hits.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores knockdown hits.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores guarding.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores the first dodge.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores the second dodge.
function script.on_dodge_2() end

--- Advances the flock's defeat counter when the butterfly dies.
function script.on_death()
	local sound_value: s32 = 0
	local slot_index: s32 = 0
	local defeat_count: s32 = 0
	sound_value = monster.play_monster_sound() or sound_value
	slot_index = vm.i32(sound_value - 18)
	monster.call_command(18, 8, defeat_count) -- retail: command 18 is not registered
	if defeat_count == slot_index then
		monster.call_command(17, 8, vm.i32(defeat_count + 1)) -- retail: command 17 is not registered
	else
		monster.call_command(17, 8, 0) -- retail: command 17 is not registered
	end
end

--- Holds the butterfly still while it is caught.
function script.on_caught()
	while true do
		vm.wait()
	end
end

--- Waits for the butterfly to touch the ground after a throw and then resets its movement.
function script.on_land()
	local height: f32 = 0
	while true do
		monster.set_positional_sound(height) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		if height < vm.f32(0.1) then
			timer.wait_frames(3)
			monster.call_command(155) -- retail: command 155 is not registered
			monster.apply_reserved_image()
			timer.wait_frames(30)
			return 1
		end
		vm.wait()
	end
end

return script
