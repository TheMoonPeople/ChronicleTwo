--!strict
-- dungeon/monster/b02a_mesibe.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_f683d690 = require("@lib/monster/helper_f683d690")

--- Helper function.
local function helper_2d6c()
	monster.SetMos("待機", -1, 4)
	while true do
		helper_1ef0d4b2()
		vm.wait()
	end
	helper_f683d690()
end

--- Helper function.
local function helper_2460()
	local value: s32 = 0
	local value_2: s32 = 0
	value = monster.VPop(17) or value
	if value ~= 7 then
		return
	end
	monster.EsmCreate_1("ラフレシア花粉")
	value_2 = monster.VPop(8) or value_2
	if value_2 == 0 then
		monster.VPush(8, 16)
	end
end

--- Helper function.
local function helper_2670()
	local value: s32 = 0
	monster.SetMos("もちあがる", -1, 2)
	monster.MySePlay(3)
	helper_56d63eae()
	monster.MySePlay(2)
	value = monster.VPop(17) or value
	value = vm.i32(value + 1)
	monster.VPush(17, value)
	if value == 6 then
		monster.VPush(17, 7)
	end
	monster.SetMos("ゆれる", -1, 4)
	helper_2460()
	while true do
		vm.wait()
		value = monster.VPop(17) or value
		if value == 0 then
			break
		elseif value == 7 then
			value = monster.VPop(8) or value
			if value == 0 then
				monster.VPush(17, 0)
				break
			end
		end
	end
	helper_f683d690()
	monster.MySeStop(2)
	monster.SetMos("たれる", -1, 6)
	monster.MySePlay(4)
	helper_56d63eae()
	monster.SetMonsterLife(1.0)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.SetAttrib(8, 1)
	monster.SetAttrib(1, 1)
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	monster.SetClipDist(9999.9)
	monster.SetAttrib(4, 1)
	monster.LoadEffectScript("ラフレシア花粉")
	monster.LoadEffectScript("ラフレシア花粉サブ")
	monster.SetObj(0, "shokushu")
	monster.SetBody(0, 12.0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	while true do
		helper_2d6c()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	monster.SetMos("もちあがる", -1, 2)
	monster.MySePlay(3)
	helper_56d63eae()
	monster.SetMos("たれる", -1, 6)
	monster.MySePlay(4)
	helper_56d63eae()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	monster.SetMos("もちあがる", -1, 2)
	monster.MySePlay(3)
	helper_56d63eae()
	monster.SetMos("たれる", -1, 6)
	monster.MySePlay(4)
	helper_56d63eae()
end

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
script.on_death = helper_2670

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	local height: f32 = 0
	while true do
		height = monster.GetHigh() or height
		if height < vm.f32(0.1) then
			helper_c3e8ae39(3)
			monster.SetShrowEnd()
			monster.ResetMove()
			helper_c3e8ae39(30)
			return 1
		end
		vm.wait()
	end
end

return script
