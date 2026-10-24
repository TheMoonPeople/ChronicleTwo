--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_690ecd8a = require("@lib/event/helper_690ecd8a")
local helper_af3fca28 = require("@lib/event/helper_af3fca28")

--- Helper function.
local function helper_cc339a40(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 0
			helper_690ecd8a(2)
		end
		if at <= 3 then
			var4 = var4 + 1
			helper_690ecd8a(2)
		end
		if at <= 4 then
			helper_690ecd8a(20)
		end
		if at <= 5 then
			helper_af3fca28(0)
		end
		if at <= 6 then
			helper_af3fca28(1)
		end
		if at <= 7 then
			helper_690ecd8a(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-302.7, 76.94, -10.38)
	event.CmrsSetRef(-787.0, 134.76, 18.98)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -802.5, 134.76, -2.32)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -802.5, 134.76, -2.32)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	event.SndSePlay(arg0, 1)
	event.ObjsSetMotion(0, "ジャンプ", 2, 0.4)
	event.ObjsNextMotion(0, "立ち（スティーブ）")
	event.ObjsSetMotion(1, "ジャンプ", 2, 0.4)
	event.ObjsNextMotion(1, "立ち（スティーブ）")
	event.ObjsPosDelay(0, 3)
	event.ObjsPosDelay(1, 3)
	event.ObjsJump(0, -378.73, 50.06, 32.39, -0.35, 31)
	event.ObjsJump(1, -378.73, 50.06, 32.39, -0.35, 31)
	var4 = 0
	helper_690ecd8a(2)
	if vm.skipping() then
		return skip(2)
	end
	while var4 < 31 do
		do
			local out1, out2, out3 = event.GetCharaPos(9)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.CmrsSetRef(var1 - 14.5, var2 + 17.0, var3 + vm.f32(21.3))
		if vm.wait() then
			return skip(3)
		end
		var4 = var4 + 1
	end
	helper_690ecd8a(2)
	if vm.skipping() then
		return skip(4)
	end
	do
		local out1, out2, out3 = event.GetCharaPos(9)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	event.EsmCreate("砂煙e107")
	event.EsmSetVect1(var5, var6 + 5.0, var7)
	event.EsmSetVect2(1.2, 1.2, 1.2)
	event.EsmCreate("砂煙e107")
	event.EsmSetVect1(-378.99, 55.0, 20.63)
	event.EsmSetVect2(1.2, 1.2, 1.2)
	event.EsmCreate("砂煙e107")
	event.EsmSetVect1(-379.65, 55.0, 46.12)
	event.EsmSetVect2(1.2, 1.2, 1.2)
	helper_690ecd8a(20)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(arg0, 2)
	event.SndSePlay(arg0, 0)
	event.CmrsSetPos(-290.45, 68.57, 35.18)
	event.CmrsSetRef(-328.09, 70.17, 34.47)
	event.ObjsResetDaPosition(0)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(6)
	end
	helper_af3fca28(1)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4, -1.0)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4, -1.0)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(8)
	end
end

return helper_cc339a40
