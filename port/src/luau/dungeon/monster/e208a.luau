--!strict
-- dungeon/monster/e208a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_8566bb6e = require("@lib/monster/helper_8566bb6e")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_1968()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	helper_93495fdf()
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	monster.SetNextPos(var0, var1, var2, 5.0, 10.0)
	monster.SetMos("特攻")
	helper_8566bb6e(90)
	monster.SetMos("立ち")
	helper_c3e8ae39(8)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	while true do
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	monster.ResetMove()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_c3e8ae39(16)
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	local gekirin: s32 = 0
	monster.ResetMove()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(16)
	gekirin = vm.float_bits(monster.GetGekirin()) or gekirin
	if gekirin == 0 then
		helper_1968()
	end
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
function script.on_guard() end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.GetGekirin()) or gekirin
	if gekirin == 0 then
		helper_1968()
	end
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	monster.ResetMove()
	helper_442b9962()
	monster.SetMos("攻撃外れ", -1, 2)
	helper_56d63eae()
end

--- Runs the monster's death.
function script.on_death()
	monster.ResetMove()
	helper_442b9962()
	monster.SetDeadStart()
	monster.SetMos("吹っ飛び死に", -1, 6)
	helper_56d63eae()
	monster.SetActStatus(1)
	monster.SetDeadOff()
	while true do
		vm.wait()
	end
end

return script
