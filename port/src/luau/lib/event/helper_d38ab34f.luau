--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06d53ec5 = require("@lib/event/helper_06d53ec5")
local helper_0da018f4 = require("@lib/event/helper_0da018f4")
local helper_f33fd19e = require("@lib/event/helper_f33fd19e")

--- Helper function.
local function helper_d38ab34f(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0da018f4()
		end
		if at <= 2 then
			helper_06d53ec5(1080040)
		end
		if at <= 3 then
			helper_06d53ec5(1080041)
		end
		if at <= 4 then
			helper_06d53ec5(1080042)
		end
		if at <= 5 then
			helper_f33fd19e(2)
		end
		if at <= 6 then
			helper_f33fd19e(3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-129.32, 99.43, 13.13)
	event.CmrsSetRef(-44.6, 102.72, 11.17)
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CharaActive(1, 10)
	event.ObjsSetPos(2, 9.11, 50.0, -10.14)
	event.ObjsSetRot(2, 0.0, -1.44, 0.0)
	event.ObjsSetScale(2, 1.2, 1.2, 1.2)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 1.54, 105.26, 40.3)
	event.ObjsSetRot(3, 0.0, -1.8, 0.0)
	event.ObjsSetMotion(3, "オーッホッホ", 4)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_0da018f4()
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 1)
	event.ObjsSetMotion(2, "パオーン", 6)
	event.ObjsNextMotion(2, "立ち", 0)
	event.SetPakuAnim(3, "わらい口パク")
	helper_06d53ec5(1080040)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "わらい口パク")
	helper_06d53ec5(1080041)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "わらい口パク")
	helper_06d53ec5(1080042)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_f33fd19e(2)
	if vm.skipping() then
		return skip(6)
	end
	helper_f33fd19e(3)
	if vm.skipping() then
		return skip(7)
	end
end

return helper_d38ab34f
