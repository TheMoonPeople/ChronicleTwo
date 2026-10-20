--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_690ecd8a = require("@lib/event/helper_690ecd8a")
local helper_af3fca28 = require("@lib/event/helper_af3fca28")
local helper_d4b8f712 = require("@lib/event/helper_d4b8f712")

--- Helper function.
local function helper_5bdd0aa1(arg0: s32)
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
			helper_af3fca28(0)
		end
		if at <= 2 then
			helper_af3fca28(1)
		end
		if at <= 3 then
			helper_d4b8f712()
		end
		if at <= 4 then
			helper_af3fca28(0)
		end
		if at <= 5 then
			helper_af3fca28(1)
		end
		if at <= 6 then
			helper_af3fca28(0)
		end
		if at <= 7 then
			helper_af3fca28(1)
		end
		if at <= 8 then
			helper_d4b8f712()
		end
		if at <= 9 then
			helper_690ecd8a(30)
		end
		if at <= 10 then
			var4 = 0
			helper_690ecd8a(2)
		end
		if at <= 12 then
			var4 = var4 + 1
			helper_690ecd8a(22)
		end
		if at <= 13 then
			helper_af3fca28(0)
		end
		if at <= 14 then
			helper_af3fca28(1)
		end
		if at <= 15 then
			helper_690ecd8a(30)
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
	event.ObjsSetPos(1, -943.03, 134.76, 0.63)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.CmrsMove(64.12, 205.59, -18.9, -755.14, 157.59, -2.56, 120)
	event.ObjsMove(0, -739.93, 134.76, -3.16, 120)
	event.ObjsMove(1, -739.93, 134.76, -3.16, 120)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 4)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_af3fca28(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_d4b8f712()
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
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
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_af3fca28(1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "立ち（スティーブ）")
	event.ObjsSetMotion(1, "立ち（スティーブ）")
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(7)
	end
	helper_af3fca28(1)
	if vm.skipping() then
		return skip(8)
	end
	helper_d4b8f712()
	if vm.skipping() then
		return skip(9)
	end
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(10)
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
	event.SndSePlay(arg0, 2)
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
		return skip(11)
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
			return skip(12)
		end
		var4 = var4 + 1
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
	helper_690ecd8a(22)
	if vm.skipping() then
		return skip(13)
	end
	event.SndSePlay(arg0, 3)
	event.SndSePlay(arg0, 1)
	event.CmrsSetPos(-261.64, 62.84, 2.96)
	event.CmrsSetRef(-368.77, 78.25, 5.08)
	event.ObjsSetPos(0, -377.87, 50.06, 4.42)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -377.87, 50.06, 4.42)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(14)
	end
	helper_af3fca28(1)
	if vm.skipping() then
		return skip(15)
	end
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(16)
	end
end

return helper_5bdd0aa1
