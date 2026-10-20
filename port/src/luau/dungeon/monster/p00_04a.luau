--!strict
-- dungeon/monster/p00_04a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_7000e3dd = require("@lib/monster/helper_7000e3dd")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_dbfe0a16 = require("@lib/monster/helper_dbfe0a16")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_ee5b84d4 = require("@lib/monster/helper_ee5b84d4")
local helper_fd16d93e = require("@lib/monster/helper_fd16d93e")

--- Helper function.
local function helper_2f8c()
	helper_1adea708(500.0)
	helper_6911bbcd(80.0)
	helper_5a759074(0)
	monster.VPush2(5, 0)
	monster.VPush2(11, 150)
	monster.VPush2(12, 0)
	monster.GetPos_3()
	monster.SetClipDist(500.0)
end

--- Helper function.
local function helper_cb4c()
	monster.SetDeadOff()
	while true do
		helper_b9fff8e1()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.SetAttrib(1, 1)
	monster.SetAttrib(4, 1)
	helper_2f8c()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.SetIntFlag(1, 0)
	monster.SetIntFlag(2, 0)
	monster.SetActStatus(0)
	while true do
		helper_b9fff8e1()
	end
end

--- Reacts to a hit while greyed out, or to a hit that greys it out.
function script.on_status_hit()
	local var0: s32 = 0
	helper_5d37e9f4()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(0.0, 0.0, 0)
	var0 = 1
	while var0 ~= 0 do
		var0 = monster.GetStsAttr(40) or var0
		helper_b9fff8e1()
	end
	monster.SetMos("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5d37e9f4()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_cbe4d8e2()
	helper_ee5b84d4(12)
	monster.SetMos("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_fd16d93e()
	monster.SetMos("ダメージ", -1, 6)
	monster.BlowStart(4.0, 0.0, 3)
	helper_cbe4d8e2()
	helper_ee5b84d4(12)
	monster.SetMos("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_dbfe0a16()
	monster.SetMos("歩き", -1, 0)
	helper_83e135e0(21.0)
	monster.ResetMotion()
	monster.SetMos("ガードin", -1, 6)
	helper_cbe4d8e2()
	monster.SetMos("ガード", -1, 0)
	monster.BlowStart(3.0, 0.0, 2)
	helper_ee5b84d4(60)
	monster.SetMos("ガードout", -1, 6)
	helper_cbe4d8e2()
	monster.SetMos("立ち")
	helper_7000e3dd()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.GetTargetAngle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.SetRot(0.0, var0, 0.0)
	helper_b9fff8e1()
	monster.SetMos("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.GetTargetAngle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.SetRot(0.0, var0, 0.0)
	helper_b9fff8e1()
	monster.SetMos("立ち", -1, 0)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_02ce7891()
	monster.SetMos("死に", -1, 2)
	helper_cbe4d8e2()
	monster.SetDeadOff()
	while true do
		helper_b9fff8e1()
	end
	helper_cb4c()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.SetMos("吹っ飛び", -1, 6)
	helper_cbe4d8e2()
	monster.SetMos("起き上がり", -1, 6)
	helper_cbe4d8e2()
	helper_e05438b5()
end

return script
