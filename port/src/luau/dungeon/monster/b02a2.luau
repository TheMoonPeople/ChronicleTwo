--!strict
-- dungeon/monster/b02a2.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b2d758a4 = require("@lib/monster/helper_b2d758a4")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
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

--- Runs the monster's normal behaviour.
function script.loop()
	while true do
		helper_b2d758a4()
	end
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_2() end

--- Runs the monster's death.
function script.on_death()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	var0 = monster.play_monster_sound() or var0
	var1 = vm.i32(var0 - 18)
	monster.call_command(18, 8, var2) -- retail: command 18 is not registered
	if var2 == var1 then
		monster.call_command(17, 8, vm.i32(var2 + 1)) -- retail: command 17 is not registered
	else
		monster.call_command(17, 8, 0) -- retail: command 17 is not registered
	end
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	local var0: f32 = 0
	while true do
		monster.set_positional_sound(var0) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		if var0 < vm.f32(0.1) then
			helper_c3e8ae39(3)
			monster.call_command(155) -- retail: command 155 is not registered
			monster.apply_reserved_image()
			helper_c3e8ae39(30)
			return 1
		end
		vm.wait()
	end
end

return script
