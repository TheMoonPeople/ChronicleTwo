--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_af3fca28 = require("@lib/event/helper_af3fca28")
local helper_ce122344 = require("@lib/event/helper_ce122344")
local helper_e9042a30 = require("@lib/event/helper_e9042a30")

--- Helper function.
local function helper_4dd68e71(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e9042a30(1080070)
		end
		if at <= 2 then
			helper_ce122344(1080075, 100)
		end
		if at <= 3 then
			helper_af3fca28(2)
		end
		if at <= 4 then
			helper_af3fca28(3)
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
	helper_e9042a30(1080070)
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
	helper_ce122344(1080075, 100)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_af3fca28(3)
	if vm.skipping() then
		return skip(5)
	end
end

return helper_4dd68e71
