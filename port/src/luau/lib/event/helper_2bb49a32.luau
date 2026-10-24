--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06d53ec5 = require("@lib/event/helper_06d53ec5")
local helper_88625211 = require("@lib/event/helper_88625211")
local helper_f33fd19e = require("@lib/event/helper_f33fd19e")

--- Helper function.
local function helper_2bb49a32(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_06d53ec5(1080070)
		end
		if at <= 2 then
			helper_88625211(1080075, 100)
		end
		if at <= 3 then
			helper_f33fd19e(2)
		end
		if at <= 4 then
			helper_f33fd19e(3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-44.56, 149.8, 16.49)
	event.CmrsSetRef(29.9, 155.39, 35.57)
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CharaActive(1, 10)
	event.ObjsSetRot(2, 0.0, -1.32, 0.0)
	event.ObjsSetScale(2, 1.2, 1.2, 1.2)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 35.03, 137.05, 41.92)
	event.ObjsSetRot(3, 0.0, -1.92, 0.0)
	event.SndSePlay(arg0, 6)
	event.ObjsSetMotion(3, "まわる", 6)
	event.ObjsNextMotion(3, "会話")
	event.SetPakuAnim(3, "わらい口パク")
	helper_06d53ec5(1080070)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.ObjsSetRot(3, 0.0, -1.56, 0.0)
	event.SndSePlay(arg0, 8)
	event.ObjsSetMotion(2, "パオーン", 6)
	event.ObjsNextMotion(2, "立ち", 0)
	event.ObjsSetMotion(3, "指差す", 6)
	event.CmrsMove2(-158.84, 98.6, 40.59, 12.88, 114.56, 18.64, 10, 1, 0.3)
	event.SetPakuAnim(3, "わらい口パク")
	helper_88625211(1080075, 100)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	helper_f33fd19e(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_f33fd19e(3)
	if vm.skipping() then
		return skip(5)
	end
end

return helper_2bb49a32
