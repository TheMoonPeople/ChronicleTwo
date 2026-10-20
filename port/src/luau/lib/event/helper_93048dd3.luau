--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7f75e08e = require("@lib/event/helper_7f75e08e")
local helper_914262ca = require("@lib/event/helper_914262ca")
local helper_a2a9cc01 = require("@lib/event/helper_a2a9cc01")

--- Helper function.
local function helper_93048dd3(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f75e08e(20)
		end
		if at <= 2 then
			helper_a2a9cc01(2030110)
		end
		if at <= 3 then
			helper_a2a9cc01(2030120)
		end
		if at <= 4 then
			helper_a2a9cc01(2030130)
		end
		if at <= 5 then
			helper_a2a9cc01(2030135)
		end
		if at <= 6 then
			helper_914262ca(0, vm.f32(0.267), -1.0, 30)
		end
		if at <= 7 then
			helper_a2a9cc01(2030140)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsSetMotion(0, "上見立ち", 4)
	event.ObjsResetDaPosition(0)
	event.SndSePlay(arg0, 7)
	event.ObjsSetMotion(1, "驚く", 6)
	event.ObjsNextMotion(1, "驚くL", 0)
	event.ObjsSetMotion(2, "驚く", 6)
	event.ObjsNextMotion(2, "驚くL", 0)
	event.ObjsSetMotion(3, "驚く", 6)
	event.ObjsNextMotion(3, "驚くL", 0)
	helper_7f75e08e(20)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 8)
	event.SetPakuAnim(1, "大口パク")
	helper_a2a9cc01(2030110)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "口パク")
	helper_a2a9cc01(2030120)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(23.44, 65.11, 70.77)
	event.CmrsSetRef(-17.65, 56.75, -37.19)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.ObjsSetMotion(1, "会話2", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "大口パク")
	helper_a2a9cc01(2030130)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "大口パク")
	helper_a2a9cc01(2030135)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "うなづく", 2)
	event.ObjsResetDaPosition(0)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_914262ca(0, vm.f32(0.267), -1.0, 30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_a2a9cc01(2030140)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
end

return helper_93048dd3
