--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5fe8f3bb = require("@lib/event/helper_5fe8f3bb")
local helper_6fd2ce25 = require("@lib/event/helper_6fd2ce25")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")

--- Helper function.
local function helper_e224ffc6()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5fe8f3bb()
		end
		if at <= 2 then
			helper_6fd2ce25(64)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetTime(24.0)
	event.SetTimeStepEnable(0)
	event.ClearStack(4)
	event.AssignStack(4)
	event.ClearStack(5)
	event.AssignStack(5)
	event.DelExtMotion(0)
	event.LoadMotion(5, "event/lm/c01ev.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "屋根", 5)
	event.LoadChara(5, "event/lm/p00_02ev.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "屋根", 5)
	event.LoadChara(5, "event/lm/p00_03ev.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.EohSetPos(2, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "屋根の上", 5)
	event.LoadChara(5, "event/opening/p5/p5_donnie.gltf", "info", 11)
	event.CharaActive(11)
	event.SetCharaPos(11, 0.0, 0.0, 0.0)
	event.SetCharaRot(11, 0.0, 0.0, 0.0)
	event.SetMotion(11, "閉める", 2)
	event.CmrsInit()
	event.CmrsSyncObj(0, 5.0, 20.0, 0.0, 2.2, 20.0, 100.0, "ground")
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSetMotion(0, "屋根", 6)
	event.EohSetMotion(1, "屋根", 6)
	event.EohSetMotion(2, "屋根の上", 6)
	event.CmrsMoveAhd2(-2.2, 40.0, 100.0, 48, 2, 0.4)
	event.CmrsMoveAhd2(-2.2, 160.0, 200.0, 20, 0, 0.4)
	event.CmrsAhddelay(20)
	event.CmrsMoveAhd2(1.57, 5.0, 80.0, 28, 0, 0.4)
	event.CmrsMoveAhd2(1.57, 0.0, 30.0, 50, 0, 0.4)
	event.CmrsMoveAhd2(-2.84, 150.0, 230.0, 30, 0, 0.2)
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsReleaseObj()
	helper_6fd2ce25(64)
	if vm.skipping() then
		return skip(3)
	end
	event.DelExtMotion(0)
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.CharaActive(1, 0)
end

return helper_e224ffc6
