--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1f64c8ad = require("@lib/event/helper_1f64c8ad")
local helper_24d1805d = require("@lib/event/helper_24d1805d")
local helper_2b169f38 = require("@lib/event/helper_2b169f38")
local helper_2ce9c3c3 = require("@lib/event/helper_2ce9c3c3")
local helper_4bb11812 = require("@lib/event/helper_4bb11812")
local helper_84442dc7 = require("@lib/event/helper_84442dc7")
local helper_8980cad2 = require("@lib/event/helper_8980cad2")
local helper_991317ea = require("@lib/event/helper_991317ea")
local helper_b01f2d7e = require("@lib/event/helper_b01f2d7e")
local helper_d797a244 = require("@lib/event/helper_d797a244")
local helper_f3a90693 = require("@lib/event/helper_f3a90693")

--- Helper function.
local function helper_4645c14a(arg0: s32, arg1: s32, arg2: any, arg3: any)
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local var10: f32 = 0
	local var11: any = 0
	local value: s32 = 0
	local var14: any = 0
	local var15: f32 = 0
	local var17: any = 0
	local argc: s32 = 0
	local count_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_8980cad2(15)
		end
		if at <= 3 then
			helper_2b169f38(0)
		end
		if at <= 4 then
			helper_8980cad2(5)
		end
		if at <= 5 then
			helper_d797a244()
		end
		if at <= 6 then
			var10 = helper_4bb11812(var10)
		end
		if at <= 7 then
			var10 = helper_84442dc7(var10)
		end
		if at <= 8 then
			helper_8980cad2(10)
		end
		if at <= 9 then
			helper_8980cad2(8)
		end
		if at <= 10 then
			helper_8980cad2(10)
		end
		if at <= 11 then
			helper_f3a90693(0, 2230, 8, 256, 208)
		end
		if at <= 12 then
			helper_f3a90693(0, 2231, 8, 256, 208)
		end
		if at <= 13 then
			local _ = helper_24d1805d(0, 2232, 8, 0, 0)
			var11 = helper_1f64c8ad(0, 2, 0, 1)
		end
		if at <= 14 then
			var14 = arg0
			arg0 = arg2
			arg2 = var14
			var14 = arg1
			arg1 = arg3
			arg3 = var14
			var15 = helper_b01f2d7e(16, arg0, var15)
			var15 = helper_b01f2d7e(17, arg2, var15)
			helper_8980cad2(10)
		end
		if at <= 15 then
			helper_8980cad2(60)
		end
		if at <= 16 then
			helper_8980cad2(6)
		end
		if at <= 17 then
			helper_2ce9c3c3(1)
		end
		if at <= 18 then
			helper_991317ea(arg2, count_2)
		end
		if at <= 19 then
			helper_f3a90693(0, -1, 8, 0, 0)
		end
		if at <= 20 then
			var17 = arg2
			helper_991317ea(arg0, count_2)
		end
		if at <= 21 then
			helper_f3a90693(0, -1, 8, 0, 0)
		end
		if at <= 22 then
			var17 = arg0
			helper_8980cad2(10)
		end
		var9 = 0
		var9 = var9 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(529, 1)
	var4 = event.SndLoadSound(8, "snd2/sp/sp_010.sound.json") or var4
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFile(
		arg0,
		1,
		arg2,
		1,
		"event/tbox/p00_27a_ex.gltf",
		"event/tbox/l_box.gltf",
		"event/tbox/r_box.gltf",
		"event/tbox/p00_41a.gltf",
		"event/tbox/p00_27a_ex_l.gltf",
		"event/tbox/p00_27a_ex_r.gltf"
	)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
		var8 = out4 or var8
	end
	event.SetWorldCoord(var5, var6, var7, var8)
	if vm.wait() then
		return skip(2)
	end
	event.SetTbAngle(0.0)
	event.SetTbStatus(2)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 29.0, 57.0)
	event.CmrsSetRef(0.0, 10.0, 0.0)
	event.CmrsMove(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_8980cad2(15)
	if vm.skipping() then
		return skip(3)
	end
	helper_2b169f38(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_8980cad2(5)
	if vm.skipping() then
		return skip(5)
	end
	helper_d797a244()
	if vm.skipping() then
		return skip(6)
	end
	event.LoadChara(5, "event/tbox/p00_27a_ex.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(0, 12)
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "宝箱ピエロ出現", 5)
	event.LoadChara(5, "event/tbox/p00_41a.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(1, 13)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "出現", 5)
	var10 = helper_4bb11812(var10)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var4, 0)
	event.SndSePlay(var4, 1)
	event.CharaActive(12)
	event.EohSetMotion(0, "宝箱ピエロ出現", 6)
	event.CharaActive(13)
	event.ObjsSetMotion(1, "出現", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.CmrsInit()
	event.CmrsPrdelay(4)
	event.CmrsMove2(0.14, 22.84, 83.75, 0.0, 60.0, 0.0, 16, 2, 1.0)
	event.CmrsMove2(0.21, 18.87, 93.0, 0.0, 36.0, 0.0, 20, 0, 1.0)
	var10 = helper_84442dc7(var10)
	if vm.skipping() then
		return skip(8)
	end
	helper_8980cad2(10)
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(0, 12)
	event.LoadChara(5, "event/tbox/p00_27a_ex_r.gltf", "info", 14)
	event.CharaActive(14)
	event.SetCharaPos(14, 0.0, 0.0, 0.0)
	event.SetCharaRot(14, 0.0, 0.0, 0.0)
	event.SetMotion(14, "宝箱発生（右手）", 6)
	event.SetReference(13, "s_pre", 14)
	event.LoadChara(5, "event/tbox/p00_27a_ex_l.gltf", "info", 15)
	event.CharaActive(15)
	event.SetCharaPos(15, 0.0, 0.0, 0.0)
	event.SetCharaRot(15, 0.0, 0.0, 0.0)
	event.SetMotion(15, "宝箱出現（左手）", 6)
	event.SetReference(13, "b_pre", 15)
	event.LoadChara(5, "event/tbox/r_box.gltf", "info", 18)
	event.CharaActive(18)
	event.SetCharaPos(18, 0.0, 0.0, 0.0)
	event.SetCharaRot(18, 0.0, 0.0, 0.0)
	event.SetReference(13, "s_pre", 18)
	event.SetCharaType(18, 4)
	event.LoadChara(5, "event/tbox/l_box.gltf", "info", 19)
	event.CharaActive(19)
	event.SetCharaPos(19, 0.0, 0.0, 0.0)
	event.SetCharaRot(19, 0.0, 0.0, 0.0)
	event.SetReference(13, "b_pre", 19)
	event.SetCharaType(19, 4)
	event.SndSePlay(var4, 2)
	event.SetCharaShow(18, 0)
	event.SetCharaShow(19, 0)
	helper_8980cad2(8)
	if vm.skipping() then
		return skip(10)
	end
	event.SetCharaShow(18, 1, 1, 0.08)
	event.SetCharaShow(19, 1, 1, 0.08)
	helper_8980cad2(10)
	if vm.skipping() then
		return skip(11)
	end
	event.CharaActive(0, 14)
	event.CharaActive(0, 15)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	helper_f3a90693(0, 2230, 8, 256, 208)
	if vm.skipping() then
		return skip(12)
	end
	helper_f3a90693(0, 2231, 8, 256, 208)
	if vm.skipping() then
		return skip(13)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SndSePlay(var4, 3)
	local _ = helper_24d1805d(0, 2232, 8, 0, 0)
	var11 = helper_1f64c8ad(0, 2, 0, 1)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMesPos(0, 0)
	value = event.GetRandInt(100) or value
	if vm.imod(value, 2) == 0 then
		var14 = arg0
		arg0 = arg2
		arg2 = var14
		var14 = arg1
		arg1 = arg3
		arg3 = var14
	end
	event.LoadItem(5, arg0, "info", 16, 1)
	event.CharaActive(0, 16)
	event.SetCharaPos(16, 0.0, 0.0, 0.0)
	event.SetCharaRot(16, 0.0, 0.0, 0.0)
	event.EohSyncChara(6, 16)
	var15 = helper_b01f2d7e(16, arg0, var15)
	event.EohSetScale(6, var15, var15, var15)
	event.LoadItem(5, arg2, "info", 17, 1)
	event.CharaActive(0, 17)
	event.SetCharaPos(17, 0.0, 0.0, 0.0)
	event.SetCharaRot(17, 0.0, 0.0, 0.0)
	event.EohSyncChara(6, 17)
	var15 = helper_b01f2d7e(17, arg2, var15)
	event.EohSetScale(6, var15, var15, var15)
	event.CharaActive(1, 16)
	event.SetReference(13, "s_pre", 16)
	event.CharaActive(1, 17)
	event.SetReference(13, "b_pre", 17)
	event.ObjsSetMotion(1, "中身公開", 2)
	if var11 == 0 then
		event.ObjsNextMotion(1, "大きい宝箱", 2)
		event.ObjsNextMotion(1, "大きい宝箱L", 4)
	else
		event.ObjsNextMotion(1, "小さい宝箱", 2)
		event.ObjsNextMotion(1, "小さい宝箱L", 4)
	end
	helper_8980cad2(10)
	if vm.skipping() then
		return skip(15)
	end
	event.SetCharaShow(18, 0, 1, 0.04)
	event.SetCharaShow(19, 0, 1, 0.04)
	event.SndSePlay(var4, 4)
	event.SndSePlay(var4, 5)
	helper_8980cad2(60)
	if vm.skipping() then
		return skip(16)
	end
	event.SndSePlay(var4, 7)
	helper_8980cad2(6)
	if vm.skipping() then
		return skip(17)
	end
	event.SndSePlay(var4, 6)
	helper_2ce9c3c3(1)
	if vm.skipping() then
		return skip(18)
	end
	if var11 == 0 then
		count_2 = event.CheckGetItemLimit(arg2, arg3) or count_2
		if count_2 >= 1 then
			helper_991317ea(arg2, count_2)
			if vm.skipping() then
				return skip(19)
			end
		else
			event.SetMesWindowMode(0, 4)
			event.SetMesDrawspeed(0, 1)
			event.SetMesItem(0, 1, arg2)
			event.MesMake_2(0, "Hai ricevuto [アイテム１],\nma non hai spazio sufficiente.")
			helper_f3a90693(0, -1, 8, 0, 0)
			if vm.skipping() then
				return skip(20)
			end
		end
		var17 = arg2
	else
		count_2 = event.CheckGetItemLimit(arg0, arg1) or count_2
		if count_2 >= 1 then
			helper_991317ea(arg0, count_2)
			if vm.skipping() then
				return skip(21)
			end
		else
			event.SetMesWindowMode(0, 4)
			event.SetMesDrawspeed(0, 1)
			event.SetMesItem(0, 1, arg0)
			event.MesMake_2(0, "Hai ricevuto [アイテム１],\nma non hai spazio sufficiente.")
			helper_f3a90693(0, -1, 8, 0, 0)
			if vm.skipping() then
				return skip(22)
			end
		end
		var17 = arg0
	end
	event.SetMesDrawspeed(0, 0)
	event.AddItem(var17, count_2)
	argc = event.CheckItemOver() or argc
	if argc >= 1 then
		event.SetFadeOut(10)
		helper_8980cad2(10)
		if vm.skipping() then
			return skip(23)
		end
		event.GotoMenu(17)
		if vm.wait() then
			return skip(24)
		end
	end
	event.CharaActive(0)
	event.DngPause(529, 0)
	var9 = 0
	while var9 <= 7 do
		event.DeleteChara(12 + var9)
		var9 = var9 + 1
	end
	event.SetTbAngle(1.0)
	event.SetCrossfade(10)
	event.Finish()
end

return helper_4645c14a
