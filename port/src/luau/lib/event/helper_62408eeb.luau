--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")
local helper_261c70db = require("@lib/event/helper_261c70db")
local helper_3ea45d11 = require("@lib/event/helper_3ea45d11")
local helper_4896c0c7 = require("@lib/event/helper_4896c0c7")

--- Helper function.
local function helper_62408eeb(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4896c0c7(1070040)
		end
		if at <= 2 then
			helper_4896c0c7(1070042)
		end
		if at <= 3 then
			helper_3ea45d11(1070050, 120)
		end
		if at <= 4 then
			helper_23bda4ba(2)
		end
		if at <= 5 then
			helper_23bda4ba(3)
		end
		if at <= 6 then
			helper_261c70db()
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
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 35.03, 137.05, 41.92)
	event.ObjsSetRot(3, 0.0, -1.92, 0.0)
	event.SndSePlay(arg0, 7)
	event.ObjsSetMotion(3, "まわる", 6)
	event.ObjsNextMotion(3, "会話")
	event.SetPakuAnim(3, "わらい口パク")
	helper_4896c0c7(1070040)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.ObjsMotionDelay(3, 60)
	event.ObjsSetMotion(3, "ぶぅ～", 6)
	event.SetPakuAnim(3, "わらい口パク")
	helper_4896c0c7(1070042)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.ObjsSetRot(3, 0.0, -1.56, 0.0)
	event.SndSePlay(arg0, 9)
	event.SndSePlay(arg0, 10)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(20, 128.0, 128.0, 128.0, 128.0, 30)
	event.ObjsSetMotion(2, "パオーン", 6)
	event.ObjsNextMotion(2, "立ち", 0)
	event.ObjsSetMotion(3, "指差す", 6)
	event.CmrsMove2(-158.84, 98.6, 40.59, 12.88, 114.56, 18.64, 18, 1, 0.3)
	event.SetPakuAnim(3, "おこり口パク")
	helper_3ea45d11(1070050, 120)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(5)
	end
	helper_23bda4ba(3)
	if vm.skipping() then
		return skip(6)
	end
	helper_261c70db()
	if vm.skipping() then
		return skip(7)
	end
end

return helper_62408eeb
