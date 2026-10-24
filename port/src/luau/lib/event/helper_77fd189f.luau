--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_690ecd8a = require("@lib/event/helper_690ecd8a")
local helper_af3fca28 = require("@lib/event/helper_af3fca28")
local helper_d4b8f712 = require("@lib/event/helper_d4b8f712")

--- Helper function.
local function helper_77fd189f(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_690ecd8a(43)
		end
		if at <= 2 then
			helper_af3fca28(2)
		end
		if at <= 3 then
			helper_d4b8f712()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SndSeStop(arg0, 1)
	event.SndSePlay(arg0, 4)
	event.CmrsSetPos(-133.46, 84.21, 3.17)
	event.CmrsSetRef(44.81, 76.82, -5.13)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -240.84, 50.51, -5.32)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -240.84, 50.51, -5.32)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.CharaActive(1, 10)
	event.ObjsSetPos(2, 10.66, 50.0, -0.04)
	event.ObjsSetRot(2, 0.0, -1.56, 0.0)
	event.ObjsSetScale(2, 1.2, 1.2, 1.2)
	event.PlayBgm(0)
	event.CmrsQuakeDelay(6)
	event.CmrsQuake(0.0, 1.5, 0.0, 24)
	event.CmrsPrdelay(30)
	event.CmrsSetPos(82.22, 91.62, -68.3)
	event.CmrsSetRef(-234.51, 58.39, 145.67)
	event.ObjsSetMotion(2, "着地", 6)
	event.ObjsMotionWait(2)
	helper_690ecd8a(43)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 5)
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(3)
	end
	helper_d4b8f712()
	if vm.skipping() then
		return skip(4)
	end
end

return helper_77fd189f
