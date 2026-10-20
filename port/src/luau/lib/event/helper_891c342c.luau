--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")
local helper_261c70db = require("@lib/event/helper_261c70db")
local helper_3ea45d11 = require("@lib/event/helper_3ea45d11")

--- Helper function.
local function helper_891c342c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3ea45d11(1030200, 100)
		end
		if at <= 2 then
			helper_261c70db()
		end
		if at <= 3 then
			helper_23bda4ba(2)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-31.39, 240.49, -36.86)
	event.CmrsSetRef(21.64, 234.04, -106.15)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -0.79, 50.09, 122.71)
	event.ObjsSetRot(0, 0.0, -3.14, 0.0)
	event.CharaActive(1, 9)
	event.ObjsSetPos(2, 25.82, 208.06, -111.43)
	event.ObjsSetRot(2, 0.0, -0.96, 0.0)
	event.ObjsSetScale(2, 1.0, 1.0, 1.0)
	event.CharaActive(1, 8)
	event.ObjsSetPos(1, 0.0, 50.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetScale(1, 1.5, 1.5, 1.5)
	event.CmrsMove2(-256.22, 55.22, 128.24, 76.97, 161.85, -3.41, 24, 1, 0.4)
	event.CmrsPrdelay(24)
	event.CmrsSetPos(3.97, 70.67, 202.31)
	event.CmrsSetRef(-0.77, 76.22, 76.84)
	event.ObjsMotionDelay(0, 24)
	event.ObjsPosDelay(0, 24)
	event.ObjsRotDelay(0, 24)
	event.ObjsSetPos(0, -0.79, 50.09, 122.71)
	event.ObjsSetRot(0, 0.0, -3.14, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "殺っておしまい", 2)
	event.ObjsNextMotion(2, "殺っておしまいL", 0)
	event.ObjsSetMotion(1, "パオーン", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.CmrsQuakeDelay(52)
	event.CmrsQuake(0.0, 1.3, 0.0, 24)
	event.SndSePlay(arg0, 11)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(10, 128.0, 128.0, 128.0, 128.0, 30)
	event.SetPakuAnim(2, "おこり口パク")
	helper_3ea45d11(1030200, 100)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	helper_261c70db()
	if vm.skipping() then
		return skip(3)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(4)
	end
end

return helper_891c342c
