--!strict
-- dungeon/monster/e08a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_3bd6d918 = require("@lib/monster/helper_3bd6d918")
local helper_522cc63a = require("@lib/monster/helper_522cc63a")
local helper_56845ba9 = require("@lib/monster/helper_56845ba9")
local helper_6033d0e7 = require("@lib/monster/helper_6033d0e7")
local helper_63eb9d5b = require("@lib/monster/helper_63eb9d5b")
local helper_7471d537 = require("@lib/monster/helper_7471d537")
local helper_af3c7344 = require("@lib/monster/helper_af3c7344")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_bbb2220b = require("@lib/monster/helper_bbb2220b")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_c99f4fa5 = require("@lib/monster/helper_c99f4fa5")
local helper_c9f11562 = require("@lib/monster/helper_c9f11562")
local helper_d7694a9b = require("@lib/monster/helper_d7694a9b")
local helper_fd06d627 = require("@lib/monster/helper_fd06d627")

local global0: f32 = 0
local global1: f32 = 0
local global2: f32 = 0

--- Helper function.
local function helper_18c8()
	monster.keep_monster_loop_sound_3(global0, global1, global2) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	global1 = 0.0
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
script.init = helper_18c8

--- Runs the monster's normal behaviour.
function script.loop()
	monster.call_command(119, 1, 0) -- retail: the handler rejects 2 arguments
	monster.call_command(119, 2, 0) -- retail: the handler rejects 2 arguments
	monster.set_model_lighting(0)
	while true do
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_d7694a9b()
	monster.set_life("ダメージ", -1, 6)
	monster.call_command(140, 4.0, 0.0, 3) -- retail: the handler rejects 3 arguments
	helper_7471d537()
	helper_c3e8ae39(12)
	-- retail: monster.set_life("立ち") does nothing, since its handler ignores a string as argument 1
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_bbb2220b()
	monster.set_life("吹っ飛び", -1, 6)
	monster.call_command(140, 3.0, 0.05, 20) -- retail: the handler rejects 3 arguments
	helper_7471d537()
	monster.set_model_lighting(1)
	helper_c3e8ae39(30)
	monster.set_model_lighting(0)
	monster.set_life("起き上がり", -1, 6)
	helper_7471d537()
	-- retail: monster.set_life("立ち") does nothing, since its handler ignores a string as argument 1
	helper_522cc63a()
end

--- Guards against a hit.
function script.on_guard()
	helper_56845ba9()
	monster.set_life("歩き", -1, 0)
	helper_fd06d627(21.0)
	monster.get_attack_power_0()
	monster.set_life("ガードin", -1, 6)
	helper_7471d537()
	monster.set_life("ガード", -1, 0)
	monster.call_command(140, 3.0, 0.0, 2) -- retail: the handler rejects 3 arguments
	helper_c3e8ae39(30)
	monster.set_life("ガードout", -1, 6)
	helper_7471d537()
	monster.set_life("立ち", 0)
	helper_1ef0d4b2()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: f32 = 0
	helper_af3c7344()
	monster.call_command(75, var0) -- retail: the handler rejects 1 arguments
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.call_command(68, 0.0, var0, 0.0) -- retail: command 68 is not registered
	vm.wait()
	monster.set_life("立ち", -1, 0)
	helper_522cc63a()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	local var0: f32 = 0
	helper_af3c7344()
	monster.call_command(75, var0) -- retail: the handler rejects 1 arguments
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.call_command(68, 0.0, var0, 0.0) -- retail: command 68 is not registered
	vm.wait()
	monster.set_life("立ち", -1, 0)
	helper_522cc63a()
end

--- Runs the monster's death.
function script.on_death()
	helper_c9f11562()
	monster.set_life("死に", -1, 2)
	helper_7471d537()
	monster.call_command(142) -- retail: command 142 is not registered
	while true do
		vm.wait()
	end
	helper_6033d0e7()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	monster.set_life("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_3bd6d918()
	monster.call_command(72) -- retail: the handler rejects 0 arguments
	monster.call_command(143) -- retail: command 143 is not registered
	helper_c3e8ae39(10)
	monster.get_attack_power_0()
	monster.set_life("起き上がり", -1, 6)
	helper_7471d537()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_63eb9d5b()
	monster.set_life("吹っ飛び", -1, 6)
	helper_7471d537()
	monster.set_life("起き上がり", -1, 6)
	helper_7471d537()
	helper_c99f4fa5()
end

return script
