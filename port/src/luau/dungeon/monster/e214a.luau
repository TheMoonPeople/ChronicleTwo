--!strict
-- dungeon/monster/e214a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2c50af1c = require("@lib/monster/helper_2c50af1c")
local helper_4b32ee99 = require("@lib/monster/helper_4b32ee99")
local helper_7c50ce86 = require("@lib/monster/helper_7c50ce86")

--- Helper function.
local function helper_db88()
	local no_damage_cnt: s32 = 0
	local timer: s32 = 0
	local value: s32 = 0
	no_damage_cnt = monster.GetNoDamageCnt() or no_damage_cnt
	timer = monster.GetTimer() or timer
	value = monster.VPop(6) or value
	if value == 0 and no_damage_cnt >= 1 and timer >= 900 then
		monster.VPush(6, 1)
		monster.RunEventScript(501)
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.SetObj(0, "bcol00")
	monster.SetObj(1, "bcol01")
	monster.SetObj(2, "bcol02")
	monster.SetObj(3, "bcol03")
	monster.SetObj(4, "bcol04")
	monster.SetObj(5, "bcol05")
	monster.SetObj(6, "dcol00")
	monster.SetObj(7, "dcol01")
	monster.SetObj(8, "dcol02")
	monster.SetDmg2("通常攻撃", 8.0, "攻撃１", 0.217, 0.256, 0)
	monster.SetDmg2("吹っ飛び攻撃", 8.0, "攻撃１", 0.486, 0.524, 0)
	monster.SetBody(0, 15.0)
	monster.SetBody(1, 5.0)
	monster.SetBody(2, 5.0)
	monster.SetBody(3, 9.0)
	monster.SetBody(4, 5.0)
	monster.SetBody(5, 5.0)
	monster.VPush(0, 0)
	monster.VPush(1, 0)
	monster.VPush(2, 2)
	monster.VPush(3, 7)
	monster.VPush(4, -1)
	monster.VPush(5, 20)
	monster.VPush(6, 0)
	monster.LoadEffectScript("ヴァンガード衝撃波")
	monster.SetClipDist(120.0)
	monster.SetMos("立ち", -1, 4)
	monster.SetScoop("攻撃２", 0.245, 0.531, 1013)
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	monster.SetMos("立ち")
	while true do
		helper_db88()
		helper_7c50ce86()
		helper_2c50af1c()
		helper_4b32ee99()
		vm.wait()
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
-- Defined empty, so the engine runs this instead of its default.
function script.on_death() end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
function script.on_stun() end

return script
