--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")
local helper_261c70db = require("@lib/event/helper_261c70db")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")

--- Helper function.
local function helper_39b18f99(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_adea7ba0(120)
		end
		if at <= 2 then
			helper_261c70db()
		end
		if at <= 4 then
			helper_adea7ba0(20)
		end
		if at <= 5 then
			helper_23bda4ba(0)
		end
		if at <= 6 then
			helper_23bda4ba(1)
		end
		if at <= 7 then
			helper_261c70db()
		end
		if at <= 8 then
			helper_adea7ba0(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsFadeInit()
	event.CmrsFadeIn(200, 0.0, 0.0, 0.0)
	event.CmrsSetPos(1010.98, 218.14, -55.12)
	event.CmrsSetRef(-755.14, 237.29, -2.56)
	event.ObjsSetPos(0, -943.03, 134.76, 0.63)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.ObjsSetPos(1, -943.03, 134.76, 0.63)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	event.CmrsMove(64.12, 205.59, -18.9, -755.14, 157.59, -2.56, 120)
	event.ObjsMove(0, -739.93, 134.76, -3.16, 120)
	event.ObjsMove(1, -739.93, 134.76, -3.16, 120)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 4)
	helper_adea7ba0(120)
	if vm.skipping() then
		return skip(2)
	end
	helper_261c70db()
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	if vm.wait() then
		return skip(4)
	end
	event.CmrsSetPos(-667.47, 186.39, -3.73)
	event.CmrsSetRef(-755.14, 160.61, -2.56)
	event.ObjsSetPos(0, -768.25, 133.66, -2.78)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -768.25, 133.66, -2.78)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 4)
	event.ObjsMove(0, -739.93, 134.76, -3.16, 20)
	event.ObjsMove(1, -739.93, 134.76, -3.16, 20)
	helper_adea7ba0(20)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "立ち（スティーブ）")
	event.ObjsSetMotion(1, "立ち（スティーブ）")
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(6)
	end
	helper_23bda4ba(1)
	if vm.skipping() then
		return skip(7)
	end
	helper_261c70db()
	if vm.skipping() then
		return skip(8)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(9)
	end
end

return helper_39b18f99
