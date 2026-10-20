--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06d53ec5 = require("@lib/event/helper_06d53ec5")
local helper_0da018f4 = require("@lib/event/helper_0da018f4")
local helper_f33fd19e = require("@lib/event/helper_f33fd19e")

--- Helper function.
local function helper_156b7abc(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_06d53ec5(1080050)
		end
		if at <= 2 then
			helper_06d53ec5(1080060)
		end
		if at <= 3 then
			helper_f33fd19e(3)
		end
		if at <= 4 then
			helper_0da018f4()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-17.46, 142.28, 29.34)
	event.CmrsSetRef(1.26, 135.02, 26.5)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 1.21, 102.73, 26.08)
	event.ObjsSetRot(3, 0.0, -1.56, 0.0)
	event.ObjsSetMotion(3, "逃げちゃうの？", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "わらい顔2")
	event.SetPakuAnim(3, "わらい口パク")
	helper_06d53ec5(1080050)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(-17.46, 142.28, 29.34)
	event.CmrsSetRef(1.26, 135.02, 26.5)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "たかわらい顔")
	event.ObjsSetMotion(3, "オーッホッホ", 4)
	event.SetPakuAnim(3, "わらい口パク")
	helper_06d53ec5(1080060)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	helper_f33fd19e(3)
	if vm.skipping() then
		return skip(4)
	end
	helper_0da018f4()
	if vm.skipping() then
		return skip(5)
	end
end

return helper_156b7abc
