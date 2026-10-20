--!strict
-- map/d/d02/d02_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05135b81 = require("@lib/event/helper_05135b81")
local helper_059d36ae = require("@lib/event/helper_059d36ae")
local helper_065641b0 = require("@lib/event/helper_065641b0")
local helper_08ca16f6 = require("@lib/event/helper_08ca16f6")
local helper_1adc7a8f = require("@lib/event/helper_1adc7a8f")
local helper_40515d20 = require("@lib/event/helper_40515d20")
local helper_45c10f71 = require("@lib/event/helper_45c10f71")
local helper_633b4244 = require("@lib/event/helper_633b4244")
local helper_72643bb6 = require("@lib/event/helper_72643bb6")
local helper_73e33ef4 = require("@lib/event/helper_73e33ef4")
local helper_7443da3d = require("@lib/event/helper_7443da3d")
local helper_79d90c82 = require("@lib/event/helper_79d90c82")
local helper_832c49cb = require("@lib/event/helper_832c49cb")
local helper_8cbc13f7 = require("@lib/event/helper_8cbc13f7")
local helper_9c96a6bc = require("@lib/event/helper_9c96a6bc")
local helper_a4e66753 = require("@lib/event/helper_a4e66753")
local helper_bc0b89da = require("@lib/event/helper_bc0b89da")
local helper_bdff4943 = require("@lib/event/helper_bdff4943")
local helper_cb795f9c = require("@lib/event/helper_cb795f9c")
local helper_d1419c31 = require("@lib/event/helper_d1419c31")
local helper_de52ed87 = require("@lib/event/helper_de52ed87")
local helper_dff48a5c = require("@lib/event/helper_dff48a5c")
local helper_e3a29715 = require("@lib/event/helper_e3a29715")
local helper_e8fc0d0d = require("@lib/event/helper_e8fc0d0d")
local helper_fcb18908 = require("@lib/event/helper_fcb18908")

--- Helper function.
local function helper_22d94(arg0: s32)
	local language_code: s32 = 0
	local block: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 2 then
				helper_40515d20()
			end
			if at <= 3 then
				var11 = vm.f32(var11 + vm.f32(0.4))
				helper_72643bb6(90)
			end
			if at <= 4 then
				helper_d1419c31(8510170, -1)
			end
			if at <= 5 then
				helper_72643bb6(20)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if arg0 == 0 then
			event.SetStatusbarShow(1, 1.0)
		end
		event.SetCameraCtrl(1)
		event.SndSeAllStop(7)
		event.SndSeStop(var3, 0)
		event.LoadBgm(193)
		event.PlayBgm(0)
		event.DelExtMotion(0)
		event.DelImg(0)
		event.SetCrossfade(10)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	if arg0 == 0 then
		event.SetStatusbarShow(0, 1.0)
	end
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		event.SetLoadbgFile(
			"dungeon/chara/c02a_win.gltf",
			"textures/dungeon/image/senmetsu/finish.json",
			"snd2/sp/sp_000.sound.json"
		)
	else
		event.SetLoadbgFile(
			"dungeon/chara/c02a_win.gltf",
			"textures/dungeon/image/senmetsu/finish_1.json",
			"snd2/sp/sp_000.sound.json"
		)
	end
	if vm.wait() then
		return skip(2)
	end
	helper_40515d20()
	if vm.skipping() then
		return skip(3)
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMotion(5, "dungeon/chara/c02a_win.gltf", "info", 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if language_code == 0 then
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 228, 64)
		event.SpriteSetUvsize(0, 0, 0, 255, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, arg0)
	else
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish_1.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 512, 64)
		event.SpriteSetUvsize(0, 0, 0, 512, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, arg0)
	end
	event.EohSyncSprite(1, 0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	var3 = event.SndLoadSound(8, "snd2/sp/sp_000.sound.json") or var3
	var4 = event.GetEventInfoSndid(4) or var4
	event.SndSeStop(var4, 0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var11 = event.GetRefAngle(var5, var6, var7, pos_x, pos_y, pos_z) or var11
	var11 = vm.f32(var11 + vm.f32(0.4))
	var11 = event.AngleLimit(var11) or var11
	event.SetCameraCtrl(0)
	event.SetFcameraFollowFlag(1)
	event.SetFcameraFollowA(var5, var6 + 16.0, var7)
	event.SetCameraSpeed(14.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraHeight(-4.0)
	event.SetFcameraDist(48.0)
	event.EohSyncChara(0, 0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "目パチ")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetRot(0, 0.0, var11, 0.0)
	event.ObjsResetDaPosition(0)
	event.SetCrossfade(30)
	event.StopBgm(0)
	event.SndSePlay(var3, 0)
	event.InitDramaScene()
	event.ObjsSetMotion(0, "勝利のポーズ", 6)
	event.ObjsNextMotion(0, "勝利のポーズL", 6, 0.04)
	event.ObjsNextMotion(0, "余韻", 6)
	event.ObjsNextMotion(0, "余韻L", 4)
	event.ObjsSetScale(1, 1.0, 1.0, 0, 60)
	event.ObjsSetColor(1, 128, 128, 128, 128, 60)
	helper_72643bb6(90)
	if vm.skipping() then
		return skip(4)
	end
	if language_code == 0 then
		event.ObjsMove(1, 134.0, 370.0, 0, 20)
	else
		event.ObjsMove(1, 214.0, 370.0, 0, 20)
	end
	event.SetPakuAnim(0, "わらい口パク")
	helper_d1419c31(8510170, -1)
	if vm.skipping() then
		return skip(5)
	end
	helper_72643bb6(20)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

--- Helper function.
local function helper_169dc()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var0 = 0
		var0 = var0 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = 0
	while var0 < 16 do
		event.DeleteChara(8 + var0)
		var0 = var0 + 1
	end
	event.DelImg(0)
	event.SphidaInit()
end

--- Helper function.
local function helper_16b7c()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_169dc()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_169dc()
end

--- Helper function.
local function helper_3eec4(arg0: s32)
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local block: s32 = 0
	local var8: s32 = 0
	local var9: s32 = 0
	local active_chr_no: s32 = 0
	local var12: f32 = 0
	local var13: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 12 then
			if at <= 1 then
				var5 = vm.f32(var5 + vm.f32(1.5707964))
				helper_72643bb6(30)
			end
			if at <= 2 then
				helper_059d36ae(0)
			end
			if at <= 3 then
				helper_72643bb6(30)
			end
			if at <= 4 then
				helper_059d36ae(0)
			end
			if at <= 5 then
				helper_72643bb6(14)
			end
			if at <= 6 then
				helper_72643bb6(16)
			end
			if at <= 7 then
				helper_059d36ae(0)
			end
			if at <= 8 then
				helper_72643bb6(30)
			end
			if at <= 9 then
				helper_9c96a6bc()
			end
			if at <= 10 then
				var12 = vm.f32(var12 - vm.f32(3.1415927))
				helper_059d36ae(0)
			end
			if at <= 11 then
				helper_72643bb6(15)
			end
			if vm.skip_end() then
				return skip(13)
			end
			return part2()
		end
		if at <= 14 then
			helper_40515d20()
		end
		if at <= 16 then
			helper_40515d20()
		end
		if at <= 18 then
			helper_40515d20()
		end
		if at <= 19 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
		if at <= 20 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
		if at <= 21 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
		if at <= 22 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
		if at <= 23 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
		if at <= 24 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeIn(0)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetMotion(0, "立ち")
		event.EohSetPos(0, -170.0, 0.0, 50.0)
		event.EohSetRot(0, 0.0, -1.57, 0.0)
		event.EohResetDaPosition(0)
		event.SetCameraRef(-170.0, 30.0, 50.0)
		event.SetCameraPos(-70.0, 35.0, 50.0)
		event.ResetCamera(0)
		event.DelExtMotion(0)
		if arg0 ~= 0 then
			event.DngmapOnoff(0)
			event.DngmapDelete()
		end
		event.DelImg(0)
		event.Initialize()
		if var6 ~= 0 then
			event.SpriteInit(0)
			event.SpriteSetType(0, 0)
			if bit32.band(var6, 1) ~= 0 then
				event.SetLoadbgFile("textures/dungeon/image/seal/aka_fuuin_1.json", "snd2/sp/sp_050.sound.json")
				if vm.wait() then
					return skip(14)
				end
				helper_40515d20()
				if vm.skipping() then
					return skip(15)
				end
				block = event.LoadImg_4(5, "textures/dungeon/image/seal/aka_fuuin_1.json", 0) or block
				event.SpriteSetTexture(0, "aka_fuuin", block)
			end
			if bit32.band(var6, 2) ~= 0 then
				event.SetLoadbgFile("textures/dungeon/image/seal/ao_fuuin_1.json", "snd2/sp/sp_050.sound.json")
				if vm.wait() then
					return skip(16)
				end
				helper_40515d20()
				if vm.skipping() then
					return skip(17)
				end
				block = event.LoadImg_4(5, "textures/dungeon/image/seal/ao_fuuin_1.json", 0) or block
				event.SpriteSetTexture(0, "ao_fuuin", block)
			end
			if bit32.band(var6, 4) ~= 0 then
				event.SetLoadbgFile("textures/dungeon/image/seal/shiro_fuuin_1.json", "snd2/sp/sp_050.sound.json")
				if vm.wait() then
					return skip(18)
				end
				helper_40515d20()
				if vm.skipping() then
					return skip(19)
				end
				block = event.LoadImg_4(5, "textures/dungeon/image/seal/shiro_fuuin_1.json", 0) or block
				event.SpriteSetTexture(0, "shiro_fuuin", block)
			end
			event.SpriteSetColor(0, 128, 128, 128, 0)
			event.SpriteSetUvsize(0, 0, 0, 512, 128)
			event.SpriteSetPutsize(0, 512, 128)
			event.SpriteSetPos(0, 256, 156)
			event.SpriteSetDraw(0, 1)
			event.EohSyncSprite(0, 0)
			event.ObjsInit(0)
			event.ObjsSyncObj(0, 0)
			event.ObjsSetColor(0, 128, 128, 128, 128, 30)
			var13 = event.SndLoadSound(8, "snd2/sp/sp_050.sound.json") or var13
			event.SndSePlay(var13, 0)
			event.SetMesWindowMode(0, 4)
			if bit32.band(var6, 1) ~= 0 then
				event.MesMake_2(0, "Pare ci sia un Sigillo rosso sul piano.")
				helper_065641b0(0, -1, 8, 0, 0)
				if vm.skipping() then
					return skip(20)
				end
				event.MesMake_2(0, "Max ha l'Atlamillia rossa.\nNon puoi passare a lui!")
				helper_065641b0(0, -1, 8, 0, 0)
				if vm.skipping() then
					return skip(21)
				end
			end
			if bit32.band(var6, 2) ~= 0 then
				event.MesMake_2(0, "Pare ci sia un Sigillo blu sul piano.")
				helper_065641b0(0, -1, 8, 0, 0)
				if vm.skipping() then
					return skip(22)
				end
				event.MesMake_2(0, "Monica ha l'Atlamillia blu.\nNon puoi passare a lei!")
				helper_065641b0(0, -1, 8, 0, 0)
				if vm.skipping() then
					return skip(23)
				end
			end
			if bit32.band(var6, 4) ~= 0 then
				event.MesMake_2(0, "Pare ci sia un Sigillo bianco sul piano.")
				helper_065641b0(0, -1, 8, 0, 0)
				if vm.skipping() then
					return skip(24)
				end
				event.MesMake_2(
					0,
					"Non [UNI00e8] pi[UNI00f9] possibile ripristinare\nla salute o curare stati alterati."
				)
				helper_065641b0(0, -1, 8, 0, 0)
				if vm.skipping() then
					return skip(25)
				end
			end
			event.SpriteSetDraw(0, 0)
			event.DelImg(0)
		end
		event.DngPause(1, 0)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.InitDramaScene()
	event.DngPause(1, 1)
	var1 = event.SndLoadSound(8, "snd2/sp/sp_031.sound.json") or var1
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(2)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	var5 = vm.f32(var5 + vm.f32(1.5707964))
	var5 = event.AngleLimit(var5) or var5
	event.SetWorldCoord(var2, var3, var4, var5)
	var6 = event.GetFloorStatus() or var6
	if var6 ~= 0 then
		if bit32.band(var6, 1) ~= 0 then
			event.DngSetupMainUnit(1)
		end
		if bit32.band(var6, 2) ~= 0 then
			event.DngSetupMainUnit(0)
		end
	end
	if arg0 ~= 0 then
		var8 = event.DngGetFloorId() or var8
		var9 = event.DngGetPrevFloor() or var9
		event.DngmapLoad(5, 0, 1, var8, var9)
		event.DngmapSetFade(1, 30)
	else
		event.LoadImg_3(5, "textures/dungeon/image/s_title/logo_d01_1.json", 0)
		event.ImgSetName(0, "logo_d01")
		event.ImgSetGet(0, 0, 0, 384, 128)
		event.ImgSetPut(0, -24, 300, 384, 128)
		event.ImgSetColor(0, 128, 128, 128, 0)
		event.ImgSetDraw(1, 0)
		event.ImgSetFade(0, 1, 60)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.LoadMotion(5, "dungeon/chara/mints_01in.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/monica_01in.gltf", "info", 0)
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 116.96, 18.76, 19.22)
	event.ObjsSetRot(0, 0.0, -1.96, 0.0)
	event.ObjsSeDelay(0, 1)
	event.ObjsResetDaPosition(0)
	event.EohSetFootSoundId(0, 3)
	event.SetStatusbarShow(0, 1.0)
	event.CmrsInit()
	event.CmrsSetPos(173.18, 55.5, 1.04)
	event.CmrsSetRef(50.97, 32.07, 20.9)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	if active_chr_no == 0 then
		event.CmrsMove2(137.93, 48.95, 6.77, 50.97, 32.07, 20.9, 160, 2, 0.4)
		event.ObjsMove(0, 23.61, 18.53, -17.13, 140)
		event.ObjsSetMotion(0, "丸太歩き", 4)
		event.ObjsRotDelay(0, 130)
		event.ObjsRotation(0, 0.0, -1.0, 0.0, 10)
		if arg0 ~= 0 then
			helper_72643bb6(30)
			if vm.skipping() then
				return skip(2)
			end
			event.DngmapMovePiece(1)
		end
		helper_059d36ae(0)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsSetMotion(0, "ジャンプ", 2)
		event.ObjsNextMotion(0, "ジャンプ中", 6, 0.3)
		event.ObjsNextMotion(0, "着地", 6)
	else
		event.CmrsMove2(137.93, 48.95, 6.77, 50.97, 32.07, 20.9, 100, 2, 0.4)
		event.ObjsMove(0, 23.61, 18.53, -17.13, 60)
		event.ObjsSetMotion(0, "丸太歩き", 4)
		event.ObjsRotDelay(0, 50)
		event.ObjsRotation(0, 0.0, -1.0, 0.0, 10)
		if arg0 ~= 0 then
			helper_72643bb6(30)
			if vm.skipping() then
				return skip(4)
			end
			event.DngmapMovePiece(1)
		end
		helper_059d36ae(0)
		if vm.skipping() then
			return skip(5)
		end
		event.ObjsSetMotion(0, "ジャンプ", 2)
		event.ObjsNextMotion(0, "ジャンプ中", 6, 0.2)
		event.ObjsNextMotion(0, "着地", 6)
	end
	event.EohSetFootSoundId(0, 16)
	helper_72643bb6(14)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var1, 2)
	event.ObjsJump(0, -85.0, 0.0, 50.0, -0.25, 30)
	event.ObjsRotDelay(0, 10)
	event.ObjsRotation(0, 0.0, -1.57, 0.0, 20)
	helper_72643bb6(16)
	if vm.skipping() then
		return skip(7)
	end
	if arg0 ~= 0 then
		event.DngmapSetFade(0, 60)
	else
		event.ImgSetFade(0, 0, 60)
	end
	helper_059d36ae(0)
	if vm.skipping() then
		return skip(8)
	end
	event.SndSePlay(var1, 4)
	helper_72643bb6(30)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -170.0, 0.0, 50.0, 50)
	helper_9c96a6bc()
	if vm.skipping() then
		return skip(10)
	end
	event.SetCrossfade(30)
	do
		local _, out2, _ = event.EohGetRot(0)
		var12 = out2 or var12
	end
	event.CmrsSetRef(-170.0, 30.0, 50.0)
	var12 = vm.f32(var12 - vm.f32(3.1415927))
	var12 = event.AngleLimit(var12) or var12
	event.CmrsSetAhd(var12, 5.0, 100.0)
	event.SetStatusbarShow(1)
	helper_059d36ae(0)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_72643bb6(15)
	if vm.skipping() then
		return skip(12)
	end
	return part2()
end

--- Helper function.
local function helper_16358()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.ActchrSetDefMotion(0)
end

--- Helper function.
local function helper_16bf0(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return arg0, arg1, arg2, arg3
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = event.GetEventData_2(9) or var4
	event.EohSyncObj(0, var4)
	do
		local out1, out2, out3 = event.EohGetPos(0)
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	arg3 = vm.bits_float(event.GetEventData_2(11)) or arg3
	return arg0, arg1, arg2, arg3
end

--- Helper function.
local function helper_42aa4()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_40515d20()
		end
		if at <= 3 then
			var0, var1, var2, var3 = helper_16bf0(var0, var1, var2, var3)
			var7 = 0
			var7 = var7 + 1
		end
		if at <= 4 then
			var7 = 0
			var7 = var7 + 1
		end
		if at <= 5 then
			helper_72643bb6(20)
		end
		if at <= 6 then
			helper_72643bb6(37)
		end
		if at <= 7 then
			var9 = vm.f32(-0.001)
			var8 = 0.0
			var9 = vm.f32(var9 * vm.f32(1.06))
			var8 = vm.f32(var8 + var9)
		end
		if at <= 8 then
			var7 = 0
			var9 = vm.f32(var9 * vm.f32(0.6))
			var8 = vm.f32(var8 - var9)
		end
		if at <= 9 then
			var9 = vm.f32(var9 + vm.f32(-0.001))
			var9 = vm.f32(var9 * vm.f32(1.2))
			var8 = vm.f32(var8 + var9)
		end
		if at <= 10 then
			var7 = var7 + 1
			helper_72643bb6(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFile("snd2/sp/sp_031.sound.json")
	if vm.wait() then
		return skip(2)
	end
	helper_40515d20()
	if vm.skipping() then
		return skip(3)
	end
	var0, var1, var2, var3 = helper_16bf0(var0, var1, var2, var3)
	event.SetWorldCoord(var0, var1, var2, var3)
	var4 = event.SndLoadSound(8, "snd2/sp/sp_031.sound.json") or var4
	var5 = event.GetEventData_2(9) or var5
	event.EohSyncObj(0, var5, "d02w10_4-m0")
	event.EohSyncObj(1, var5, "d02w10_3-m0")
	event.EohSetShow(1, 1)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "event/dng/g01_gkey.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(2, 12)
	event.EohSetPos(2, 0.0, 0.0, 145.0)
	event.EohSetMotion(2, "発動", 5)
	event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
	var6 = vm.bits_float(event.GetEventData_2(11)) or var6
	var7 = 0
	while var7 < 10 do
		event.CtrlcRotBack(var6)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		var7 = var7 + 1
		if vm.wait() then
			return skip(4)
		end
	end
	event.SndSePlay(var4, 0)
	event.EohSetMotion(2, "発動", 6)
	var7 = 0
	while var7 < 20 do
		event.CtrlcRotBack(var6)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		var7 = var7 + 1
		if vm.wait() then
			return skip(5)
		end
	end
	helper_72643bb6(20)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetShow(0, 0)
	helper_72643bb6(37)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var4, 1)
	var9 = vm.f32(-0.001)
	var8 = 0.0
	while var8 > vm.f32(-1.57) do
		event.ObjsSetRot(1, var8, var3, 0.0)
		var9 = vm.f32(var9 * vm.f32(1.06))
		var8 = vm.f32(var8 + var9)
		if vm.wait() then
			return skip(8)
		end
	end
	event.SndSePlay(var4, 5)
	var7 = 0
	while var7 < 3 do
		while true do
			var9 = vm.f32(var9 * vm.f32(0.6))
			var8 = vm.f32(var8 - var9)
			event.ObjsSetRot(1, var8, var3, 0.0)
			if var9 > vm.f32(-0.001) then
				break
			else
				if vm.wait() then
					return skip(9)
				end
			end
		end
		var9 = vm.f32(var9 + vm.f32(-0.001))
		while true do
			var9 = vm.f32(var9 * vm.f32(1.2))
			var8 = vm.f32(var8 + var9)
			event.ObjsSetRot(1, var8, var3, 0.0)
			if var8 < vm.f32(-1.57) then
				break
			else
				if vm.wait() then
					return skip(10)
				end
			end
		end
		var7 = var7 + 1
	end
	helper_72643bb6(10)
	if vm.skipping() then
		return skip(11)
	end
	event.DeleteChara(12)
	event.ResetCamera(0)
	event.Finish()
end

--- Helper function.
local function helper_1589c()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				var1 = 86
				var1 = 64
			end
			return
		end
		if at <= 3 then
			helper_059d36ae(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.LoadMotion(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
		var1 = 86
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
		var1 = 64
	end
	if active_chr_no == 2 or active_chr_no == 3 then
		if vm.wait() then
			return skip(2)
		end
		event.Finish()
		return
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.EohGetRot(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsReference(0, pos_x, pos_y, pos_z, 6)
	helper_059d36ae(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "だめだめ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsRotDelay(0, var1)
	event.ObjsRotation(0, rot_x, rot_y, rot_z, 6)
	helper_059d36ae(0)
	if vm.skipping() then
		return skip(4)
	end
	if active_chr_no == 0 or active_chr_no == 1 then
		event.DelExtMotion(0)
	end
	event.Finish()
end

--- Helper function.
local function helper_43a28()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_40515d20()
		end
		if at <= 3 then
			var2, var3, var4, var5 = helper_16bf0(var2, var3, var4, var5)
			helper_72643bb6(8)
		end
		if at <= 4 then
			helper_72643bb6(26)
		end
		if at <= 5 then
			helper_059d36ae(0)
		end
		if at <= 6 then
			helper_72643bb6(5)
		end
		if at <= 7 then
			helper_72643bb6(60)
		end
		if at <= 8 then
			helper_9c96a6bc()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.SetLoadbgFile("dungeon/chara/mints_01in.gltf", "snd2/sp/sp_031.sound.json")
	end
	if active_chr_no == 1 then
		event.SetLoadbgFile("dungeon/chara/monica_01in.gltf", "snd2/sp/sp_031.sound.json")
	end
	if vm.wait() then
		return skip(2)
	end
	helper_40515d20()
	if vm.skipping() then
		return skip(3)
	end
	var1 = event.SndLoadSound(8, "snd2/sp/sp_031.sound.json") or var1
	event.AssignStack(5)
	event.ClearStack(5)
	var2, var3, var4, var5 = helper_16bf0(var2, var3, var4, var5)
	event.SetWorldCoord(var2, var3, var4, var5)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 0.0, 183.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsResetDaPosition(0)
	event.EohSetFootSoundId(0, 3)
	if active_chr_no == 0 then
		event.LoadMotion(5, "dungeon/chara/mints_01in.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/monica_01in.gltf", "info", 0)
	end
	event.CmrsInit()
	event.CmrsSetPos(-32.1, 44.57, 270.0)
	event.CmrsSetRef(7.73, 34.2, 52.8)
	event.CmrsMove2(-23.76, 44.57, 224.57, 7.73, 34.2, 52.8, 90, 1, 1.0)
	event.ObjsSetMotion(0, "ジャンプ", 6)
	event.ObjsNextMotion(0, "ジャンプ中", 6, 0.3)
	event.ObjsNextMotion(0, "d01着地", 6)
	if active_chr_no == 0 then
		event.ObjsNextMotion(0, "旧・立ち", 4)
	else
		event.ObjsNextMotion(0, "立ち", 4)
	end
	helper_72643bb6(8)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var1, 2)
	event.ObjsJump(0, 0.0, 29.88, 127.4, -0.2, 26)
	helper_72643bb6(26)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var1, 3)
	helper_059d36ae(0)
	if vm.skipping() then
		return skip(6)
	end
	helper_72643bb6(5)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsMove(0, 0.0, 27.83, 35.0, 90)
	event.ObjsSetMotion(0, "歩き")
	helper_72643bb6(60)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	event.EohSetFootSoundId(0, -1)
	helper_9c96a6bc()
	if vm.skipping() then
		return skip(9)
	end
end

--- Helper function.
local function helper_163d8(arg0: s32, arg1: s32, arg2: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_065641b0(0, 2750, 8, 0, 0)
		end
		if at <= 2 then
			helper_065641b0(0, 2760, 8, 0, 0)
		end
		if at <= 3 then
			helper_065641b0(0, vm.i32(2700 + arg2), 8, 0, 0)
		end
		if at <= 4 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_065641b0(0, 2760, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	if arg0 == 1 or arg0 == 2 then
		helper_065641b0(0, 2750, 8, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	if arg0 == 1 and arg1 ~= 2 then
		argc = event.GetSysSndId() or argc
		event.SndSePlay(argc, 18)
		helper_065641b0(0, 2760, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if arg1 == 2 or arg1 == 3 then
		helper_065641b0(0, vm.i32(2700 + arg2), 8, 0, 0)
		if vm.skipping() then
			return skip(4)
		end
	end
	if arg0 == 1 and arg1 == 2 then
		argc_2 = event.GetSysSndId() or argc_2
		event.SndSePlay(argc_2, 18)
		event.MesMake_2(0, "Hai ottenuto 2 Medaglie!")
		helper_065641b0(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	elseif arg1 == 2 then
		argc_3 = event.GetSysSndId() or argc_3
		event.SndSePlay(argc_3, 18)
		helper_065641b0(0, 2760, 8, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
	end
end

--- Helper function.
local function helper_16d54(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var2 = var2 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetFloorInfo(arg0, arg1, 7) or var2
	var2 = vm.i32(var2 + 1)
	event.SetFloorInfo(arg0, arg1, 7, var2)
end

--- Helper function.
local function helper_1099c()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 24 then
			if at <= 1 then
				helper_72643bb6(30)
			end
			if at <= 2 then
				helper_065641b0(0, -1, 8, 512, 0)
			end
			if at <= 3 then
				helper_059d36ae(1)
			end
			if at <= 4 then
				helper_065641b0(0, -1, 8, 0, 0)
			end
			if at <= 5 then
				helper_065641b0(0, -1, 8, 512, 0)
			end
			if at <= 6 then
				helper_065641b0(0, -1, 8, 512, 0)
			end
			if at <= 7 then
				helper_059d36ae(1)
			end
			if at <= 8 then
				helper_065641b0(0, -1, 8, 256, 0)
			end
			if at <= 9 then
				helper_065641b0(0, -1, 8, 0, 0)
			end
			if at <= 10 then
				helper_059d36ae(0)
			end
			if at <= 11 then
				helper_065641b0(0, -1, 8, 80, 0)
			end
			if at <= 12 then
				helper_065641b0(0, -1, 8, 384, 0)
			end
			if at <= 13 then
				helper_065641b0(0, -1, 8, 256, 0)
			end
			if at <= 14 then
				helper_065641b0(0, -1, 8, 256, 0)
			end
			if at <= 15 then
				helper_059d36ae(1)
			end
			if at <= 16 then
				helper_065641b0(0, -1, 8, 256, 0)
			end
			if at <= 17 then
				helper_065641b0(0, -1, 8, 256, 0)
			end
			if at <= 18 then
				helper_059d36ae(1)
			end
			if at <= 19 then
				helper_065641b0(0, -1, 8, 0, 0)
			end
			if at <= 20 then
				helper_065641b0(0, -1, 8, 512, 0)
			end
			if at <= 21 then
				helper_059d36ae(1)
			end
			if at <= 22 then
				helper_065641b0(0, -1, 8, 0, 0)
			end
			if at <= 23 then
				helper_72643bb6(30)
			end
			if vm.skip_end() then
				return skip(25)
			end
			return part2()
		end
		if at <= 25 then
			var6 = 0
			var6 = 1
			helper_e8fc0d0d(0)
		end
		if at <= 26 then
			helper_72643bb6(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DngPause(145, 0)
		event.EohSetShow(3, 1)
		event.EohSetShow(2, 1)
		event.CharaActive(0)
		event.DelReference(11)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DelImg(0)
		if active_chr_no == 0 then
			var6 = 0
		else
			var6 = 1
		end
		event.EohSetMotion(var6, "立ち")
		event.EohSetPos(var6, 50.0, 0.0, 170.0)
		event.EohSetRot(var6, 0.0, 0.0, 0.0)
		event.EohResetDaPosition(var6)
		event.SetCameraRef(50.0, 30.0, 170.0)
		event.SetCameraPos(50.0, 30.0, 70.0)
		event.ResetCamera(0)
		event.SetStatusbarShow(1, 1.0)
		helper_e8fc0d0d(0)
		if vm.skipping() then
			return skip(26)
		end
		event.StopBgm(0)
		helper_72643bb6(4)
		if vm.skipping() then
			return skip(27)
		end
		event.LoadBgm(16)
		event.PlayBgm(0)
		event.LoadMonsterFile(0)
		event.AutoSetTreasureBox(-1)
		event.AutoSetMonster(-1)
		event.SetFadeIn(30)
		event.Finish()
	end
	event.SetFlag(212, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(2)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
		var3 = out4 or var3
	end
	event.SetWorldCoord(var0, var1, var2, var3)
	event.DngPause(17, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.StopBgm(0)
	helper_72643bb6(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(48)
	event.PlayBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e200/e212/")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e212_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e212_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e212_crystal.gltf", "info", 11)
	event.CharaActive(0, 11)
	block = event.LoadImg_4(5, "e212_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e21201", block)
	event.SpriteSetColor(0, 128, 128, 128, 128)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 0)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e21202", block)
	event.SpriteSetColor(1, 128, 128, 128, 128)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 0)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadEquip(5, 0, 0, "info", 8, 10)
		event.LoadMotion(5, "event/e200/e212/e212_mints.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e200/e212/e212_monica.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(0, 10)
	if active_chr_no == 0 then
		event.SetReference(8, "item", 11)
	else
		event.SetReference(0, "item", 11)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.EohSetPos(0, 67.73, 0.0, 94.65)
	event.EohSetRot(0, 0.0, -2.74, 0.0)
	event.Ext(706, 0, "立ち", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 49.9, 0.0, 78.02)
	event.EohSetRot(1, 0.0, 0.86, 0.0)
	event.Ext(706, 1, "立ち", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.InitDramaScene()
	event.SetStatusbarShow(0, 1.0)
	event.CmrsInit()
	event.CmrsSetPos(67.03, 24.86, 49.63)
	event.CmrsSetRef(59.75, 21.85, 81.53)
	event.SetFadeIn(30)
	helper_72643bb6(30)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	event.MesMake_2(
		0,
		"Non so, Max. Se non hai altro\nper difenderti, sar[UNI00e0] dura contro\ni mostri di questa foresta."
	)
	helper_065641b0(0, -1, 8, 512, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_059d36ae(1)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(0, "通常口パク")
	event.MesMake_2(0, "Credi davvero?")
	helper_065641b0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(1, "通常口パク")
	event.MesMake_2(0, "Certo.")
	helper_065641b0(0, -1, 8, 512, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.CharaActive(1, 11)
	event.SetCharaShow(11, 1, 1, 0.1)
	event.ObjsSetMotion(1, "渡す", 6)
	event.ObjsNextMotion(1, "渡すL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	event.MesMake_2(0, "Ecco. Prendi.")
	helper_065641b0(0, -1, 8, 512, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_059d36ae(1)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(56.78, 23.01, 68.1)
	event.CmrsSetRef(67.82, 21.85, 95.09)
	event.DelReference(11)
	if active_chr_no == 0 then
		event.SetReference(0, "item", 11)
	else
		event.SetReference(8, "item", 11)
	end
	event.ObjsSetMotion(0, "クリスタルゲット", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク", "半口")
	event.MesMake_2(0, "Cosa sono?!")
	helper_065641b0(0, -1, 8, 256, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "モニカ見る", 6)
	event.ObjsNextMotion(0, "モニカ見るL", 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"Hai ricevuto 2 Cristalli Predoni,\n2 Cristalli-devasta,<page>1 Cristallo Vento\ne 1 Cristallo Drago marino."
	)
	helper_065641b0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	helper_059d36ae(0)
	if vm.skipping() then
		return skip(11)
	end
	event.EohSetTexAnim(0, 0, "半口")
	event.CmrsSetPos(97.82, 22.3, 89.1)
	event.CmrsSetRef(34.74, 20.28, 87.84)
	event.SetMesWindowMode(0, 1)
	event.ObjsSetRot(0, 0.0, -2.38, 0.0)
	event.ObjsResetDaPosition(0)
	event.SetPakuAnim(0, "通常口パク")
	event.MesMake_2(0, "Wow! Che abbondanza!")
	helper_065641b0(0, -1, 8, 80, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(1, "わらい口パク")
	event.MesMake_2(0, "S[UNI00ec]! Con quelli puoi potenziare la\nChiave inglese e darle pi[UNI00f9] mordente.")
	helper_065641b0(0, -1, 8, 384, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(84.11, 24.45, 108.87)
	event.CmrsSetRef(53.38, 24.14, 80.91)
	event.CharaActive(0, 11)
	if active_chr_no == 0 then
		event.CharaActive(0, 0)
	else
		event.CharaActive(0, 8)
		event.CharaActive(0, 9)
	end
	event.DngPause(128, 1)
	event.SetCrossfade(10)
	event.SpriteSetDraw(0, 2)
	event.ObjsSetMotion(1, "指立て", 6)
	event.ObjsNextMotion(1, "指立て会話", 6)
	event.ObjsNextMotion(1, "指立てL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	event.MesMake_2(0, "Scegli un cristallo dal\nMenu Oggetti e Spettralizzalo.")
	helper_065641b0(0, -1, 8, 256, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(1, "わらい口パク")
	event.MesMake_2(0, "Sintetizzalo con l'arma\nche vuoi potenziare.")
	helper_065641b0(0, -1, 8, 256, 0)
	if vm.skipping() then
		return skip(15)
	end
	helper_059d36ae(1)
	if vm.skipping() then
		return skip(16)
	end
	event.SetCrossfade(30)
	event.SpriteSetDraw(1, 2)
	event.ObjsSetMotion(1, "戻り", 6)
	event.ObjsNextMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	event.MesMake_2(0, "Raggiunto il livello superiore,\npotrai usare il comando Potenzia.")
	helper_065641b0(0, -1, 8, 256, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetPakuAnim(1, "わらい口パク")
	event.MesMake_2(0, "Quello trasformer[UNI00e0] la tua Chiave\ninglese in un'arma formidabile!")
	helper_065641b0(0, -1, 8, 256, 0)
	if vm.skipping() then
		return skip(18)
	end
	helper_059d36ae(1)
	if vm.skipping() then
		return skip(19)
	end
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.DngPause(128, 0)
	event.SetCrossfade(10)
	event.CmrsSetPos(91.98, 18.44, 61.76)
	event.CmrsSetRef(51.13, 20.11, 92.81)
	if active_chr_no == 0 then
		event.CharaActive(0)
		event.EohSetShow(2, 1)
	else
		event.CharaActive(8)
		event.CharaActive(9)
		event.CharaActive(10)
	end
	event.ObjsSetMotion(0, "武器持ち立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	event.MesMake_2(0, "Va bene.")
	helper_065641b0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(1, "カチャカチャ", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	event.MesMake_2(0, "Prova! E questo [UNI00e8] un piccolo\nextra da parte mia. [heart].")
	helper_065641b0(0, -1, 8, 512, 0)
	if vm.skipping() then
		return skip(21)
	end
	helper_059d36ae(1)
	if vm.skipping() then
		return skip(22)
	end
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "La Chiave inglese ha 6 Punti\nSintesi in pi[UNI00f9].")
	helper_065641b0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(23)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_72643bb6(30)
	if vm.skipping() then
		return skip(24)
	end
	return part2()
end

--- Helper function.
local function helper_16e88()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SndLoadSound(4, "snd2/event/ev_200_000.sound.json")
end

--- Helper function.
local function helper_162a8()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.ResetSubjectCounter(-1)
	event.SetFloorEpisode(1)
end

--- Program 1010.
local function program_1010()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_4: s32 = 0
	local value: s32 = 0
	local var9: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	local landing2: () -> ...any
	local landing3: () -> ...any
	local landing4: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_16b7c()
			end
			if at <= 2 then
				helper_16d54(stage_id, var1)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_72643bb6(6)
		end
		if at <= 6 then
			helper_3eec4(0)
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 7 then
			helper_3eec4(0)
			if not vm.skipping() then
				return landing2()
			end
		end
		if at <= 8 then
			helper_3eec4(0)
			if not vm.skipping() then
				return landing3()
			end
		end
		if at <= 9 then
			helper_3eec4(1)
			if not vm.skipping() then
				return landing4()
			end
		end
		helper_16e88()
		helper_162a8()
	end
	function part2()
		helper_16e88()
		helper_162a8()
	end
	function landing1()
		return part2()
	end
	function landing2()
		return part2()
	end
	function landing3()
		return part2()
	end
	function landing4()
		return part2()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	helper_16b7c()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(2)
	end
	event.ActchrSetDefMotion(0)
	stage_id = event.DngGetStageId() or stage_id
	var1 = event.DngGetFloorId() or var1
	var2 = event.GetFloorInfo(stage_id, var1, 7) or var2
	helper_16d54(stage_id, var1)
	event.DngFloorInit()
	if var1 == 0 then
		event.GotoEdit(16)
		if vm.wait() then
			return skip(3)
		end
		return
	end
	if var1 == 6 then
		event.BgmPlayCancel()
		event.GotoEdit(65, 100)
		if vm.wait() then
			return skip(4)
		end
		return
	end
	if var1 == 12 then
		event.BgmLoadCancel()
		event.LoadDungeonMapFile("s13")
		event.LoadScript("s13/s13.stb", 100)
		return
	end
	if var1 == 15 then
		event.BgmLoadCancel()
		flag = event.GetFlag(257) or flag
		flag_2 = event.GetFlag(260) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			event.LoadDungeonMapFile("d02b02")
			event.LoadScript("d02b02/d02b02.stb", 200)
		else
			event.LoadDungeonMapFile("d02b01")
			event.LoadScript("d02b01/d02b01.stb", 200)
		end
		return
	end
	event.GetEquipItemno(0, 0)
	event.GetFlag(49)
	flag_4 = event.GetFlag(212) or flag_4
	if var1 == 2 and flag_4 == 0 then
		event.BgmLoadCancel()
		event.LoadDungeonMapFile("d02f01", "d02f01", 1)
		event.AddItem(178, 2)
		event.AddItem(180, 2)
		event.AddItem(181, 1)
		event.AddItem(182, 1)
		event.AddFusionPoint(0, 0, 6)
		helper_1099c()
		if vm.skipping() then
			return skip(5)
		end
	else
		if var1 == 14 then
			event.BgmLoadEnable()
			event.StopBgm(0)
			helper_72643bb6(6)
			if vm.skipping() then
				return skip(6)
			end
			event.LoadBgm(37)
			event.BgmLoadCancel()
		end
		if var1 >= 9 and var1 <= 11 then
			event.LoadDungeonMapFile("d02f01s", "d02f01", 1)
		else
			value = event.GetRandInt(100) or value
			if vm.imod(value, 8) == 0 then
				event.LoadDungeonMapFile("d02f01r", "d02f01", 1)
				event.DngSetWeather(2)
			else
				event.LoadDungeonMapFile("d02f01", "d02f01", 1)
			end
		end
		event.LoadMonsterFile(0)
		event.AutoSetTreasureBox(-1)
		event.AutoSetMonster(-1)
		event.PlayBgm(0)
		if var1 == 100 then
			helper_3eec4(0)
			if vm.skipping() then
				return skip(7)
			end
		elseif var1 == 1 and var2 <= 0 then
			helper_3eec4(0)
			if vm.skipping() then
				return skip(8)
			end
		else
			var9 = event.DngGetPrevFloor() or var9
			if var1 == var9 then
				helper_3eec4(0)
				if vm.skipping() then
					return skip(9)
				end
			else
				helper_3eec4(1)
				if vm.skipping() then
					return skip(10)
				end
			end
		end
	end
	return part2()
end

--- Program 1000.
local function program_1000()
	local var0: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			program_1010()
		end
	end
	event.Initialize()
	event.SphidaInit()
	helper_16b7c()
	event.SetFadeOut(0)
	var0 = event.GetBgmNo() or var0
	if var0 ~= 16 then
		event.StopBgm(0)
		helper_72643bb6(6)
		if vm.skipping() then
			return skip(1)
		end
		event.LoadBgm(16)
	end
	event.PlayBgm(0)
	event.LoadSound(2601)
	event.SetLocalFlag(0, 0)
	event.SetLocalFlag(1, 0)
	event.SetLocalFlag(2, 0)
	event.SetLocalFlag(3, 0)
	event.SetLocalFlag(4, 0)
	event.GotoDngMap(1)
	if vm.wait() then
		return skip(2)
	end
	event.SetProjection(524.9)
	do
		local _, out2, out3, _ = event.GetMenuParam_4()
		var2 = out2 or var2
		var3 = out3 or var3
	end
	event.DngSetFloorId(var3)
	event.DngSetPrevFloor(var2)
	program_1010()
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_44604(arg0: s32)
	local argc: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local var6: any = 0
	local var7: s32 = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local stage_id: s32 = 0
	local var11: s32 = 0
	local argc_2: s32 = 0
	local var14: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				var2 = 2
				helper_72643bb6(6)
			end
			if at <= 3 then
				helper_42aa4()
			end
			if at <= 4 then
				helper_1589c()
			end
			if at <= 5 then
				helper_72643bb6(6)
			end
			if at <= 6 then
				helper_16358()
				helper_065641b0(0, 20, 5, 256, 208)
			end
			if at <= 7 then
				helper_065641b0(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 12 then
			if at <= 9 then
				helper_169dc()
				helper_43a28()
			end
			if at <= 10 then
				helper_163d8(-1, cleared, bonus)
			end
			return
		end
	end
	event.Initialize()
	helper_16358()
	argc = event.GetLocalFlag(arg0) or argc
	event.DngPause(1, 1)
	if argc == 0 then
		var2 = event.GetEventData_2(6) or var2
		if var2 == 1 then
			event.Initialize()
			event.SetMesWindowMode(0, 1)
			event.SetMesDrawspeed(0, 1)
			var3 = helper_08ca16f6(0, 1, 5, 256, 208, var3)
			if vm.skipping() then
				return skip(1)
			end
			event.SetMesShippo(0, 1)
			event.SetMesDrawspeed(0, 0)
			if var3 == 1 then
				var2 = 2
			end
			event.Finish()
		end
		if var2 == 2 then
			event.SetStatusbarShow(0, 0.16666667)
			helper_72643bb6(6)
			if vm.skipping() then
				return skip(2)
			end
			event.GotoUseItem(339)
			do
				local skipped = vm.wait()
				var4 = event.DeferredOutput() or var4
				if skipped then
					return skip(3)
				end
			end
			if var4 == 339 then
				event.SetLocalFlag(arg0, 1)
				helper_42aa4()
				if vm.skipping() then
					return skip(4)
				end
			elseif var4 <= 0 then
				event.Finish()
			else
				helper_1589c()
				if vm.skipping() then
					return skip(5)
				end
			end
			event.SetStatusbarShow(1, 0.16666667)
			helper_72643bb6(6)
			if vm.skipping() then
				return skip(6)
			end
		end
	else
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.Initialize()
			helper_16358()
			event.SetMesWindowMode(0, 1)
			event.SetMesDrawspeed(0, 1)
			if active_chr_no == 2 then
				helper_065641b0(0, 20, 5, 256, 208)
				if vm.skipping() then
					return skip(7)
				end
			else
				helper_065641b0(0, 21, 5, 256, 208)
				if vm.skipping() then
					return skip(8)
				end
			end
			event.SetMesWindowMode(0, 1)
			event.SetMesDrawspeed(0, 0)
			event.DngPause(1, 0)
			event.Finish()
			return
		end
		event.SetMesQuestionGyou(0, 0)
		event.SetMesWindowMode(0, 5)
		event.SetMesDrawspeed(0, 1)
		var6 = helper_a4e66753(0, 10, 8, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(9)
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		if var6 == 0 then
			event.DelMonster(-1)
			helper_169dc()
			helper_43a28()
			if vm.skipping() then
				return skip(10)
			end
			var7 = event.GetTrialVersion() or var7
			if var7 ~= 1 then
				do
					local out1, out2 = event.IsClearPractice(1)
					cleared = out1 or cleared
					bonus = out2 or bonus
				end
				if cleared == 2 or cleared == 3 then
					event.SpriteInit(0)
					event.SpriteSetType(0, 0)
					event.SpriteSetPos(0, 256, 208)
					event.SpriteSetPutsize(0, 512, 416)
					event.SpriteSetColor(0, 0, 0, 0, 128)
					event.SpriteSetDraw(0, 1)
					event.SetFadeIn(0)
					helper_163d8(-1, cleared, bonus)
					if vm.skipping() then
						return skip(11)
					end
					if vm.wait() then
						return skip(12)
					end
					event.SetFadeOut(0)
					event.SpriteSetDraw(0, 0)
				end
			end
			stage_id = event.DngGetStageId() or stage_id
			var11 = event.DngGetFloorId() or var11
			argc_2 = event.GetNextFloor(var11, arg0) or argc_2
			event.DngSetFloorId(argc_2)
			event.SetFloorInfo(stage_id, var11, 5, 2)
			event.SetFloorInfo(stage_id, argc_2, 5, 1)
			event.DngFloorFinish()
			var14 = event.GetTrialVersion() or var14
			if var14 == 1 then
				event.SetExitFlag(1)
				return
			else
				event.Finish()
				program_1000()
				if vm.skipping() then
					return skip(13)
				end
			end
		else
			event.Finish()
		end
	end
	event.DngPause(1, 0)
end

--- Helper function.
local function helper_45788()
	local flag: s32 = 0
	local argc: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			var2 = 2
			helper_72643bb6(6)
		end
		if at <= 4 then
			var6, var7, var8, var9 = helper_16bf0(var6, var7, var8, var9)
			helper_72643bb6(60)
		end
		if at <= 5 then
			helper_1589c()
		end
		if at <= 6 then
			helper_72643bb6(6)
		end
	end
	event.Initialize()
	event.DngPause(1, 1)
	helper_16358()
	flag = event.GetFlag(616) or flag
	if flag == 0 then
		event.SetMesWindowMode(0, 4)
		event.SetMesShippo(0, 0)
		helper_065641b0(0, 9, 8, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.DngPause(1, 0)
		event.Finish()
		return
	end
	argc = event.GetLocalFlag(4) or argc
	if argc == 0 then
		var2 = event.GetEventData_2(6) or var2
		if var2 == 1 then
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			var3 = helper_08ca16f6(0, 8, 5, 256, 208, var3)
			if vm.skipping() then
				return skip(2)
			end
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 1)
			if var3 == 1 then
				var2 = 2
			end
		end
		if var2 == 2 then
			event.SetStatusbarShow(0, 0.16666667)
			helper_72643bb6(6)
			if vm.skipping() then
				return skip(3)
			end
			event.GotoUseItem2(0, 362)
			do
				local skipped = vm.wait()
				var4 = event.DeferredOutput() or var4
				if skipped then
					return skip(4)
				end
			end
			if var4 == 362 then
				event.SetLocalFlag(4, 1)
				var5 = event.GetEventData_2(9) or var5
				event.EohSyncObj(0, var5, "star-m0")
				event.EohSetShow(0, 0)
				event.EohSyncObj(0, var5, "d02wa13-a")
				event.EohSetShow(0, 0)
				event.FuncPointShow(var5, "star", 0)
				var6, var7, var8, var9 = helper_16bf0(var6, var7, var8, var9)
				event.SetWorldCoord(var6, var7, var8, var9)
				event.AssignStack(5)
				event.ClearStack(5)
				event.EohSyncChara(0, 0)
				event.ObjsInit(0)
				event.ObjsSyncObj(0, 0)
				event.ObjsReference(0, 0.0, 0.0, 0.0, 0)
				event.LoadChara(5, "event/dng/key_star.gltf", "star", 12)
				event.CharaActive(12)
				event.EohSyncChara(1, 12)
				event.ObjsSyncObj(1, 1)
				event.EohSetPos(1, 0.0, 0.0, 160.0)
				event.EohSetRot(1, 0.0, 0.0, 0.0)
				event.EohSetScale(1, 20.0, 20.0, 20.0)
				var10 = event.SndLoadSound(8, "snd2/sp/sp_014.sound.json") or var10
				event.SndSePlay(var10, 0)
				event.ObjsSetScale(1, 20.0, 0.0, 20.0, 60)
				event.CmrsSetPos(-31.46, 57.29, 350.67)
				event.CmrsSetRef(4.66, 31.72, 192.41)
				event.SetCharaShow(12, 0, 1, 0.02)
				helper_72643bb6(60)
				if vm.skipping() then
					return skip(5)
				end
				event.DeleteChara(12)
			elseif var4 <= 0 then
				event.Finish()
			else
				helper_1589c()
				if vm.skipping() then
					return skip(6)
				end
			end
		end
		event.SetStatusbarShow(1, 0.16666667)
		helper_72643bb6(6)
		if vm.skipping() then
			return skip(7)
		end
	end
	event.DngPause(1, 0)
	event.Finish()
end

--- Helper function.
local function helper_47ad0()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = vm.f32(var4 + vm.f32(3.1415927))
			var5 = 0
			var5 = var5 + 1
		end
		if at <= 2 then
			helper_40515d20()
		end
		if at <= 3 then
			helper_72643bb6(10)
		end
		if at <= 4 then
			helper_72643bb6(75)
		end
		if at <= 5 then
			helper_72643bb6(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.Ext(1035, 8, var1, var2, var3, var4) -- retail: the handler rejects 5 arguments
	var4 = vm.bits_float(event.GetEventData_2(11)) or var4
	var0 = event.GetEventData_2(9) or var0
	event.SetLoadbgFile("event/dng_inout/kumonosu.gltf", "snd2/sp/sp_028.sound.json")
	var4 = vm.f32(var4 + vm.f32(3.1415927))
	var4 = event.AngleLimit(var4) or var4
	var5 = 0
	while var5 < 30 do
		event.SetFcameraFollow(var1, var2 + 40.0, var3)
		event.CtrlcMoveRange(18.0, 10.0, 200.0, 220.0)
		event.CtrlcRotBack(var4)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		var5 = var5 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	helper_40515d20()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadChara(5, "event/dng_inout/kumonosu.gltf", "info", 12)
	event.SetCharaPos(12, var1, var2 + 20.0, var3)
	event.SetCharaRot(12, 0.0, var4, 0.0)
	var6 = event.SndLoadSound(8, "snd2/sp/sp_028.sound.json") or var6
	helper_72643bb6(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var6, 0)
	event.CharaActive(1, 12)
	event.SetMotion(12, "巣消える", 6)
	helper_72643bb6(75)
	if vm.skipping() then
		return skip(5)
	end
	event.DeleteChara(12)
	event.ResetCamera(0)
	event.EohSyncObj(2, var0)
	do
		local out1, out2, out3 = event.EohGetPos(2)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.MinimapDoorEnable(pos_x, pos_y, pos_z)
	event.EohSyncObj(3, var0, "d02d05_1-m0")
	event.EohSetShow(3, 0)
	event.EohSyncObj(4, var0, "d02da05-a")
	event.EohSetShow(4, 0)
	event.EohSyncObj(5, var0, "d02dv05-c")
	event.EohSetShow(5, 0)
	event.FuncPointShow(var0, "key", 0)
	event.CtrlcMoveRange(18.0, 10.0, 100.0, 160.0)
	event.SetCrossfade(30)
	helper_72643bb6(30)
	if vm.skipping() then
		return skip(6)
	end
end

--- Helper function.
local function helper_46834()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local rot_y: f32 = 0
	local var8: s32 = 0
	local active_chr_no: s32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = vm.f32(var4 + vm.f32(3.1415927))
			var10 = 0
			var10 = var10 + 1
		end
		if at <= 2 then
			helper_40515d20()
		end
		if at <= 3 then
			helper_72643bb6(20)
		end
		if at <= 4 then
			helper_059d36ae(0)
		end
		if at <= 5 then
			helper_72643bb6(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.Ext(1035, 8, var1, var2, var3, var4) -- retail: the handler rejects 5 arguments
	var4 = vm.bits_float(event.GetEventData_2(11)) or var4
	var0 = event.GetEventData_2(9) or var0
	event.EohSyncChara(0, 0)
	do
		local _, out2, _ = event.EohGetRot(0)
		rot_y = out2 or rot_y
	end
	event.ObjsSyncObj(0, 0)
	var8 = event.AngleCmp(rot_y, var4, 0.1) or var8
	if var8 ~= 0 then
		event.ObjsRotation(0, 0.0, var4, 0.0, 10)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMotionDelay(0, 10)
	end
	event.ObjsSetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.SetLoadbgFile(
			"event/dng_inout/c01d02gkey.gltf",
			"event/dng_inout/d02nkey_h.gltf",
			"event/dng_inout/kumonosu.gltf",
			"snd2/sp/sp_028.sound.json"
		)
	else
		event.SetLoadbgFile(
			"event/dng_inout/c02d02gkey.gltf",
			"event/dng_inout/d02nkey_h.gltf",
			"event/dng_inout/kumonosu.gltf",
			"snd2/sp/sp_028.sound.json"
		)
	end
	var4 = vm.f32(var4 + vm.f32(3.1415927))
	var4 = event.AngleLimit(var4) or var4
	var10 = 0
	while var10 < 30 do
		event.SetFcameraFollow(var1, var2 + 40.0, var3)
		event.CtrlcMoveRange(18.0, 10.0, 200.0, 220.0)
		event.CtrlcRotBack(var4)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		var10 = var10 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	helper_40515d20()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadChara(5, "event/dng_inout/d02nkey_h.gltf", "info", 12)
	if active_chr_no == 0 then
		event.LoadMotion(5, "event/dng_inout/c01d02gkey.gltf", "info", 0)
		event.SetReference(0, "ef00", 12)
	else
		event.LoadMotion(5, "event/dng_inout/c02d02gkey.gltf", "info", 0)
		event.SetReference(0, "sword_hand", 12)
	end
	event.CharaActive(12)
	event.LoadChara(5, "event/dng_inout/kumonosu.gltf", "info", 13)
	event.SetCharaPos(13, var1, var2 + 20.0, var3)
	event.SetCharaRot(13, 0.0, var4, 0.0)
	var11 = event.SndLoadSound(8, "snd2/sp/sp_028.sound.json") or var11
	event.EohSyncChara(1, 1)
	event.EohSetShow(1, 0)
	event.ObjsSetMotion(0, "d02くもの巣取り", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_72643bb6(20)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var11, 0)
	event.CharaActive(1, 13)
	event.SetMotion(13, "巣消える", 6)
	helper_059d36ae(0)
	if vm.skipping() then
		return skip(5)
	end
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.DelExtMotion(0)
	event.SetMotion(0, "立ち", 4)
	event.ResetCamera(0)
	event.EohSyncChara(1, 1)
	event.EohSetShow(1, 1)
	event.EohSyncObj(2, var0)
	do
		local out1, out2, out3 = event.EohGetPos(2)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.MinimapDoorEnable(pos_x, pos_y, pos_z)
	event.EohSyncObj(3, var0, "d02d05_1-m0")
	event.EohSetShow(3, 0)
	event.EohSyncObj(4, var0, "d02da05-a")
	event.EohSetShow(4, 0)
	event.EohSyncObj(5, var0, "d02dv05-c")
	event.EohSetShow(5, 0)
	event.FuncPointShow(var0, "key", 0)
	event.CtrlcMoveRange(18.0, 10.0, 100.0, 160.0)
	event.SetCrossfade(30)
	helper_72643bb6(30)
	if vm.skipping() then
		return skip(6)
	end
end

--- Helper function.
local function helper_20118(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_72643bb6(36)
		end
	end
	event.Initialize()
	event.DngPause(513, 1)
	event.SetCrossfade(15)
	event.SetTbStatus(0)
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetWorldCoord(var2, var3, var4, var5)
	event.CopyMons2scnchr(5, arg0, 12)
	event.CharaActive(12)
	event.SetCharaPos(12, var2, var3, var4)
	event.SetCharaRot(12, 0.0, var5, 0.0)
	event.SetMotion(12, "閉め", 4)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 29.0, 57.0)
	event.CmrsSetRef(0.0, 10.0, 0.0)
	event.CmrsMove(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_72643bb6(15)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(12, "出現", 6)
	helper_72643bb6(36)
	if vm.skipping() then
		return skip(2)
	end
	event.DeleteChara(12, 0)
	event.CharaActive(0, 12)
	event.AutoSetMonster(arg0, var2, var3, var4, 0.0, var5, 0.0, arg1)
	event.CharaActive(1, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- Helper function.
local function helper_1e450(arg0: s32)
	local var1: any = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_065641b0(0, -1, 5, 0, 0)
		end
		if at <= 2 then
			arg0 = helper_bdff4943(arg0, 2)
			var2 = 0
			helper_72643bb6(6)
		end
		if at <= 4 then
			arg0 = helper_bdff4943(arg0, 2)
			var2 = 0
			var2 = 1
			helper_1589c()
		end
		if at <= 5 then
			var2 = 1
			helper_065641b0(0, 2215, 5, 0, 0)
		end
		if at <= 6 then
			helper_065641b0(0, 2216, 5, 0, 0)
		end
		if at <= 7 then
			var2 = 0
			helper_065641b0(0, 2211, 5, 0, 0)
		end
		if at <= 8 then
			var2 = 1
			helper_065641b0(0, 2212, 5, 0, 0)
		end
		var2 = 0
		arg0 = helper_bdff4943(arg0, 2)
		var2 = 1
		return var2, arg0
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 4 then
		event.MesMake_2(0, "Lo scrigno sembra chiuso a chiave.\nFallo aprire a Donny.\nForzalo.\nLascia perdere.")
		helper_fcb18908(0, -1, 5, 0, 0)
	else
		helper_fcb18908(0, 2220, 5, 0, 0)
	end
	var1 = helper_633b4244(0, 3, 3, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var1 == 1 then
		if now_party_chara_id == 4 then
			event.MesMake_2(0, "Va bene! Ci penso io!")
			helper_065641b0(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
			arg0 = helper_bdff4943(arg0, 2)
			var2 = 0
		else
			event.SetStatusbarShow(0, 0.16666667)
			helper_72643bb6(6)
			if vm.skipping() then
				return skip(3)
			end
			event.GotoUseItem(297)
			do
				local skipped = vm.wait()
				var4 = event.DeferredOutput() or var4
				if skipped then
					return skip(4)
				end
			end
			if var4 == 297 then
				arg0 = helper_bdff4943(arg0, 2)
				var2 = 0
			elseif var4 <= 0 then
				var2 = 1
			else
				helper_1589c()
				if vm.skipping() then
					return skip(5)
				end
				var2 = 1
			end
			event.SetStatusbarShow(1, 0.16666667)
		end
	end
	if var1 == 2 then
		event.SysSePlay(24)
		event.SetMesQuestionGyou(0, 0)
		if bit32.band(arg0, 8) ~= 0 then
			active_chr_no = event.GetActiveChrNo() or active_chr_no
			if active_chr_no == 0 or active_chr_no == 2 then
				helper_065641b0(0, 2215, 5, 0, 0)
				if vm.skipping() then
					return skip(6)
				end
				event.SetCharaCondition(0, 1, 0)
				event.AddHpRate2(0, -0.7)
			else
				helper_065641b0(0, 2216, 5, 0, 0)
				if vm.skipping() then
					return skip(7)
				end
				event.SetCharaCondition(1, 1, 0)
				event.AddHpRate2(1, -0.7)
			end
			var2 = 0
		end
		if bit32.band(arg0, 16) ~= 0 then
			helper_065641b0(0, 2211, 5, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetTbStatus(0)
			do
				local out1, out2, out3, _ = event.GetDunWorldCoord(1)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			var10 = event.GetSndId(4) or var10
			event.SndSePlay(var10, 11)
			event.DngCreateEffect("爆発", var6, var7 + 4.0, var8, 5)
			var2 = 1
		end
		if bit32.band(arg0, 32) ~= 0 then
			helper_065641b0(0, 2212, 5, 0, 0)
			if vm.skipping() then
				return skip(9)
			end
			event.AddWhp(0, -999)
			event.AddWhp(1, -999)
			var2 = 0
		end
		arg0 = helper_bdff4943(arg0, 2)
	end
	if var1 == -1 or var1 == 3 then
		var2 = 1
	end
	return var2, arg0
end

--- Helper function.
local function helper_1f2d8(arg0: s32)
	local var1: any = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: s32 = 0
	local active_chr_no_2: s32 = 0
	local max: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = 0
			var2 = 0
			var2 = 0
			var2 = 1
			var3 = 8
			var4 = 1
			var3 = var3 * 2
			var4 = var4 + 1
			helper_065641b0(0, 2213, 5, 0, 0)
		end
		if at <= 2 then
			var2 = 0
			helper_065641b0(0, 2215, 5, 0, 0)
		end
		if at <= 3 then
			helper_065641b0(0, 2216, 5, 0, 0)
		end
		if at <= 4 then
			var2 = 1
			helper_065641b0(0, 2211, 5, 0, 0)
		end
		if at <= 5 then
			var2 = 1
			active_chr_no_2 = 1
			helper_065641b0(0, 2212, 5, 0, 0)
		end
		var2 = 1
		return var2, arg0
	end
	helper_fcb18908(0, 2200, 5, 0, 0)
	var1 = helper_633b4244(0, 4, 4, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var1 == 1 then
		var2 = 0
	end
	if var1 == 2 then
		var2 = 0
	end
	if var1 == 3 then
		var2 = 0
	end
	if var1 == -1 or var1 == 4 then
		var2 = 1
	end
	if var2 ~= 1 then
		var3 = 8
		var4 = 1
		while var4 < var1 do
			var3 = vm.i32(var3 * 2)
			var4 = vm.i32(var4 + 1)
		end
		event.SetMesQuestionGyou(0, 0)
		if vm.i32(bit32.band(arg0, var3)) ~= 0 then
			helper_065641b0(0, 2213, 5, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
			var2 = 0
		else
			event.SysSePlay(24)
			if bit32.band(arg0, 8) ~= 0 then
				active_chr_no = event.GetActiveChrNo() or active_chr_no
				if active_chr_no == 0 or active_chr_no == 2 then
					helper_065641b0(0, 2215, 5, 0, 0)
					if vm.skipping() then
						return skip(3)
					end
					event.SetCharaCondition(0, 1, 0)
					event.AddHpRate2(0, -0.7)
				else
					helper_065641b0(0, 2216, 5, 0, 0)
					if vm.skipping() then
						return skip(4)
					end
					event.SetCharaCondition(1, 1, 0)
					event.AddHpRate2(1, -0.7)
				end
				var2 = 1
			end
			if bit32.band(arg0, 16) ~= 0 then
				helper_065641b0(0, 2211, 5, 0, 0)
				if vm.skipping() then
					return skip(5)
				end
				event.SetTbStatus(0)
				do
					local out1, out2, out3, _ = event.GetDunWorldCoord(1)
					var6 = out1 or var6
					var7 = out2 or var7
					var8 = out3 or var8
				end
				var10 = event.GetSndId(4) or var10
				event.SndSePlay(var10, 11)
				event.DngCreateEffect("爆発", var6, var7 + 4.0, var8, 5)
				var2 = 1
			end
			if bit32.band(arg0, 32) ~= 0 then
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 == 3 then
					active_chr_no_2 = 1
				end
				event.UdataAddWhp(active_chr_no_2, 0, -999)
				event.UdataAddWhp(active_chr_no_2, 1, -999)
				do
					local _, out2 = event.UdataGetAbs(active_chr_no_2, 0)
					max = out2 or max
				end
				event.UdataAddAbs(active_chr_no_2, 0, vm.idiv(vm.i32(-max), 10))
				do
					local _, out2 = event.UdataGetAbs(active_chr_no_2, 1)
					max = out2 or max
				end
				event.UdataAddAbs(active_chr_no_2, 1, vm.idiv(vm.i32(-max), 10))
				helper_065641b0(0, 2212, 5, 0, 0)
				if vm.skipping() then
					return skip(6)
				end
				var2 = 1
			end
		end
	end
	return var2, arg0
end

--- Helper function.
local function helper_19368()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var1 = 0
		var1 = 110
		var1 = 111
		var1 = 112
		return var1
	end
	if vm.skipping() then
		return skip(1)
	end
	stage_id = event.DngGetStageId() or stage_id
	var1 = 0
	if stage_id == 0 or stage_id == 1 or stage_id == 6 then
		var1 = 110
	end
	if stage_id == 5 then
		var1 = 111
	end
	if stage_id == 2 or stage_id == 4 or stage_id == 3 then
		var1 = 112
	end
	return var1
end

--- Helper function.
local function helper_19664(arg0: any)
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = 0
			var2 = 0.0
			var2 = vm.f32(var2 + vm.f32(0.01))
			var1 = var1 + 1
		end
		if at <= 2 then
			var4 = helper_19368()
			var1 = 0
			var2 = vm.f32(var2 - vm.f32(0.004))
			var1 = var1 + 1
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = 0
	var2 = 0.0
	while var1 <= 5 do
		event.SetTbAngle(var2)
		var2 = vm.f32(var2 + vm.f32(0.01))
		var1 = var1 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	var4 = helper_19368()
	var3 = event.GetSndId(3) or var3
	event.SndSePlay(var3, var4)
	var1 = 0
	while var1 <= 4 do
		event.SetTbAngle(var2)
		var2 = vm.f32(var2 - vm.f32(0.004))
		var1 = var1 + 1
		if vm.wait() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_19a08(arg0: f32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = 0
			arg0 = vm.f32(0.04)
			arg0 = vm.f32(arg0 + vm.f32(0.13))
			var1 = var1 + 1
		end
		return arg0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = 0
	arg0 = vm.f32(0.04)
	while var1 <= 10 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 + vm.f32(0.13))
		var1 = var1 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	return arg0
end

--- Helper function.
local function helper_18fd4(arg0: s32, arg1: s32, arg2: f32)
	local category: s32 = 0
	local var4: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var4 = vm.f32(var4 / 2.0)
		var4 = vm.f32(var4 / 2.0)
		var4 = vm.f32(var4 / 2.0)
		arg2 = var4
		return arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	category = event.GetItemType(arg1) or category
	var4 = event.GetAdjustPolygonScale(arg0, 6.0) or var4
	if category == 0 then
		var4 = vm.f32(var4 / 2.0)
	end
	if category == 2 then
		var4 = vm.f32(var4 / 2.0)
	end
	if category == 4 then
		var4 = vm.f32(var4 / 2.0)
	end
	arg2 = var4
	return arg2
end

--- Helper function.
local function helper_19c08(arg0: f32)
	local var1: s32 = 0
	local var2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = 0
			arg0 = vm.f32(arg0 + vm.f32(0.18))
			var1 = var1 + 1
		end
		if at <= 2 then
			var1 = 0
			var2 = vm.f32(0.06)
			arg0 = vm.f32(arg0 - var2)
			var2 = vm.f32(var2 - vm.f32(0.008))
			var1 = var1 + 1
		end
		if at <= 3 then
			var1 = 0
			var2 = vm.f32(0.005)
			arg0 = vm.f32(arg0 + var2)
			var2 = vm.f32(var2 + vm.f32(0.01))
			var1 = var1 + 1
		end
		if at <= 4 then
			var1 = 0
			var2 = vm.f32(0.03)
			arg0 = vm.f32(arg0 - var2)
			var2 = vm.f32(var2 - vm.f32(0.005))
			var1 = var1 + 1
		end
		if at <= 5 then
			var1 = 0
			var2 = vm.f32(0.01)
			arg0 = vm.f32(arg0 + var2)
			var2 = vm.f32(var2 + vm.f32(0.01))
			var1 = var1 + 1
		end
		return arg0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = 0
	while var1 < 10 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 + vm.f32(0.18))
		var1 = var1 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	var1 = 0
	var2 = vm.f32(0.06)
	while var1 <= 6 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 - var2)
		var2 = vm.f32(var2 - vm.f32(0.008))
		var1 = var1 + 1
		if vm.wait() then
			return skip(3)
		end
	end
	var1 = 0
	var2 = vm.f32(0.005)
	while var1 <= 8 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 + var2)
		var2 = vm.f32(var2 + vm.f32(0.01))
		var1 = var1 + 1
		if vm.wait() then
			return skip(4)
		end
	end
	var1 = 0
	var2 = vm.f32(0.03)
	while var1 <= 6 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 - var2)
		var2 = vm.f32(var2 - vm.f32(0.005))
		var1 = var1 + 1
		if vm.wait() then
			return skip(5)
		end
	end
	var1 = 0
	var2 = vm.f32(0.01)
	while var1 <= 4 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 + var2)
		var2 = vm.f32(var2 + vm.f32(0.01))
		var1 = var1 + 1
		if vm.wait() then
			return skip(6)
		end
	end
	return arg0
end

--- Helper function.
local function helper_1a54c(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local count_2: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local var14: s32 = 0
	local stage_id: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_72643bb6(15)
		end
		if at <= 3 then
			helper_19664(0)
		end
		if at <= 4 then
			helper_72643bb6(5)
		end
		if at <= 5 then
			helper_40515d20()
		end
		if at <= 6 then
			helper_72643bb6(5)
		end
		if at <= 7 then
			var6 = helper_19a08(var6)
		end
		if at <= 8 then
			var7 = helper_18fd4(13, arg0, var7)
			var6 = helper_19c08(var6)
		end
		if at <= 9 then
			helper_9c96a6bc()
		end
		if at <= 10 then
			argc = 0
			argc_2 = 0
			helper_bc0b89da(arg0, count_2)
		end
		if at <= 11 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
		if at <= 12 then
			print("CHECK_GET_ITEM_LIMIT = ", argc, "\n")
			print("CHECK_ITEM_OVER      = ", argc_2, "\n")
			helper_72643bb6(10)
		end
		if at <= 14 then
			helper_065641b0(0, 2240, 8, 0, 0)
		end
		if at <= 15 then
			helper_065641b0(0, 2250, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(535, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetWorldCoord(var2, var3, var4, var5)
	if vm.wait() then
		return skip(2)
	end
	if arg0 >= 0 then
		event.SetLoadbgFile(arg0, 1, "effect/itemget.gltf")
	else
		event.SetLoadbgFile("effect/itemget.gltf")
	end
	event.SetTbAngle(0.0)
	event.SetTbStatus(2)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 29.0, 57.0)
	event.CmrsSetRef(0.0, 10.0, 0.0)
	event.CmrsMove(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_72643bb6(15)
	if vm.skipping() then
		return skip(3)
	end
	helper_19664(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_72643bb6(5)
	if vm.skipping() then
		return skip(5)
	end
	helper_40515d20()
	if vm.skipping() then
		return skip(6)
	end
	event.LoadChara(5, "effect/itemget.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(1, 12)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "ゲット", 6)
	helper_72643bb6(5)
	if vm.skipping() then
		return skip(7)
	end
	var6 = helper_19a08(var6)
	if vm.skipping() then
		return skip(8)
	end
	if arg0 >= 0 then
		event.LoadItem(5, arg0, "info", 13, 1)
		event.CharaActive(1, 13)
		event.EohSyncChara(0, 13)
		var7 = helper_18fd4(13, arg0, var7)
		event.EohSetScale(0, var7, var7, var7)
		event.SetCharaShow(13, 1, 1, 0.1)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 0.0, -2.5, 0.0)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsPosDelay(0, 4)
		event.ObjsJump(0, 0.0, 17.0, 0.0, -0.3, 20)
		event.ObjsJump(0, 0.0, 17.0, 0.0, -0.4, 8)
		event.ObjsJump(0, 0.0, 17.0, 0.0, -0.2, 5)
	end
	var6 = helper_19c08(var6)
	if vm.skipping() then
		return skip(9)
	end
	helper_9c96a6bc()
	if vm.skipping() then
		return skip(10)
	end
	if arg0 >= 0 then
		argc = 0
		argc_2 = 0
		count_2 = event.CheckGetItemLimit(arg0, arg1) or count_2
		if count_2 >= 1 then
			event.AddItem(arg0, count_2)
			helper_bc0b89da(arg0, count_2)
			if vm.skipping() then
				return skip(11)
			end
		else
			event.SetMesWindowMode(0, 4)
			event.SetMesDrawspeed(0, 1)
			event.SetMesItem(0, 1, arg0)
			event.MesMake_2(0, "Hai trovato [アイテム１],\nma non hai spazio sufficiente.")
			helper_065641b0(0, -1, 8, 0, 0)
			if vm.skipping() then
				return skip(12)
			end
			event.SetMesDrawspeed(0, 0)
		end
		argc = event.CheckGetItemLimit() or argc
		argc_2 = event.CheckItemOver() or argc_2
		print("CHECK_GET_ITEM_LIMIT = ", argc, "\n")
		print("CHECK_ITEM_OVER      = ", argc_2, "\n")
		if argc_2 >= 1 then
			event.SetFadeOut(10)
			helper_72643bb6(10)
			if vm.skipping() then
				return skip(13)
			end
			event.GotoMenu(17)
			if vm.wait() then
				return skip(14)
			end
		end
	else
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_065641b0(0, 2240, 8, 0, 0)
		if vm.skipping() then
			return skip(15)
		end
		event.SetMesDrawspeed(0, 0)
	end
	event.CharaActive(1, 0)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.SetTbAngle(1.0)
	event.SetCrossfade(10)
	event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextPos()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraPos(position_x, position_y, position_z)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextRef()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraRef(position_x, position_y, position_z)
	event.ResetCamera(0)
	var14 = event.GetTrialVersion() or var14
	stage_id = event.DngGetStageId() or stage_id
	if arg0 == 306 and (stage_id == 0 or var14 == 1) then
		event.SetMesWindowMode(0, 4)
		helper_065641b0(0, 2250, 8, 0, 0)
		if vm.skipping() then
			return skip(16)
		end
	end
	event.DngPause(535, 0)
	event.Finish()
end

--- Helper function.
local function helper_19264(arg0: s32, arg1: any, arg2: f32)
	local var4: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		arg2 = var4
		return arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	event.GetItemType(arg1)
	var4 = event.GetAdjustPolygonScale(arg0, 4.0) or var4
	arg2 = var4
	return arg2
end

--- Helper function.
local function helper_1ba78(arg0: s32, arg1: s32, arg2: any, arg3: any)
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
			helper_72643bb6(15)
		end
		if at <= 3 then
			helper_19664(0)
		end
		if at <= 4 then
			helper_72643bb6(5)
		end
		if at <= 5 then
			helper_40515d20()
		end
		if at <= 6 then
			var10 = helper_19a08(var10)
		end
		if at <= 7 then
			var10 = helper_19c08(var10)
		end
		if at <= 8 then
			helper_72643bb6(10)
		end
		if at <= 9 then
			helper_72643bb6(8)
		end
		if at <= 10 then
			helper_72643bb6(10)
		end
		if at <= 11 then
			helper_065641b0(0, 2230, 8, 256, 208)
		end
		if at <= 12 then
			helper_065641b0(0, 2231, 8, 256, 208)
		end
		if at <= 13 then
			local _ = helper_fcb18908(0, 2232, 8, 0, 0)
			var11 = helper_633b4244(0, 2, 0, 1)
		end
		if at <= 14 then
			var14 = arg0
			arg0 = arg2
			arg2 = var14
			var14 = arg1
			arg1 = arg3
			arg3 = var14
			var15 = helper_19264(16, arg0, var15)
			var15 = helper_19264(17, arg2, var15)
			helper_72643bb6(10)
		end
		if at <= 15 then
			helper_72643bb6(60)
		end
		if at <= 16 then
			helper_72643bb6(6)
		end
		if at <= 17 then
			helper_059d36ae(1)
		end
		if at <= 18 then
			helper_bc0b89da(arg2, count_2)
		end
		if at <= 19 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
		if at <= 20 then
			var17 = arg2
			helper_bc0b89da(arg0, count_2)
		end
		if at <= 21 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
		if at <= 22 then
			var17 = arg0
			helper_72643bb6(10)
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
	helper_72643bb6(15)
	if vm.skipping() then
		return skip(3)
	end
	helper_19664(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_72643bb6(5)
	if vm.skipping() then
		return skip(5)
	end
	helper_40515d20()
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
	var10 = helper_19a08(var10)
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
	var10 = helper_19c08(var10)
	if vm.skipping() then
		return skip(8)
	end
	helper_72643bb6(10)
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
	helper_72643bb6(8)
	if vm.skipping() then
		return skip(10)
	end
	event.SetCharaShow(18, 1, 1, 0.08)
	event.SetCharaShow(19, 1, 1, 0.08)
	helper_72643bb6(10)
	if vm.skipping() then
		return skip(11)
	end
	event.CharaActive(0, 14)
	event.CharaActive(0, 15)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	helper_065641b0(0, 2230, 8, 256, 208)
	if vm.skipping() then
		return skip(12)
	end
	helper_065641b0(0, 2231, 8, 256, 208)
	if vm.skipping() then
		return skip(13)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SndSePlay(var4, 3)
	local _ = helper_fcb18908(0, 2232, 8, 0, 0)
	var11 = helper_633b4244(0, 2, 0, 1)
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
	var15 = helper_19264(16, arg0, var15)
	event.EohSetScale(6, var15, var15, var15)
	event.LoadItem(5, arg2, "info", 17, 1)
	event.CharaActive(0, 17)
	event.SetCharaPos(17, 0.0, 0.0, 0.0)
	event.SetCharaRot(17, 0.0, 0.0, 0.0)
	event.EohSyncChara(6, 17)
	var15 = helper_19264(17, arg2, var15)
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
	helper_72643bb6(10)
	if vm.skipping() then
		return skip(15)
	end
	event.SetCharaShow(18, 0, 1, 0.04)
	event.SetCharaShow(19, 0, 1, 0.04)
	event.SndSePlay(var4, 4)
	event.SndSePlay(var4, 5)
	helper_72643bb6(60)
	if vm.skipping() then
		return skip(16)
	end
	event.SndSePlay(var4, 7)
	helper_72643bb6(6)
	if vm.skipping() then
		return skip(17)
	end
	event.SndSePlay(var4, 6)
	helper_059d36ae(1)
	if vm.skipping() then
		return skip(18)
	end
	if var11 == 0 then
		count_2 = event.CheckGetItemLimit(arg2, arg3) or count_2
		if count_2 >= 1 then
			helper_bc0b89da(arg2, count_2)
			if vm.skipping() then
				return skip(19)
			end
		else
			event.SetMesWindowMode(0, 4)
			event.SetMesDrawspeed(0, 1)
			event.SetMesItem(0, 1, arg2)
			event.MesMake_2(0, "Hai ricevuto [アイテム１],\nma non hai spazio sufficiente.")
			helper_065641b0(0, -1, 8, 0, 0)
			if vm.skipping() then
				return skip(20)
			end
		end
		var17 = arg2
	else
		count_2 = event.CheckGetItemLimit(arg0, arg1) or count_2
		if count_2 >= 1 then
			helper_bc0b89da(arg0, count_2)
			if vm.skipping() then
				return skip(21)
			end
		else
			event.SetMesWindowMode(0, 4)
			event.SetMesDrawspeed(0, 1)
			event.SetMesItem(0, 1, arg0)
			event.MesMake_2(0, "Hai ricevuto [アイテム１],\nma non hai spazio sufficiente.")
			helper_065641b0(0, -1, 8, 0, 0)
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
		helper_72643bb6(10)
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

--- Helper function.
local function helper_2076c()
	local flags: s32 = 0
	local item_x: s32 = 0
	local item_y: s32 = 0
	local num_x: s32 = 0
	local num_y: s32 = 0
	local now_party_chara_id: s32 = 0
	local var6: any = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_fcb18908(0, -1, 5, 0, 0)
				var6 = helper_633b4244(0, 2, 2, 0)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			var8 = 1
			helper_1ba78(item_x, num_x, item_y, num_y)
		end
		if at <= 7 then
			var8 = 1
			helper_1a54c(item_x, num_x)
		end
		var8 = 1
	end
	event.Initialize()
	do
		local out1, out2, out3, out4, out5 = event.GetTboxParam()
		flags = out1 or flags
		item_x = out2 or item_x
		item_y = out3 or item_y
		num_x = out4 or num_x
		num_y = out5 or num_y
	end
	print("-----------------------------------------------------------------------------------------\n")
	print("tbox type = ", flags, "\n")
	print("item1 = ", item_x, ", ", num_x, "\n")
	print("item2 = ", item_y, ", ", num_y, "\n")
	print("-----------------------------------------------------------------------------------------\n")
	if bit32.band(flags, 256) ~= 0 then
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if now_party_chara_id == 9 then
			event.DngPause(513, 1)
			helper_16358()
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			event.MesMake_2(0, "Eh? Aspetta! C'[UNI00e8] uno strano odore!\n      Occhio! Credo sia un Mimetico.")
			helper_065641b0(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
			event.SetMesQuestionGyou(0, 1)
			event.SetMesShippo(0, 0)
			event.SetMesEtc(0, 0, 1)
			event.SetMesEtc(0, 1, 1)
			event.MesMake_2(0, "Vuoi ancora aprirlo?\nS[UNI00ec].\nNo.")
			helper_fcb18908(0, -1, 5, 0, 0)
			var6 = helper_633b4244(0, 2, 2, 0)
			if vm.skipping() then
				return skip(2)
			end
			event.SetMesQuestionGyou(0, 0)
			event.SetMesShippo(0, 1)
			event.SetMesEtc(0, 0, 0)
			event.SetMesEtc(0, 1, 0)
			event.DngPause(513, 0)
			if var6 == 1 then
			else
				return
			end
		end
		helper_20118(item_x, num_x)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	event.DngPause(513, 1)
	helper_16358()
	event.SetMesWindowMode(0, 1)
	event.SetMesQuestionGyou(0, 1)
	event.SetMesShippo(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.SetMesEtc(0, 1, 1)
	if bit32.band(flags, 2) ~= 0 then
		local t0: s32
		t0, flags = helper_1e450(flags)
		local t1 = t0
		if vm.skipping() then
			return skip(4)
		end
		if t1 ~= 0 then
			event.DngPause(513, 0)
			event.Finish()
			return
		end
	end
	if bit32.band(flags, 4) ~= 0 then
		local t2: s32
		t2, flags = helper_1f2d8(flags)
		local t3 = t2
		if vm.skipping() then
			return skip(5)
		end
		if t3 ~= 0 then
			event.DngPause(513, 0)
			event.Finish()
			return
		end
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	event.SetMesEtc(0, 1, 0)
	event.DngPause(513, 0)
	event.SetCrossfade(30)
	event.SetStatusbarShow(0, 0.16666667)
	event.CharaActive(0, 0)
	var8 = 0
	if bit32.band(flags, 512) ~= 0 then
		helper_1a54c(-1, -1)
		if vm.skipping() then
			return skip(6)
		end
		var8 = 1
	end
	if bit32.band(flags, 128) ~= 0 then
		helper_1ba78(item_x, num_x, item_y, num_y)
		if vm.skipping() then
			return skip(7)
		end
		var8 = 1
	end
	if var8 == 0 then
		helper_1a54c(item_x, num_x)
		if vm.skipping() then
			return skip(8)
		end
		var8 = 1
	end
	event.SetStatusbarShow(1, 0.16666667)
end

--- Helper function.
local function helper_cdbc()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_1adc7a8f(1, 7)
		helper_fcb18908(1, -1, 15, 0, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_1adc7a8f(1, 7)
	event.SetMesPreset(1, 2)
	event.MesMake_2(1, "Si ferma con il pulsante (O).")
	helper_fcb18908(1, -1, 15, 0, 0)
end

--- Helper function.
local function helper_2d720()
	local var0: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		if at <= 3 then
			helper_45c10f71(var0, -1, 0, 1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 1)
	do
		local out1, out2 = event.GetMonsterTalkData_2()
		var0 = out1 or var0
		var1 = out2 or var1
	end
	if var1 < 0 then
		if vm.wait() then
			return skip(2)
		end
		return
	end
	event.DngPause(4096, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFileMonsTalk()
	while true do
		argc = event.CheckLoadbgFile() or argc
		if argc == 0 then
			break
		else
			if vm.wait() then
				return skip(3)
			end
		end
	end
	event.LoadMesMonsTalk(0, 5)
	event.MesMake_2(0, var1)
	helper_45c10f71(var0, -1, 0, 1)
	if vm.skipping() then
		return skip(4)
	end
	event.LoadMes(0, -1)
	event.DngPause(4096, 0)
end

--- Helper function.
local function helper_144b4(arg0: s32, arg1: s32, arg2: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_05135b81(0)
		end
		helper_7443da3d(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	while true do
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
	event.StreamStandby(1)
	while true do
		stream_open_state_2 = event.StreamOpenCheck() or stream_open_state_2
		if stream_open_state_2 == 0 then
			break
		else
			if vm.wait() then
				return skip(3)
			end
		end
	end
	event.SetMesPos(0, 0)
	event.MesMake_2(0, -1)
	event.SetMesAutoset(0, arg1, arg2)
	event.StreamPlay(1)
	helper_05135b81(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_7443da3d(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_147ec()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local result: s32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_144b4(2900010, var1, player_chara)
		end
		if at <= 2 then
			helper_144b4(2900020, var1, player_chara)
		end
		if at <= 3 then
			var11 = vm.f32(vm.f32(var7 + var4) / 2.0)
			var12 = vm.f32(vm.f32(vm.f32(var8 + var5) / 2.0) + 10.0)
			var13 = vm.f32(vm.f32(var9 + var6) / 2.0)
			helper_72643bb6(30)
		end
		if at <= 4 then
			helper_72643bb6(30)
		end
		if at <= 5 then
			helper_bc0b89da(356, 1)
		end
		if at <= 6 then
			helper_72643bb6(30)
		end
		if at <= 7 then
			helper_e8fc0d0d(1)
		end
	end
	event.SetFlag(290, 1)
	event.DngPause(4096, 1)
	var0 = event.SndLoadSound(8, "snd2/sp/sp_044.sound.json") or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.EsmInitialize(5)
	event.EsmLoadBase("モニカ魔法－溜め")
	event.EsmInitFix(5)
	do
		local out1, _ = event.GetMonsterTalkData_2()
		var1 = out1 or var1
	end
	event.CharaActive(var1)
	event.EohSyncChara(1, var1)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	player_chara = event.GetControlChrid() or player_chara
	event.CharaActive(player_chara)
	event.EohSyncChara(2, player_chara)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	do
		local out1, out2, out3 = event.GetCharaPos(var1)
		var7 = out1 or var7
		var8 = out2 or var8
		var9 = out3 or var9
	end
	do
		local out1, out2, out3 = event.GetCharaPos(player_chara)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	helper_8cbc13f7(var1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(1, "会話")
	event.SetMesWindowMode(0, 7)
	event.MesMake_2(0, "Ho trovato molte Gocce del Sole\nultimamente... forse anche\ntroppe... Prendetene qualcuna!")
	helper_144b4(2900010, var1, player_chara)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(1, "ガードin", 2)
	event.ObjsNextMotion(1, "ガード", 4)
	event.MesMake_2(0, "Ecco.")
	helper_144b4(2900020, var1, player_chara)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesPreset(0, 0)
	event.ObjsSetMotion(1, "ガードout", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	result = event.EsmCreate_3("モニカ魔法－溜め", var1) or result
	var11 = vm.f32(vm.f32(var7 + var4) / 2.0)
	var12 = vm.f32(vm.f32(vm.f32(var8 + var5) / 2.0) + 10.0)
	var13 = vm.f32(vm.f32(var9 + var6) / 2.0)
	event.EsmSetVect1(var11, var12, var13)
	event.EsmSetVect2(128, 64, 64)
	event.SndSePlay(var0, 0)
	helper_72643bb6(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(2, "ガードin", 2)
	event.ObjsNextMotion(2, "ガード", 4)
	helper_72643bb6(30)
	if vm.skipping() then
		return skip(5)
	end
	event.EsmFinish(var1, result)
	helper_bc0b89da(356, 1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(2, "ガードout", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_72643bb6(30)
	if vm.skipping() then
		return skip(7)
	end
	helper_e8fc0d0d(1)
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.DngPause(4096, 0)
end

--- Helper function.
local function helper_2178c(arg0: s32)
	local language_code: s32 = 0
	local block: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 2 then
				helper_40515d20()
			end
			if at <= 3 then
				var11 = vm.f32(var11 + vm.f32(0.4))
				helper_72643bb6(90)
			end
			if at <= 4 then
				helper_d1419c31(8500160, -1)
			end
			if at <= 5 then
				helper_72643bb6(20)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if arg0 == 0 then
			event.SetStatusbarShow(1, 1.0)
		end
		event.SetCameraCtrl(1)
		event.SndSeAllStop(7)
		event.SndSeStop(var3, 0)
		event.LoadBgm(193)
		event.PlayBgm(0)
		event.DelExtMotion(0)
		event.DelImg(0)
		event.SetCrossfade(10)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	if arg0 == 0 then
		event.SetStatusbarShow(0, 1.0)
	end
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		event.SetLoadbgFile(
			"dungeon/chara/c01b_win.gltf",
			"textures/dungeon/image/senmetsu/finish.json",
			"snd2/sp/sp_000.sound.json"
		)
	else
		event.SetLoadbgFile(
			"dungeon/chara/c01b_win.gltf",
			"textures/dungeon/image/senmetsu/finish_1.json",
			"snd2/sp/sp_000.sound.json"
		)
	end
	if vm.wait() then
		return skip(2)
	end
	helper_40515d20()
	if vm.skipping() then
		return skip(3)
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMotion(5, "dungeon/chara/c01b_win.gltf", "info", 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if language_code == 0 then
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 228, 64)
		event.SpriteSetUvsize(0, 0, 0, 255, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, arg0)
	else
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish_1.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 512, 64)
		event.SpriteSetUvsize(0, 0, 0, 512, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, arg0)
	end
	event.EohSyncSprite(1, 0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	var3 = event.SndLoadSound(8, "snd2/sp/sp_000.sound.json") or var3
	var4 = event.GetEventInfoSndid(4) or var4
	event.SndSeStop(var4, 0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var11 = event.GetRefAngle(var5, var6, var7, pos_x, pos_y, pos_z) or var11
	var11 = vm.f32(var11 + vm.f32(0.4))
	var11 = event.AngleLimit(var11) or var11
	event.SetCameraCtrl(0)
	event.SetFcameraFollowFlag(1)
	event.SetFcameraFollowA(var5, var6 + 16.0, var7)
	event.SetCameraSpeed(14.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraHeight(-4.0)
	event.SetFcameraDist(48.0)
	event.EohSyncChara(0, 0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "目パチ")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetRot(0, 0.0, var11, 0.0)
	event.ObjsResetDaPosition(0)
	event.SetCrossfade(30)
	event.StopBgm(0)
	event.SndSePlay(var3, 0)
	event.InitDramaScene()
	event.ObjsSetMotion(0, "勝利のポーズ", 6)
	event.ObjsNextMotion(0, "勝利のポーズL", 4)
	event.ObjsSetScale(1, 1.0, 1.0, 0, 60)
	event.ObjsSetColor(1, 128, 128, 128, 128, 60)
	helper_72643bb6(90)
	if vm.skipping() then
		return skip(4)
	end
	if language_code == 0 then
		event.ObjsMove(1, 134.0, 370.0, 0, 20)
	else
		event.ObjsMove(1, 214.0, 370.0, 0, 20)
	end
	event.SetPakuAnim(0, "わらい口パク")
	helper_d1419c31(8500160, -1)
	if vm.skipping() then
		return skip(5)
	end
	helper_72643bb6(20)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

--- Helper function.
local function helper_24460(arg0: s32)
	local block: s32 = 0
	local language_code: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local language_code_2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_16358()
				helper_72643bb6(90)
			end
			if at <= 2 then
				helper_72643bb6(70)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetCameraCtrl(1)
		event.SetFadeIn(1)
		event.SndSeStop(var3, 0)
		event.LoadBgm(193)
		event.PlayBgm(0)
		event.DelImg(0)
		event.SetCrossfade(10)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.InitDramaScene()
	helper_16358()
	event.AssignStack(5)
	event.ClearStack(5)
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 228, 64)
		event.SpriteSetUvsize(0, 0, 0, 255, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, 1)
	else
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish_1.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 512, 64)
		event.SpriteSetUvsize(0, 0, 0, 512, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, 1)
	end
	var3 = event.SndLoadSound(8, "snd2/sp/sp_000.sound.json") or var3
	var4 = event.GetEventInfoSndid(4) or var4
	event.SndSeStop(var4, 0)
	event.StopBgm(0)
	event.SndSePlay(var3, 0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.SetCameraCtrl(0)
	event.SetFcameraFollowFlag(1)
	if arg0 == 2 then
		event.SetFcameraFollowA(var5, var6 + 40.0, var7)
	else
		event.SetFcameraFollowA(var5, var6 + 20.0, var7)
	end
	event.SetCameraSpeed(16.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraHeight(10.0)
	event.SetFcameraDist(64.0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsReference(0, pos_x, pos_y, pos_z, 10)
	event.EohSyncSprite(1, 0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetScale(1, 1.0, 1.0, 0, 60)
	event.ObjsSetColor(1, 128, 128, 128, 128, 60)
	helper_72643bb6(90)
	if vm.skipping() then
		return skip(2)
	end
	language_code_2 = event.GetLanguage() or language_code_2
	if language_code_2 == 0 then
		event.ObjsMove(1, 134.0, 370.0, 0, 20)
	else
		event.ObjsMove(1, 214.0, 370.0, 0, 20)
	end
	helper_72643bb6(70)
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Helper function.
local function helper_1545c()
	local parts_id: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	parts_id = event.GetDoorPartsId() or parts_id
	event.EohSyncFuncp(0, parts_id, "key")
	var1 = event.EohGetShow(0) or var1
	if parts_id < 0 or var1 == 0 then
		return
	end
	event.EohSyncObj(22, parts_id)
	do
		local out1, out2, out3 = event.EohGetPos(22)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.MinimapDoorEnable(pos_x, pos_y, pos_z)
	event.EohSyncObj(23, parts_id, "d02d05_1-m0")
	event.EohSetShow(23, 0)
	event.EohSyncObj(24, parts_id, "d02da05-a")
	event.EohSetShow(24, 0)
	event.EohSyncObj(25, parts_id, "d02dv05-c")
	event.EohSetShow(25, 0)
	event.FuncPointShow(parts_id, "key", 0)
end

--- Helper function.
local function helper_16f40(arg0: s32, arg1: s32)
	local block: s32 = 0
	local language_code: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local pin_col: s32 = 0
	local ball_col: s32 = 0
	local stage_id: s32 = 0
	local var13: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var13 = 1300.0
		var13 = 2000.0
		var13 = 16000.0
		var13 = 1500.0
		var13 = 1800.0
		var13 = 2100.0
		var13 = 2000.0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.AssignStack(4)
	event.ClearStack(4)
	event.ChangeDir("dungeon/sphida/")
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		block = event.LoadImg_4(4, "sphida_bar.json", 0) or block
	else
		block = event.LoadImg_4(4, "sphida_bar_1.json", 0) or block
	end
	event.SphidaSetUp(4, block, arg0, arg1)
	do
		local out1, out2, out3 = event.SphidaGetPinPos()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	do
		local out1, out2, out3 = event.SphidaGetBallPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pin_col = event.SphidaGetPinCol() or pin_col
	ball_col = event.SphidaGetBallCol() or ball_col
	event.LoadChara(4, "bball.gltf", "info", 8)
	event.LoadChara(4, "rball.gltf", "info", 9)
	if ball_col == 0 then
		event.CharaActive(0, 8)
		event.CharaActive(1, 9)
	else
		event.CharaActive(1, 8)
		event.CharaActive(0, 9)
	end
	if pin_col == 0 then
		event.LoadChara(4, "rgool.gltf", "info", 10)
		event.LoadChara(4, "rgool2.gltf", "info", 11)
	else
		event.LoadChara(4, "bgool.gltf", "info", 10)
		event.LoadChara(4, "bgool2.gltf", "info", 11)
	end
	event.SphidaSetColModel(4, "gool_a.gltf")
	event.ChangeDir("")
	event.CharaActive(10)
	event.CharaActive(11)
	event.SetCharaType(10, 4)
	event.SetCharaType(11, 4)
	stage_id = event.DngGetStageId() or stage_id
	if stage_id == 0 then
		var13 = 1300.0
	end
	if stage_id == 1 then
		var13 = 2000.0
	end
	if stage_id == 2 then
		var13 = 16000.0
	end
	if stage_id == 3 then
		var13 = 1500.0
	end
	if stage_id == 4 then
		var13 = 1800.0
	end
	if stage_id == 5 then
		var13 = 2100.0
	end
	if stage_id == 6 then
		var13 = 2000.0
	end
	event.SetCharaFarDist(8, var13)
	event.SetCharaShow(8, 1, 1, 1.0)
	event.SetCharaFarDist(9, var13)
	event.SetCharaShow(9, 1, 1, 1.0)
	event.SetCharaFarDist(10, var13)
	event.SetCharaShow(10, 1, 1, 1.0)
	event.SetCharaFarDist(11, var13)
	event.SetCharaShow(11, 1, 1, 1.0)
	event.SetCharaPos(8, pos_x, pos_y, pos_z)
	event.SetCharaPos(9, pos_x, pos_y, pos_z)
	event.SetCharaPos(10, pos_x_2, pos_y_2, pos_z_2)
	event.SetCharaPos(11, pos_x_2, pos_y_2, pos_z_2)
end

--- Helper function.
local function helper_17de4()
	local var0: any = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local box_pos_x: f32 = 0
	local box_pos_y: f32 = 0
	local box_pos_z: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = helper_a4e66753(0, 2002, 8, 256, 208, 2, 1)
		end
		if at <= 2 then
			var0 = helper_a4e66753(0, -1, 8, 256, 208, 2, 1)
		end
		var3 = 0
		var17 = vm.f32(var17 + 1.0)
		var19 = vm.f32(var19 + 1.0)
		var3 = var3 + 1
		var20 = vm.f32(var20 - vm.f32(3.1415927))
		var10 = vm.f32(vm.f32(vm.sin(var20) * 100.0) + var10)
		var11 = vm.f32(var11 + 30.0)
		var12 = vm.f32(vm.f32(vm.cos(var20) * 100.0) + var12)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.SetMesQuestionGyou(0, 0)
		var0 = helper_a4e66753(0, 2002, 8, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(2)
		end
	else
		event.SetMesQuestionGyou(0, 0)
		event.MesMake_2(0, "Muovere Max verso la Sphera?")
		var0 = helper_a4e66753(0, -1, 8, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if vm.wait() then
		return skip(4)
	end
	if var0 == 0 then
		do
			local out1, out2, out3 = event.SphidaGetBallPos()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.SphidaGetPinPos()
		do
			local out1, out2, out3, out4 = event.GetPartsFuncPos(pos_x, pos_y, pos_z, 100.0, "point")
			var2 = out1 or var2
			var10 = out2 or var10
			var11 = out3 or var11
			var12 = out4 or var12
		end
		if var2 == 0 then
			do
				local out1, out2, out3 = event.GetPartsOrigin(pos_x, pos_y, pos_z, 100.0)
				var10 = out1 or var10
				var11 = out2 or var11
				var12 = out3 or var12
			end
		end
		var3 = 0
		do
			local out1, out2, out3, out4 = event.GetNearTboxPos(var10, var11, var12)
			box_pos_x = out1 or box_pos_x
			box_pos_y = out2 or box_pos_y
			box_pos_z = out3 or box_pos_z
			var2 = out4 or var2
		end
		while var2 >= 0 do
			do
				local out1, out2, out3 = event.CopyVector(var10, var11, var12)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			do
				local out1, out2, out3 = event.SubVector(var17, var18, var19, box_pos_x, box_pos_y, box_pos_z)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			var17 = vm.f32(var17 + 1.0)
			var19 = vm.f32(var19 + 1.0)
			do
				local out1, out2, out3 = event.NormalVector(var17, var18, var19)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			do
				local out1, out2, out3 = event.ScaleVector(var17, var18, var19, 30.1)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			do
				local out1, out2, out3 = event.CopyVector(box_pos_x, box_pos_y, box_pos_z)
				var10 = out1 or var10
				var11 = out2 or var11
				var12 = out3 or var12
			end
			do
				local out1, out2, out3 = event.AddVector(var10, var11, var12, var17, var18, var19)
				var10 = out1 or var10
				var11 = out2 or var11
				var12 = out3 or var12
			end
			var3 = var3 + 1
			if var3 > 6 then
				break
			else
				do
					local out1, out2, out3, out4 = event.GetNearTboxPos(var10, var11, var12)
					box_pos_x = out1 or box_pos_x
					box_pos_y = out2 or box_pos_y
					box_pos_z = out3 or box_pos_z
					var2 = out4 or var2
				end
			end
		end
		var20 = event.GetRefAngle(var10, var11, var12, pos_x, pos_y, pos_z) or var20
		event.SetCharaPos(0, var10, var11, var12)
		event.SetCharaRot(0, 0.0, var20, 0.0)
		event.SetCameraRef(var10, var11 + 30.0, var12)
		var20 = vm.f32(var20 - vm.f32(3.1415927))
		var20 = event.AngleLimit(var20) or var20
		var10 = vm.f32(vm.f32(vm.sin(var20) * 100.0) + var10)
		var11 = vm.f32(var11 + 30.0)
		var12 = vm.f32(vm.f32(vm.cos(var20) * 100.0) + var12)
		event.SetCameraPos(var10, var11, var12)
		event.SetFcameraFollowOfs(0.0, 30.0, 0.0)
		event.SetFcameraHeight(5.0)
		event.SetFcameraDist(160.0)
		event.SetCameraSpeed(6.0)
		event.CtrlcSetRotCancel(1)
		event.CtrlcMoveRange(18.0, 10.0, 100.0, 160.0)
		event.ResetCamera(0)
	end
end

--- Helper function.
local function helper_2551c()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local is_play_sub_game: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local is_clear_most_fast_destroy: s32 = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local part3: () -> ...any
	local part4: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2178c(1)
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_22d94(1)
			if not vm.skipping() then
				return part3()
			end
		end
		if at <= 3 then
			helper_24460(active_chr_no)
			if not vm.skipping() then
				return part4()
			end
		end
		if at <= 4 then
			helper_1545c()
			helper_16f40(0, -1)
			helper_163d8(is_clear_most_fast_destroy, cleared, bonus)
		end
		if at <= 5 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
		if at <= 6 then
			helper_065641b0(0, 2130, 8, 0, 0)
		end
		if at <= 7 then
			helper_065641b0(0, 2120, 8, 0, 0)
		end
		if at <= 8 then
			helper_17de4()
		end
		if at <= 9 then
			helper_065641b0(0, 2110, 8, 0, 0)
		end
		if at <= 10 then
			helper_065641b0(0, 2100, 8, 0, 0)
		end
		if at <= 11 then
			helper_17de4()
		end
	end
	function part2()
		if active_chr_no == 1 then
			helper_22d94(1)
			if vm.skipping() then
				return skip(3)
			end
		end
		return part3()
	end
	function part3()
		if active_chr_no == 2 or active_chr_no == 3 then
			helper_24460(active_chr_no)
			if vm.skipping() then
				return skip(4)
			end
		end
		return part4()
	end
	function part4()
		event.DngPause(16384, 0)
		helper_1545c()
		event.ActchrSetDefMotion(0, 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.SetStatusbarShow(1, 0.16666667)
		stage_id = event.DngGetStageId() or stage_id
		var2 = event.DngGetFloorId() or var2
		event.SetFloorInfo(stage_id, var2, 5, 2)
		event.SetFloorInfo(stage_id, var2, 5, 1024)
		flag = event.GetFlag(220) or flag
		flag = event.GetFlag(317) or flag
		is_play_sub_game = event.IsPlaySubGame() or is_play_sub_game
		if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
			event.ClearRndStone()
			helper_16f40(0, -1)
		end
		do
			local out1, out2, out3 = event.GetBeforeCameraNextPos()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.SetCameraPos(position_x, position_y, position_z)
		do
			local out1, out2, out3 = event.GetBeforeCameraNextRef()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.SetCameraRef(position_x, position_y, position_z)
		is_clear_most_fast_destroy = event.IsClearDestroy() or is_clear_most_fast_destroy
		do
			local out1, out2 = event.IsClearPractice(0)
			cleared = out1 or cleared
			bonus = out2 or bonus
		end
		helper_163d8(is_clear_most_fast_destroy, cleared, bonus)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		var12 = event.GetTrialVersion() or var12
		var13 = event.GetFloorStatus() or var13
		if
			(if (if bit32.band(var13, 1) ~= 0 then 1 else bit32.band(var13, 2)) ~= 0 then 1 else bit32.band(var13, 4))
			~= 0
		then
			event.SetFloorStatus(7, 0)
			if bit32.band(var13, 1) ~= 0 then
				event.MesMake_2(0, "Il Sigillo rosso [UNI00e8] stato infranto.")
			end
			if bit32.band(var13, 2) ~= 0 then
				event.MesMake_2(0, "Il Sigillo blu [UNI00e8] stato infranto.")
			end
			if bit32.band(var13, 4) ~= 0 then
				event.MesMake_2(0, "Il Sigillo bianco [UNI00e8] stato infranto.")
			end
			helper_065641b0(0, -1, 8, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
		end
		helper_065641b0(0, 2130, 8, 0, 0)
		if vm.skipping() then
			return skip(7)
		end
		if var12 ~= 1 then
			if var3 == 1 and flag == 1 and bit32.band(is_play_sub_game, 3) == 3 then
				helper_065641b0(0, 2120, 8, 0, 0)
				if vm.skipping() then
					return skip(8)
				end
				helper_17de4()
				if vm.skipping() then
					return skip(9)
				end
			else
				if (if var3 == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
					helper_065641b0(0, 2110, 8, 0, 0)
					if vm.skipping() then
						return skip(10)
					end
				end
				if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
					helper_065641b0(0, 2100, 8, 0, 0)
					if vm.skipping() then
						return skip(11)
					end
					helper_17de4()
					if vm.skipping() then
						return skip(12)
					end
				end
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		event.DngPause(512, 0)
		event.Finish()
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	helper_16358()
	event.DngPause(512, 1)
	event.SetStatusbarShow(0, 0.16666667)
	helper_72643bb6(10)
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(16384, 1)
	event.DelMonster(-1)
	if active_chr_no == 0 then
		helper_2178c(1)
		if vm.skipping() then
			return skip(2)
		end
	end
	return part2()
end

--- Helper function.
local function helper_32fbc()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_065641b0(0, 2000, 8, 0, 0)
			end
			return 1
		end
		return 1
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 0 then
		event.SetMesWindowMode(0, 4)
		helper_065641b0(0, 2000, 8, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	var1 = event.GetEquipItemno(0, 0) or var1
	if var1 ~= 9 and var1 ~= 10 and var1 ~= 11 and var1 ~= 12 and var1 ~= 13 and var1 ~= 14 then
		event.SetMesWindowMode(0, 4)
		helper_065641b0(0, 2001, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	end
	event.SetMesWindowMode(0, 1)
	event.SphidaSetCulbNo(var1)
	event.PadAutoRepeatOff()
	return 0
end

--- Helper function.
local function helper_2f8e4(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32)
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local x_2: f32 = 0
	local y_2: f32 = 0
	local z_2: f32 = 0
	local angle: f32 = 0
	local var12: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		x = vm.f32(vm.sin(arg3) * 16.0)
		y = 8.0
		z = vm.f32(vm.cos(arg3) * 16.0)
		angle = vm.f32(arg4 - arg3)
		arg4 = vm.f32(arg3 + 0.5)
		arg3 = vm.f32(arg3 + vm.f32(0.2))
		arg4 = vm.f32(arg3 - 0.5)
		x_2 = vm.f32(vm.sin(arg4) * 16.0)
		y_2 = 8.0
		z_2 = vm.f32(vm.cos(arg4) * 16.0)
		return -1
	end
	if vm.skipping() then
		return skip(1)
	end
	arg3 = event.AngleLimit(arg3) or arg3
	arg3 = event.AngleLimit(arg3) or arg3
	arg4 = event.AngleLimit(arg4) or arg4
	arg4 = event.AngleLimit(arg4) or arg4
	x = vm.f32(vm.sin(arg3) * 16.0)
	y = 8.0
	z = vm.f32(vm.cos(arg3) * 16.0)
	if arg4 ~= arg3 then
		angle = vm.f32(arg4 - arg3)
		angle = event.AngleLimit(angle) or angle
		if angle > 0.0 then
			arg4 = vm.f32(arg3 + 0.5)
		else
			arg3 = vm.f32(arg3 + vm.f32(0.2))
			arg4 = vm.f32(arg3 - 0.5)
		end
	end
	arg4 = event.AngleLimit(arg4) or arg4
	x_2 = vm.f32(vm.sin(arg4) * 16.0)
	y_2 = 8.0
	z_2 = vm.f32(vm.cos(arg4) * 16.0)
	do
		local out1, out2, out3 = event.AddVector(x, y, z, arg0, arg1, arg2)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	do
		local out1, out2, out3 = event.AddVector(x_2, y_2, z_2, arg0, arg1, arg2)
		x_2 = out1 or x_2
		y_2 = out2 or y_2
		z_2 = out3 or z_2
	end
	var12 = event.ChkIntersectionPoint_9(12, x, y, z, arg0, arg1 + 8.0, arg2, 1) or var12
	if var12 >= 0 then
		return -1
	end
	var12 = event.ChkIntersectionPoint_9(12, x_2, y_2, z_2, arg0, arg1 + 8.0, arg2, 1) or var12
	if var12 >= 0 then
		return -1
	end
	var12 = event.ChkIntersectionPoint_9(12, x, y, z, x_2, y_2, z_2, 1) or var12
	if var12 >= 0 then
		return 0
	end
	var12 = event.ChkIntersectionPoint_9(12, x, y, z, x, y - 16.0, z, 1) or var12
	if var12 < 0 then
		return 0
	end
	var12 = event.ChkIntersectionPoint_9(12, x_2, y_2, z_2, x_2, y_2 - 16.0, z_2, 1) or var12
	if var12 < 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_333d8(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		arg1 = vm.f32(arg1 + 3.0)
		var7 = 0.0
		var8 = 0.0
		var9 = helper_2f8e4(
			arg0,
			arg1,
			arg2,
			vm.f32(vm.f32(arg3 + var8) + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 + var7) + vm.f32(1.5707964))
		)
		arg3 = vm.f32(arg3 + var7)
		var9 = helper_2f8e4(
			arg0,
			arg1,
			arg2,
			vm.f32(vm.f32(arg3 - var8) + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 - var7) + vm.f32(1.5707964))
		)
		arg3 = vm.f32(arg3 - var7)
		var8 = var7
		var7 = vm.f32(var7 + vm.f32(0.3926991))
		return arg0, arg1, arg2, arg3
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	event.SphidaSetBallPos(arg0, arg1 + 3.0, arg2)
	event.SetCharaPos(8, arg0, arg1 + 3.0, arg2)
	event.SetCharaPos(9, arg0, arg1 + 3.0, arg2)
	arg1 = vm.f32(arg1 + 3.0)
	do
		local out1, out2, out3 = event.SphidaGetPinPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	arg3 = event.GetRefAngle(arg0, arg1, arg2, pos_x, pos_y, pos_z) or arg3
	var7 = 0.0
	var8 = 0.0
	while var7 <= vm.f32(3.1415927) do
		var9 = helper_2f8e4(
			arg0,
			arg1,
			arg2,
			vm.f32(vm.f32(arg3 + var8) + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 + var7) + vm.f32(1.5707964))
		)
		if var9 == 1 then
			arg3 = vm.f32(arg3 + var7)
			break
		else
			var9 = helper_2f8e4(
				arg0,
				arg1,
				arg2,
				vm.f32(vm.f32(arg3 - var8) + vm.f32(1.5707964)),
				vm.f32(vm.f32(arg3 - var7) + vm.f32(1.5707964))
			)
			if var9 == 1 then
				arg3 = vm.f32(arg3 - var7)
				break
			else
				var8 = var7
				var7 = vm.f32(var7 + vm.f32(0.3926991))
			end
		end
	end
	event.SetCharaRot(0, 0.0, arg3, 0.0)
	event.SetMotion(0, "かまえ", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	return arg0, arg1, arg2, arg3
end

--- Helper function.
local function helper_33d44(arg0: f32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var2 = vm.f32(var2 + 25.0)
		arg0 = vm.f32(arg0 - vm.f32(3.1415927))
		var1 = vm.f32(vm.f32(vm.sin(arg0) * 100.0) + var1)
		var2 = vm.f32(var2 + 0.0)
		var3 = vm.f32(vm.f32(vm.cos(arg0) * 100.0) + var3)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetCameraCtrl(0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	var2 = vm.f32(var2 + 25.0)
	event.SetCameraRef(var1, var2, var3)
	arg0 = vm.f32(arg0 - vm.f32(3.1415927))
	arg0 = event.AngleLimit(arg0) or arg0
	var1 = vm.f32(vm.f32(vm.sin(arg0) * 100.0) + var1)
	var2 = vm.f32(var2 + 0.0)
	var3 = vm.f32(vm.f32(vm.cos(arg0) * 100.0) + var3)
	event.SetCameraPos(var1, var2, var3)
	event.SetCameraCtrl(1)
	event.CtrlcMoveRange(10.0, 40.0, 60.0, 160.0)
end

--- Helper function.
local function helper_34f80(arg0: f32, arg1: f32, arg2: s32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return arg0, arg1, arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	var3 = event.GetEquipItemno(0, 0) or var3
	do
		local out1, out2, out3 = event.SphidaGetCulbDef(var3)
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	return arg0, arg1, arg2
end

--- Helper function.
local function helper_2dac4(arg0: f32, arg1: f32, arg2: s32, sp: number)
	local language_code: s32 = 0
	local mini_level: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var18: f32 = 0
	local var19: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		language_code = 0
		language_code = language_code + 1
		mini_level = 0
		var6 = vm.f32(var6 + 3.0)
		var15 = vm.f32(var15 + 3.0)
		var18 = 100.0
		var11 = vm.f32(vm.sin(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
		var12 = vm.f32(20.0 * vm.sin(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)))
		var13 = vm.f32(vm.cos(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
		var19 = 0
		language_code = 0
		var18 = 100.0
		vm.stack(sp + 52)
		var18 = vm.f32(var18 - var29)
		vm.stack(sp + 47)
		var31 = vm.f32(20.0 - var29)
		vm.stack(sp + 43)
		var18 = vm.f32(var18 - var31)
		vm.stack(sp + 47)
		language_code = language_code + 1
		vm.stack(sp + 46)
		mini_level = mini_level + 1
		vm.stack(sp + 51)
		language_code = language_code + 1
		vm.stack(sp + 50)
		mini_level = mini_level + 1
		vm.stack(sp + 55)
		language_code = language_code + 1
		vm.stack(sp + 54)
		mini_level = mini_level + 1
		vm.stack(sp + 57)
		var19 = var19 + 1
		vm.stack(sp + 51)
	end
	if vm.skipping() then
		return skip(1)
	end
	language_code = 0
	while language_code < 48 do
		event.SpriteInit(language_code)
		event.SpriteSetType(language_code, 1)
		event.SpriteSetTexture(language_code, "sphida_bar", arg2)
		event.SpriteSetUvsize(language_code, 64, 0, 32, 32)
		event.SpriteSetPutsize(language_code, 2, 2)
		event.SpriteSetColor(language_code, 128, 128, 128, 128)
		event.SpriteSetDraw(language_code, 0)
		language_code = language_code + 1
	end
	mini_level = event.SphidaGetMiniLevel() or mini_level
	if mini_level == 0 then
		language_code = event.GetLanguage() or language_code
		event.SpriteSetType(31, 0)
		event.SpriteSetDraw(31, 1)
		if language_code == 0 then
			event.SpriteSetUvsize(31, 308, 146, 204, 30)
			event.SpriteSetPutsize(31, 204, 30)
			event.SpriteSetPos(31, 120, 30)
		else
			event.SpriteSetUvsize(31, 286, 146, 226, 30)
			event.SpriteSetPutsize(31, 226, 30)
			event.SpriteSetPos(31, 140, 30)
		end
	end
	mini_level = 0
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	var6 = vm.f32(var6 + 3.0)
	var15 = vm.f32(var15 + 3.0)
	var18 = 100.0
	var11 = vm.f32(vm.sin(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
	var12 = vm.f32(20.0 * vm.sin(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)))
	var13 = vm.f32(vm.cos(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
	do
		local out1, out2, out3 = event.CopyVector(var11, var12, var13)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = event.ScaleVector(var8, var9, var10, 5.0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	var19 = 0
	language_code = 0
	while var19 < 6 do
		var18 = 100.0
		do
			local out1, out2, out3 = event.CopyVector(var11, var12, var13)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		do
			local out1, out2, out3 = event.ScaleVector(var8, var9, var10, 5.0)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		while true do
			do
				local out1, out2, out3 = event.AddVector(var5, var6, var7, var8, var9, var10)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			vm.stack(sp + 47)
			do
				local out1, out2, out3, out4, out5, out6, out7 =
					event.ChkIntersectionPoint_15(12, var14, var15, var16, var5, var6, var7, 1)
				var20 = out1 or var20
				var21 = out2 or var21
				var22 = out3 or var22
				var23 = out4 or var23
				var24 = out5 or var24
				var25 = out6 or var25
				var30 = out7 or var30
			end
			if var30 >= 0 then
				do
					local out1, out2, out3 = event.CopyVector(-var11, -var12, -var13)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
				end
				do
					local out1, out2, out3 = event.NormalVector(var26, var27, var28)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
				end
				do
					local out1, out2, out3 = event.ScaleVector(var26, var27, var28, 3.0)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
				end
				do
					local out1, out2, out3 = event.AddVector(var20, var21, var22, var26, var27, var28)
					var20 = out1 or var20
					var21 = out2 or var21
					var22 = out3 or var22
				end
				var29 = event.DistVector2(var14, var15, var16, var20, var21, var22) or var29
				var18 = vm.f32(var18 - var29)
				if var18 <= 0.0 then
					break
				end
				while true do
					var29 = event.DistVector2(var14, var15, var16, var20, var21, var22) or var29
					if var29 <= 20.0 then
						var31 = vm.f32(20.0 - var29)
						var18 = vm.f32(var18 - var31)
						do
							local out1, out2, out3 = event.CopyVector(var20, var21, var22)
							var14 = out1 or var14
							var15 = out2 or var15
							var16 = out3 or var16
						end
						break
					end
					do
						local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
						var14 = out1 or var14
						var15 = out2 or var15
						var16 = out3 or var16
					end
					event.SpriteSetPos(language_code, var14, var15, var16)
					event.SpriteSetDraw(language_code, 1)
					language_code = vm.i32(language_code + 1)
					if vm.imod(language_code, 6) == 0 then
						event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
						mini_level = vm.i32(mini_level + 1)
					end
					if vm.imod(language_code, 5) == 0 then
						break
					end
					if language_code >= 31 then
						break
					end
				end
				if language_code >= 31 then
					break
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, var24, var25)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.ScaleVector(var11, var12, var13, var31)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
					var14 = out1 or var14
					var15 = out2 or var15
					var16 = out3 or var16
				end
				event.SpriteSetPos(language_code, var14, var15, var16)
				event.SpriteSetDraw(language_code, 1)
				language_code = language_code + 1
				if vm.imod(language_code, 6) == 0 then
					event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
					mini_level = vm.i32(mini_level + 1)
				end
				if language_code >= 31 then
					break
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, var24, var25)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.ScaleVector(var11, var12, var13, 20.0)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, var24, var25)
					var8 = out1 or var8
					var9 = out2 or var9
					var10 = out3 or var10
				end
				do
					local out1, out2, out3 = event.ScaleVector(var8, var9, var10, var18)
					var8 = out1 or var8
					var9 = out2 or var9
					var10 = out3 or var10
				end
				do
					local out1, out2, out3 = event.CopyVector(var14, var15, var16)
					var5 = out1 or var5
					var6 = out2 or var6
					var7 = out3 or var7
				end
				if vm.imod(language_code, 5) == 0 then
					break
				end
			else
				while language_code < 31 do
					do
						local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
						var14 = out1 or var14
						var15 = out2 or var15
						var16 = out3 or var16
					end
					event.SpriteSetPos(language_code, var14, var15, var16)
					event.SpriteSetDraw(language_code, 1)
					language_code = language_code + 1
					if vm.imod(language_code, 6) == 0 then
						event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
						mini_level = vm.i32(mini_level + 1)
					end
					if vm.imod(language_code, 5) == 0 then
						break
					end
				end
				do
					local out1, out2, out3 = event.CopyVector(var14, var15, var16)
					var5 = out1 or var5
					var6 = out2 or var6
					var7 = out3 or var7
				end
				break
			end
		end
		var19 = var19 + 1
	end
end

--- Helper function.
local function helper_2f78c()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var0 = 0
		var0 = var0 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = 0
	while var0 < 48 do
		event.SpriteSetDraw(var0, 0)
		var0 = var0 + 1
	end
end

--- Helper function.
local function helper_304e0(arg0: f32, arg1: f32, arg2: s32, sp: number)
	local junk = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local angle: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 60
			var5 = 76
			local _ = helper_2f8e4(
				var16,
				var17,
				var18,
				vm.f32(var11 + vm.f32(1.5707964)),
				vm.f32(vm.f32(var11 - vm.f32(var14 / 32.0)) + vm.f32(1.5707964))
			) == 1
			var11 = vm.f32(var11 - vm.f32(var14 / 32.0))
			var14 = 0.0
			var5 = 76
			var4 = 400
			var4 = 200
			var5 = 0
			var5 = var5 - 1
			var4 = var4 - 1
			var13 = arg1
			var13 = vm.f32(var13 + var15)
			var13 = 5.0
			var13 = 30.0
			arg0 = var11
			arg1 = var13
			angle = vm.f32(arg0 - vm.f32(3.1415927))
			helper_2dac4(arg0, arg1, arg2, sp + junk + 27)
			local _ = helper_de52ed87(0)
			var3 = 0
			local _ = helper_de52ed87(1)
			var3 = 1
			junk += 10
		end
		if at <= 2 then
			helper_2f78c()
		end
		return var3, arg0, arg1
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = 60
	var5 = 76
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	event.SetFcameraFollowFlag(1)
	event.SetCameraCtrl(1)
	event.CtrlcSetRotCancel(43)
	event.SetCameraSpeed(6.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraFollow(var6, var7 + 20.0, var8)
	event.SetFcameraHeight(0.0)
	event.SetFcameraDist(100.0)
	event.CtrlcMoveRange(10.0, 30.0, 80.0, 120.0)
	while true do
		do
			local out1, out2 = event.GetApad_2()
			var14 = out1 or var14
			var15 = out2 or var15
		end
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		do
			local out1, out2, out3 = event.GetCharaRot(0)
			var10 = out1 or var10
			var11 = out2 or var11
			var12 = out3 or var12
		end
		if var14 ~= 0.0 then
			if
				helper_2f8e4(
					var16,
					var17,
					var18,
					vm.f32(var11 + vm.f32(1.5707964)),
					vm.f32(vm.f32(var11 - vm.f32(var14 / 32.0)) + vm.f32(1.5707964))
				) == 1
			then
				var11 = vm.f32(var11 - vm.f32(var14 / 32.0))
			else
				var14 = 0.0
			end
		end
		event.SetCharaRot(0, var10, var11, var12)
		if var4 <= 0 then
			event.SetMotion(0, "待機")
			var5 = 76
			var4 = 400
		else
			if var14 ~= 0.0 then
				event.SetMotion(0, "かまえバタバタ")
				var4 = 200
				var5 = 0
			elseif var5 <= 0 then
				event.SetMotion(0, "かまえ")
			else
				var5 = var5 - 1
			end
			var4 = var4 - 1
		end
		var13 = arg1
		var13 = vm.f32(var13 + var15)
		if var13 <= 5.0 then
			var13 = 5.0
		end
		if var13 >= 30.0 then
			var13 = 30.0
		end
		arg0 = var11
		arg1 = var13
		event.SphidaCalcCarry(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)
		angle = vm.f32(arg0 - vm.f32(3.1415927))
		angle = event.AngleLimit(angle) or angle
		event.CtrlcSetRotate(angle)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		helper_2dac4(arg0, arg1, arg2, sp + junk + 19)
		if helper_de52ed87(0) ~= 0 then
			event.SetMotion(0, "かまえ")
			var3 = 0
			break
		elseif helper_de52ed87(1) ~= 0 then
			var3 = 1
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
	helper_2f78c()
	if vm.wait() then
		return skip(3)
	end
	return var3, arg0, arg1
end

--- Helper function.
local function helper_345fc(arg0: s32)
	local stage_id: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local count: s32 = 0
	local position_x_2: f32 = 0
	local position_y_2: f32 = 0
	local position_z_2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_065641b0(0, 2010, 8, 0, 0)
		end
		if at <= 2 then
			helper_065641b0(0, 2003, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SphidaSetStatusFlag(0)
	event.DeleteChara(12)
	event.EsmClear()
	event.DelExtMotion(0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.EohSyncChara(0, 2)
	event.EohSetShow(0, 1)
	event.SetCameraCtrl(1)
	event.DeleteSwordEffect()
	event.SetStatusbarShow(1, 0.1)
	event.SetCrossfade(15)
	if arg0 == 1 then
		stage_id = event.DngGetStageId() or stage_id
		var2 = event.DngGetFloorId() or var2
		var3 = event.GetFloorInfo(stage_id, var2, 4) or var3
		if var3 == 1 then
			var3 = event.GetSysSndId() or var3
			event.SndSePlay(var3, 18)
			event.SetFloorInfo(stage_id, var2, 5, 128)
			event.AddYarikomiMedal(1)
			do
				local out1, out2, out3 = event.GetBeforeCameraNextPos()
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			event.SetCameraPos(position_x, position_y, position_z)
			do
				local out1, out2, out3 = event.GetBeforeCameraNextRef()
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			event.SetCameraRef(position_x, position_y, position_z)
			event.SetMesWindowMode(0, 4)
			helper_065641b0(0, 2010, 8, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
			event.SetActiveCmrid(1)
			event.SetBeforeCmrid(0)
			event.SetFcameraFollowOfs(0.0, 30.0, 0.0)
			event.SetFcameraHeight(5.0)
			event.SetFcameraDist(160.0)
			event.SetCameraSpeed(6.0)
			event.CtrlcSetRotCancel(1)
			event.CtrlcMoveRange(18.0, 10.0, 100.0, 160.0)
			event.ResetCamera(0)
		end
	end
	count = event.SphidaGetParCount() or count
	if arg0 == 0 and count <= 0 then
		do
			local out1, out2, out3 = event.GetBeforeCameraNextPos()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.SetCameraPos(position_x_2, position_y_2, position_z_2)
		do
			local out1, out2, out3 = event.GetBeforeCameraNextRef()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.SetCameraRef(position_x_2, position_y_2, position_z_2)
		event.SetMesWindowMode(0, 4)
		helper_065641b0(0, 2003, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.ResetCamera(0)
	end
	event.Finish()
end

--- Helper function.
local function helper_31334(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: f32, arg5: s32, arg6: s32)
	local angle: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local code: s32 = 0
	local var12: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local var15: s32 = 0
	local value: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				var12 = 1
			end
			return 1, arg0, arg2, arg3, arg4, arg6
		end
		return 0, arg0, arg2, arg3, arg4, arg6
	end
	angle = vm.f32(arg2 - vm.f32(3.1415927))
	angle = event.AngleLimit(angle) or angle
	var12 = 0
	code = -10
	event.SphidaResetPowgage()
	event.SphidaStartPowgage()
	while code == -10 do
		event.CtrlcSetRotate(angle)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		do
			local out1, out2 = event.GetApad_2()
			var8 = out1 or var8
			var9 = out2 or var9
		end
		event.SphidaSetSpinMarkPos(var8, var9)
		if (if var12 == 0 then helper_de52ed87(1) else 0) ~= 0 then
			event.SphidaSetSpinMarkPos(0.0, 0.0)
			event.SphidaResetPowgage()
			return 1, arg0, arg2, arg3, arg4, arg6
		end
		if helper_de52ed87(0) ~= 0 then
			event.SphidaTriggerPowgage()
			if vm.wait() then
				return skip(1)
			end
			code = event.SphidaGetPowgageCode() or code
			if var12 == 0 or code ~= -10 then
				event.SndSePlay(arg5, 0)
				do
					local out1, out2 = event.SphidaGetPgCursorPos()
					x = out1 or x
					y = out2 or y
				end
				event.SpriteSetType(10 + var12, 0)
				event.SpriteSetAlphab(10 + var12, 2)
				event.SpriteSetUvsize(10 + var12, 0, 224, 32, 32)
				event.SpriteSetDraw(10 + var12, 1)
				event.SpriteSetPutsize(10 + var12, 32, 32)
				event.SpriteSetPos(10 + var12, x, y)
				event.SpriteSetScale(10 + var12, 0.2, 0.2, 0.2)
				event.EohSyncSprite(20 + var12, 10 + var12)
				event.ObjsInit(20 + var12)
				event.ObjsSyncObj(20 + var12, 20 + var12)
				event.ObjsSetScale(20 + var12, 2, 2, 2, 10)
				event.ObjsSetColor(20 + var12, 128, 128, 128, 128, 2)
				event.ObjsSetColor(20 + var12, 128, 128, 128, 0, 8)
				var12 = 1
			end
		else
			if vm.wait() then
				return skip(2)
			end
		end
		code = event.SphidaGetPowgageCode() or code
	end
	if code == 5 then
		event.SphidaSetSpinMarkPos(0.0, 0.0)
		event.SphidaResetPowgage()
		return 1, arg0, arg2, arg3, arg4, arg6
	end
	arg0 = event.SphidaGetShotPow() or arg0
	var15 = event.GetDebugFlag() or var15
	if var15 == 1 then
		var15 = event.GetPadon() or var15
		if bit32.band(var15, 16) ~= 0 then
			arg0 = 1.0
			code = 0
		end
	end
	if code == 4 then
		arg0 = vm.f32(arg0 * 0.0)
	end
	if code == -3 then
		arg0 = vm.f32(arg0 * vm.f32(0.4))
		value = event.GetRand(0.2) or value
		value = vm.f32(value - vm.f32(0.1))
		arg2 = vm.f32(vm.f32(arg2 - vm.f32(0.4)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.2)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.2)) * arg0)
	end
	if code == 3 then
		arg0 = vm.f32(arg0 * vm.f32(0.4))
		value = event.GetRand(0.2) or value
		value = vm.f32(value - vm.f32(0.1))
		arg2 = vm.f32(vm.f32(arg2 + vm.f32(0.4)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.2)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.2)) * arg0)
	end
	if code == -2 then
		arg0 = vm.f32(arg0 * vm.f32(0.8))
		value = event.GetRand(0.05) or value
		value = vm.f32(value - vm.f32(0.025))
		arg2 = vm.f32(vm.f32(arg2 - vm.f32(0.1)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.4)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.4)) * arg0)
	end
	if code == 2 then
		arg0 = vm.f32(arg0 * vm.f32(0.8))
		value = event.GetRand(0.05) or value
		value = vm.f32(value - vm.f32(0.025))
		arg2 = vm.f32(vm.f32(arg2 + vm.f32(0.1)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.4)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.4)) * arg0)
	end
	if code == -1 then
		arg0 = vm.f32(arg0 * 1.0)
		value = event.GetRand(0.01) or value
		arg2 = vm.f32(arg2 - value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.6)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.6)) * arg0)
	end
	if code == 1 then
		arg0 = vm.f32(arg0 * 1.0)
		value = event.GetRand(0.01) or value
		arg2 = vm.f32(arg2 + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.6)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.6)) * arg0)
	end
	if code == 0 then
		arg0 = vm.f32(arg0 * vm.f32(1.1))
		var8 = vm.f32(var8 * arg0)
		var9 = vm.f32(var9 * arg0)
	end
	arg6 = code
	arg2 = event.AngleLimit(arg2) or arg2
	arg3 = var8
	arg4 = var9
	helper_72643bb6(10)
	if vm.skipping() then
		return skip(3)
	end
	return 0, arg0, arg2, arg3, arg4, arg6
end

--- Helper function.
local function helper_34190(arg0: s32)
	local count: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		count = count - 1
	end
	if vm.skipping() then
		return skip(1)
	end
	count = event.SphidaGetParCount() or count
	count = vm.i32(count - 1)
	event.SphidaSetParCount(count)
	if count <= 0 then
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.SphidaSetPlayFlag(0)
		if arg0 ~= -1 then
			event.SndSePlay(arg0, 19)
		end
	end
end

--- Helper function.
local function helper_49ce4()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	helper_16b7c()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_22d94(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 101.
script[101] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3eec4(0)
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.Initialize()
	helper_16b7c()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d02f01", "d02f01", 1)
	event.LoadMonsterFile(0)
	event.AutoSetTreasureBox(-1)
	event.AutoSetMonster(-1)
	helper_3eec4(0)
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 102.
script[102] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.DngSetupMainUnit(2)
	event.SetActiveChrNo(2)
	event.SetCharaPos(0, var0, var1, var2)
	if vm.wait() then
		return skip(2)
	end
	event.Finish()
end

--- Program 200.
script[200] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.AddItem(305, 1)
	event.AddItem(306, 1)
	argc = event.GetItemHaveNum(10) or argc
	if argc <= 0 then
		event.AddItem(10, 1)
	end
	argc = event.GetItemHaveNum(302) or argc
	if argc <= 0 then
		event.AddItem(302, 1)
	end
	event.SetFlag(220, 1)
	event.SetFlag(317, 1)
	event.DelMonster(-1)
	event.Finish()
end

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_44604(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 310.
script[310] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_44604(1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 320.
script[320] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_44604(2)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 330.
script[330] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_44604(3)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 340.
script[340] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_45788()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 348.
script[348] = function()
	local now_party_chara_id: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_47ad0()
			end
			if at <= 2 then
				helper_72643bb6(6)
			end
			return
		end
		if at <= 4 then
			var1 = 2
			helper_72643bb6(6)
		end
		if at <= 6 then
			helper_47ad0()
		end
		if at <= 7 then
			helper_46834()
		end
		if at <= 8 then
			helper_1589c()
		end
		if at <= 9 then
			helper_72643bb6(6)
		end
	end
	event.Initialize()
	event.DngPause(1, 1)
	helper_16358()
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 4 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "Dovete passare da qui, giusto?")
		helper_065641b0(0, -1, 5, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.SetStatusbarShow(0, 0.16666667)
		event.DngPause(16, 1)
		helper_47ad0()
		if vm.skipping() then
			return skip(2)
		end
		event.DngPause(16, 0)
		event.SetStatusbarShow(1, 0.16666667)
		helper_72643bb6(6)
		if vm.skipping() then
			return skip(3)
		end
		event.DngPause(1, 0)
		event.Finish()
		return
	end
	var1 = event.GetEventData_2(6) or var1
	if var1 == 1 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.SetMesDrawspeed(0, 1)
		var2 = helper_08ca16f6(0, 2501, 5, 256, 208, var2)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMesShippo(0, 1)
		event.SetMesDrawspeed(0, 0)
		if var2 == 1 then
			var1 = 2
		end
	end
	if var1 == 2 then
		event.SetStatusbarShow(0, 0.16666667)
		helper_72643bb6(6)
		if vm.skipping() then
			return skip(5)
		end
		event.GotoUseItem(340)
		do
			local skipped = vm.wait()
			var3 = event.DeferredOutput() or var3
			if skipped then
				return skip(6)
			end
		end
		if var3 == 340 then
			event.DngPause(16, 1)
			active_chr_no = event.GetActiveChrNo() or active_chr_no
			if active_chr_no == 2 or active_chr_no == 3 then
				helper_47ad0()
				if vm.skipping() then
					return skip(7)
				end
			else
				helper_46834()
				if vm.skipping() then
					return skip(8)
				end
			end
			event.DngPause(16, 0)
		elseif var3 <= 0 then
		else
			helper_1589c()
			if vm.skipping() then
				return skip(9)
			end
		end
		event.SetStatusbarShow(1, 0.16666667)
		helper_72643bb6(6)
		if vm.skipping() then
			return skip(10)
		end
	end
	event.DngPause(1, 0)
	event.Finish()
end

script[1000] = program_1000

script[1010] = program_1010

--- Program 1100.
script[1100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2076c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1120.
script[1120] = function()
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var11: s32 = 0
	local weight: f32 = 0
	local var14: f32 = 0
	local now_party_chara_id: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local pos_x_4: f32 = 0
	local pos_y_4: f32 = 0
	local pos_z_4: f32 = 0
	local var26: f32 = 0
	local value: s32 = 0
	local angle: f32 = 0
	local value_2: s32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local var32: s32 = 0
	local result: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_065641b0(0, 23, 8, 0, 0)
			end
			var1 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
			var2 = pos_y
			var3 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
			return
		end
		if at <= 3 then
			helper_16358()
			helper_40515d20()
		end
		if at <= 5 then
			helper_40515d20()
		end
		if at <= 6 then
			var14 = vm.f32(var14 - vm.f32(3.1415927))
			var18 = 0
			var19 = vm.f32(0.6)
			var14 = vm.f32(var14 + var19)
			helper_cdbc()
			local _ = helper_de52ed87(0)
		end
		if at <= 7 then
			var18 = var18 + 1
		end
		if at <= 8 then
			helper_e3a29715()
			value = 0
			value = value + 4
			var18 = 0
			var14 = vm.f32(var14 + var19)
		end
		if at <= 9 then
			var19 = vm.f32(var19 * vm.f32(0.9))
			angle = var26
			local _ = helper_832c49cb(var14, angle, vm.f32(0.08)) == 0
			var17 = 0
			angle = vm.f32(var26 - vm.f32(3.1415927))
			local _ = helper_832c49cb(var14, angle, vm.f32(0.08)) == 0
			var17 = 1
			var18 = vm.i32(var18 + 1)
			local _ = helper_832c49cb(var14, var26, 1.0) == 0
			var17 = 0
			var17 = 1
			var26 = var14
			helper_72643bb6(20)
		end
		if at <= 10 then
			var30 = 100
			var30 = 6
			var30 = 0
			var30 = 2
			var30 = 100
			var30 = 4
			var26 = vm.f32(var26 + vm.f32(3.14))
			var17 = 1
			var17 = 0
			helper_72643bb6(10)
		end
		if at <= 11 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = vm.f32(var26 + vm.f32(1.57))
			var26 = vm.f32(var26 + vm.f32(1.57))
			helper_72643bb6(20)
		end
		if at <= 12 then
			local _ = helper_832c49cb(var14, var26, 1.0) == 0
			var17 = 0
			var17 = 1
			var31 = 1.0
			var18 = 0
			var31 = vm.f32(var31 + vm.f32(0.03))
			var18 = var18 + 1
		end
		if at <= 13 then
			helper_065641b0(0, 2310, 8, 0, 0)
		end
		if at <= 14 then
			helper_065641b0(0, 2311, 8, 0, 0)
		end
		if at <= 15 then
			helper_065641b0(0, 2312, 8, 0, 0)
		end
		if at <= 16 then
			helper_065641b0(0, 2313, 8, 0, 0)
		end
		if at <= 17 then
			helper_065641b0(0, 2314, 8, 0, 0)
		end
		if at <= 18 then
			var31 = vm.f32(var31 - vm.f32(0.03))
			var18 = var18 + 1
		end
		if at <= 19 then
			helper_065641b0(0, 2320, 8, 0, 0)
		end
		if at <= 20 then
			helper_065641b0(0, 2321, 8, 0, 0)
		end
		if at <= 21 then
			helper_065641b0(0, 2322, 8, 0, 0)
		end
		if at <= 22 then
			helper_065641b0(0, 2323, 8, 0, 0)
		end
		if at <= 23 then
			helper_065641b0(0, 2324, 8, 0, 0)
		end
		if at <= 24 then
			helper_065641b0(0, 2325, 8, 0, 0)
		end
		if at <= 25 then
			helper_065641b0(0, 2328, 8, 0, 0)
		end
		if at <= 26 then
			helper_065641b0(0, 2326, 8, 0, 0)
		end
		if at <= 27 then
			helper_065641b0(0, 2329, 8, 0, 0)
		end
		if at <= 28 then
			helper_065641b0(0, 2327, 8, 0, 0)
		end
		if at <= 29 then
			helper_065641b0(0, 2330, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(513, 1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_16358()
		if active_chr_no == 2 then
			helper_065641b0(0, 22, 8, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_065641b0(0, 23, 8, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local out1, out2, out3 = event.RandomCircleGetPos(-1)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		yaw = event.GetRefAngle(pos_x, pos_y, pos_z, var1, var2, var3) or yaw
		var1 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
		var2 = pos_y
		var3 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
		event.SetCharaPos(0, var1, var2, var3)
		event.DngPause(513, 0)
		event.Finish()
		return
	end
	event.SetLoadbgFile("snd2/sp/sp_011.sound.json")
	if vm.wait() then
		return skip(3)
	end
	helper_16358()
	do
		local out1, out2, out3 = event.RandomCircleGetPos(-1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.SetCameraCtrl(0)
	event.SetFcameraFollowFlag(1)
	event.SetFcameraFollowA(pos_x_2, pos_y_2 + 30.0, pos_z_2)
	event.SetCameraSpeed(8.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraHeight(0.0)
	event.SetFcameraDist(80.0)
	event.AssignStack(5)
	event.ClearStack(5)
	helper_40515d20()
	if vm.skipping() then
		return skip(4)
	end
	var11 = event.SndLoadSound(8, "snd2/sp/sp_011.sound.json") or var11
	event.ChangeDir("event/dng/")
	event.SetLoadbgFile("ring.gltf", "randomcoin.gltf")
	if vm.wait() then
		return skip(5)
	end
	helper_40515d20()
	if vm.skipping() then
		return skip(6)
	end
	weight = event.GetRndcMotNowt() or weight
	event.RandomCircleOff(-1)
	event.LoadChara(5, "ring.gltf", "info", 12)
	event.CharaActive(1, 12)
	event.SetCharaPos(12, pos_x_2, pos_y_2, pos_z_2)
	event.SetMotion(12, "ループ", 6)
	event.CharaNormalDrive(12)
	event.SetCharaMotNowt(12, weight)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsNextMotion(4, "消滅", 6)
	event.LoadChara(5, "randomcoin.gltf", "info", 13)
	event.CharaActive(1, 13)
	event.SetCharaPos(13, pos_x_2, pos_y_2 - 30.0, pos_z_2)
	var14 = event.GetRand(6.2831855) or var14
	var14 = vm.f32(var14 - vm.f32(3.1415927))
	var14 = event.AngleLimit(var14) or var14
	event.SetCharaRot(13, 0.0, var14, 0.0)
	event.ChangeDir("")
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetScale(5, 0.0, 0.0, 0.0)
	event.ObjsSetScale(5, 1.0, 1.0, 1.0, 40)
	event.ObjsMove2(5, pos_x_2, pos_y_2 + 40.0, pos_z_2, 30, 2, 0.5)
	var18 = 0
	var19 = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.GetCharaRot(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.AngleLimit(var14) or var14
		event.SetCharaRot(13, 0.0, var14, 0.0)
		if var18 == 10 then
			event.SndSePlay(var11, 0)
		end
		if var18 == 30 then
			helper_cdbc()
		end
		if (if var18 >= 30 then helper_de52ed87(0) else 0) ~= 0 or var18 > 300 then
			event.SndSeStop(var11, 0)
			event.SndSePlay(var11, 3)
			if vm.wait() then
				return skip(7)
			end
			break
		else
			var18 = var18 + 1
			if vm.wait() then
				return skip(8)
			end
		end
	end
	helper_e3a29715()
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_4 = out1 or pos_x_4
		pos_y_4 = out2 or pos_y_4
		pos_z_4 = out3 or pos_z_4
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	value = 0
	value = event.GetRandInt(10) or value
	value = vm.i32(value + 4)
	var18 = 0
	while true do
		do
			local _, out2, _ = event.GetCharaRot(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.AngleLimit(var14) or var14
		event.SetCharaRot(13, 0.0, var14, 0.0)
		if vm.wait() then
			return skip(9)
		end
		if var18 >= value then
			if var19 > vm.f32(0.08) then
				var19 = vm.f32(var19 * vm.f32(0.9))
			end
			angle = var26
			angle = event.AngleLimit(angle) or angle
			if var14 < angle and helper_832c49cb(var14, angle, vm.f32(0.08)) == 0 then
				event.SetCharaRot(13, 0.0, angle, 0.0)
				var17 = 0
				break
			end
			angle = vm.f32(var26 - vm.f32(3.1415927))
			angle = event.AngleLimit(angle) or angle
			if var14 < angle and helper_832c49cb(var14, angle, vm.f32(0.08)) == 0 then
				event.SetCharaRot(13, 0.0, angle, 0.0)
				var17 = 1
				break
			end
		end
		var18 = vm.i32(var18 + 1)
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.GetCharaRot(13)
		var14 = out2 or var14
	end
	if helper_832c49cb(var14, var26, 1.0) == 0 then
		var17 = 0
	else
		var17 = 1
	end
	var26 = var14
	helper_72643bb6(20)
	if vm.skipping() then
		return skip(10)
	end
	value_2 = event.GetRandInt(10) or value_2
	if now_party_chara_id == 24 then
		var30 = 100
	else
		var30 = 6
	end
	if value_2 < var30 then
		value_2 = event.GetRandInt(10) or value_2
		if var17 == 0 then
			if now_party_chara_id == 24 then
				var30 = 0
			else
				var30 = 2
			end
		elseif now_party_chara_id == 24 then
			var30 = 100
		else
			var30 = 4
		end
		if value_2 < var30 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = event.AngleLimit(var26) or var26
			event.ObjsRotation(5, 0.0, var26, 0.0, 8)
			if var17 == 0 then
				var17 = 1
			else
				var17 = 0
			end
			helper_72643bb6(10)
			if vm.skipping() then
				return skip(11)
			end
		else
			value_2 = event.GetRandInt(10) or value_2
			if value_2 < 1 then
				var26 = vm.f32(var26 + vm.f32(3.14))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 6)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 3)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 3)
				helper_72643bb6(20)
				if vm.skipping() then
					return skip(12)
				end
			end
		end
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.GetCharaRot(13)
		var14 = out2 or var14
	end
	if helper_832c49cb(var14, var26, 1.0) == 0 then
		var17 = 0
	else
		var17 = 1
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	var31 = 1.0
	var18 = 0
	var32 = event.GetRndCircleTrapid(var17) or var32
	if var17 == 0 then
		event.SndSePlay(var11, 1)
		while var18 < 30 do
			event.BscnSetBlightRate(var31)
			var31 = vm.f32(var31 + vm.f32(0.03))
			var18 = var18 + 1
			if vm.wait() then
				return skip(13)
			end
		end
		helper_065641b0(0, 2310, 8, 0, 0)
		if vm.skipping() then
			return skip(14)
		end
		result = event.SetRndCircleStatus(var32) or result
		if var32 == 1 then
			helper_065641b0(0, 2311, 8, 0, 0)
			if vm.skipping() then
				return skip(15)
			end
		end
		if var32 == 2 then
			helper_065641b0(0, 2312, 8, 0, 0)
			if vm.skipping() then
				return skip(16)
			end
		end
		if var32 == 3 then
			helper_065641b0(0, 2313, 8, 0, 0)
			if vm.skipping() then
				return skip(17)
			end
		end
		if var32 == 4 then
			event.PostTreasureBox(pos_x_2, pos_y_2, pos_z_2, var26, 294)
			helper_065641b0(0, 2314, 8, 0, 0)
			if vm.skipping() then
				return skip(18)
			end
		end
	else
		event.SndSePlay(var11, 2)
		while var18 < 30 do
			event.BscnSetBlightRate(var31)
			var31 = vm.f32(var31 - vm.f32(0.03))
			var18 = var18 + 1
			if vm.wait() then
				return skip(19)
			end
		end
		helper_065641b0(0, 2320, 8, 0, 0)
		if vm.skipping() then
			return skip(20)
		end
		result = event.SetRndCircleStatus(var32) or result
		if var32 == 5 then
			if active_chr_no == 0 or active_chr_no == 2 then
				helper_065641b0(0, 2321, 8, 0, 0)
				if vm.skipping() then
					return skip(21)
				end
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_065641b0(0, 2322, 8, 0, 0)
				if vm.skipping() then
					return skip(22)
				end
			end
		end
		if var32 == 6 then
			if active_chr_no == 0 then
				helper_065641b0(0, 2323, 8, 0, 0)
				if vm.skipping() then
					return skip(23)
				end
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_065641b0(0, 2324, 8, 0, 0)
				if vm.skipping() then
					return skip(24)
				end
			end
			if active_chr_no == 2 then
				helper_065641b0(0, 2325, 8, 0, 0)
				if vm.skipping() then
					return skip(25)
				end
			end
		end
		if var32 == 8 then
			helper_065641b0(0, 2328, 8, 0, 0)
			if vm.skipping() then
				return skip(26)
			end
		end
		if var32 == 9 then
			helper_065641b0(0, 2326, 8, 0, 0)
			if vm.skipping() then
				return skip(27)
			end
		end
		if var32 == 10 then
			helper_065641b0(0, 2329, 8, 0, 0)
			if vm.skipping() then
				return skip(28)
			end
		end
		if var32 == 11 then
			helper_065641b0(0, 2327, 8, 0, 0)
			if vm.skipping() then
				return skip(29)
			end
		end
		if var32 == 12 then
			helper_065641b0(0, 2330, 8, 0, 0)
			if vm.skipping() then
				return skip(30)
			end
		end
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.BscnSetBlightRate(1.0)
	if var32 == 1 then
		event.SetPullItem(pos_x_2, pos_y_2, pos_z_2, 1, 10, result / 10.0)
	end
	event.DngPause(513, 0)
	event.SetCameraCtrl(1)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextPos()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraPos(position_x, position_y, position_z)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextRef()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraRef(position_x, position_y, position_z)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.SetCrossfade(15)
	event.Finish()
end

--- Program 1130.
script[1130] = function()
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local argc: s32 = 0
	local stage_id: s32 = 0
	local var23: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_065641b0(0, 23, 8, 0, 0)
			end
			return
		end
		if at <= 3 then
			helper_40515d20()
		end
		if at <= 5 then
			helper_40515d20()
		end
		if at <= 6 then
			pos_y_2 = vm.f32(var9 + 18.0)
			var17 = vm.f32(var17 + vm.f32(2.9))
			var17 = vm.f32(var17 + vm.f32(2.4))
			var8 = vm.f32(vm.f32(vm.sin(var17) * 14.0) + pos_x_2)
			var10 = vm.f32(vm.f32(vm.cos(var17) * 14.0) + pos_z_2)
			var17 = vm.f32(var17 - vm.f32(3.1415927))
			var18 = vm.f32(vm.f32(vm.sin(var17) * 8.0) + var8)
			var19 = vm.f32(var9 + 18.0)
			var20 = vm.f32(vm.f32(vm.cos(var17) * 8.0) + var10)
			helper_72643bb6(16)
		end
		if at <= 7 then
			helper_72643bb6(2)
		end
		if at <= 8 then
			helper_72643bb6(10)
		end
		if at <= 9 then
			helper_72643bb6(20)
		end
		if at <= 10 then
			helper_059d36ae(0)
		end
		if at <= 11 then
			helper_065641b0(0, 2400, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(513, 1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_16358()
		if active_chr_no == 2 then
			helper_065641b0(0, 22, 8, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_065641b0(0, 23, 8, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		event.DngPause(513, 0)
		event.Finish()
		return
	end
	event.DngPause(16, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetFlag(31, 1)
	event.SetMotion(0, "立ち")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	if active_chr_no == 0 then
		event.SetLoadbgFile(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		if vm.wait() then
			return skip(3)
		end
		helper_40515d20()
		if vm.skipping() then
			return skip(4)
		end
		event.LoadMotion(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.SetLoadbgFile(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		if vm.wait() then
			return skip(5)
		end
		helper_40515d20()
		if vm.skipping() then
			return skip(6)
		end
		event.LoadMotion(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	var4 = event.SndLoadSound(8, "snd2/sp/sp_012.sound.json") or var4
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	event.CopyVector(var8, var9, var10)
	event.GeostoneAnimeOff()
	event.EohSyncGeostone(1)
	do
		local out1, out2, out3 = event.EohGetPos(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(var9 + 18.0)
	event.EohSetPos(1, pos_x_2, pos_y_2, pos_z_2)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	var17 = event.GetRefAngle(pos_x_2, pos_y_2, pos_z_2, pos_x, pos_y, pos_z) or var17
	var17 = event.AngleLimit(var17) or var17
	if active_chr_no == 0 then
		var17 = vm.f32(var17 + vm.f32(2.9))
	end
	if active_chr_no == 1 then
		var17 = vm.f32(var17 + vm.f32(2.4))
	end
	var17 = event.AngleLimit(var17) or var17
	var8 = vm.f32(vm.f32(vm.sin(var17) * 14.0) + pos_x_2)
	var10 = vm.f32(vm.f32(vm.cos(var17) * 14.0) + pos_z_2)
	event.SetCharaPos(0, var8, var9, var10)
	var17 = vm.f32(var17 - vm.f32(3.1415927))
	var17 = event.AngleLimit(var17) or var17
	event.SetCharaRot(0, 0.0, var17, 0.0)
	event.EohResetDaPosition(0)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.CharaActive(0, 12)
	if active_chr_no == 0 then
		event.SetCameraCtrl(0)
		event.SetFcameraFollowFlag(1)
		event.SetFcameraFollowA(var8, var9 + 18.0, var10)
		event.SetCameraSpeed(16.0)
		event.SetFcameraFollowOfs(0.0, 6.0, 0.0)
		event.SetFcameraHeight(-14.0)
		event.SetFcameraDist(54.0)
		event.SetCharaPos(12, var8, var9 + 36.0, var10)
	end
	if active_chr_no == 1 then
		event.SetCameraCtrl(0)
		event.SetFcameraFollowFlag(1)
		event.SetFcameraFollowA(var8, var9 + 18.0, var10)
		event.SetCameraSpeed(16.0)
		event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
		event.SetFcameraHeight(-5.0)
		event.SetFcameraDist(34.0)
		var18 = vm.f32(vm.f32(vm.sin(var17) * 8.0) + var8)
		var19 = vm.f32(var9 + 18.0)
		var20 = vm.f32(vm.f32(vm.cos(var17) * 8.0) + var10)
		event.SetCharaPos(12, var18, var19, var20)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.SetCrossfade(30)
	event.ObjsSetMotion(0, "取る", 6)
	event.ObjsNextMotion(0, "取るL", 4)
	helper_72643bb6(16)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var4, 0)
	helper_72643bb6(2)
	if vm.skipping() then
		return skip(8)
	end
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.GeostoneSetReference(0, "item")
	helper_72643bb6(10)
	if vm.skipping() then
		return skip(9)
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var17 = event.GetRefAngle(var8, var9, var10, pos_x, pos_y, pos_z) or var17
	event.SetCharaRot(12, 0.0, var17, 0.0)
	event.CharaActive(1, 12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetMotion(4, "発動", 6, 1.2)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "発動", 5)
	helper_72643bb6(20)
	if vm.skipping() then
		return skip(10)
	end
	event.SndSePlay(var4, 1)
	helper_059d36ae(0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_065641b0(0, 2400, 8, 0, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	stage_id = event.DngGetStageId() or stage_id
	var23 = event.DngGetFloorId() or var23
	event.SetFloorInfo(stage_id, var23, 5, 256)
	event.SetCrossfade(10)
	if active_chr_no == 1 then
		event.SetMotion(0, "取る戻り", 6)
		if vm.wait() then
			return skip(13)
		end
	end
	event.DngPause(529, 0)
	event.SetMotion(0, "立ち", 4)
	event.SetCharaPos(0, var1, var2, var3)
	event.EohResetDaPosition(0)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.GeostoneDelReference()
	event.GeostoneSetFlag(0)
	event.EohSetScale(1, 1.0, 1.0, 1.0)
	event.DelExtMotion(0)
	event.DeleteChara(12)
	event.SetCameraCtrl(1)
	event.Finish()
end

--- Program 1150.
script[1150] = function()
	local var0: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_2d720()
		end
	end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		helper_2d720()
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	do
		local _, out2, _ = event.GetMonsterTalkData_3()
		var2 = out2 or var2
	end
	flag = event.GetFlag(290) or flag
	if flag == 0 and var2 == 52 then
		event.AddItem(356)
		helper_147ec()
		if vm.skipping() then
			return skip(2)
		end
	else
		helper_2d720()
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_73e33ef4(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1500.
script[1500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2551c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 2500.
script[2500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.DngPause(513, 1)
	event.SetFlag(50, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_065641b0(0, 2600, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- Program 2510.
script[2510] = function()
	local var0: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			_, var0 = helper_cb795f9c(0, 0, var0)
		end
		helper_7443da3d(0)
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_fcb18908(0, 2610, 8, 0, 0)
	helper_72643bb6(30)
	if vm.skipping() then
		return skip(1)
	end
	_, var0 = helper_cb795f9c(0, 0, var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_7443da3d(0)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- Program 2520.
script[2520] = function()
	local var0: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			_, var0 = helper_cb795f9c(0, 0, var0)
		end
		if at <= 2 then
			helper_7443da3d(0)
			helper_065641b0(0, 2621, 8, 0, 0)
		end
		if at <= 3 then
			helper_065641b0(0, 2622, 8, 0, 0)
		end
		if at <= 4 then
			helper_065641b0(0, 2623, 8, 0, 0)
		end
		if at <= 5 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_fcb18908(0, 2620, 8, 0, 0)
	helper_72643bb6(30)
	if vm.skipping() then
		return skip(1)
	end
	_, var0 = helper_cb795f9c(0, 0, var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_7443da3d(0)
	helper_065641b0(0, 2621, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_065641b0(0, 2622, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_065641b0(0, 2623, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Sei hai dubbi, vedi Guida da Menu principale.")
	helper_065641b0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	if vm.wait() then
		return skip(7)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- Program 2530.
script[2530] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.DngPause(513, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(
		0,
		"[(!)]Guida del Fuoristrada\n   Accelera con (L)↑; Rallenta con (L)↓.\n   Sterza con (L) ← oppure →.\n   Per le curve strette, [l1] + (L) ← o →."
	)
	helper_065641b0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- Program 2540.
script[2540] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
		if at <= 2 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
		if at <= 3 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
		if at <= 4 then
			helper_065641b0(0, -1, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "[(!)]Ora sai usare la Spada Assorbi-magia.")
	helper_065641b0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"In guardia, la Spada Assorbi-magia\nassorbe l'energia degli attacchi\nelementali, come Fuoco. In attacco,\nrilascer[UNI00e0] poi l'energia assorbita."
	)
	helper_065641b0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"[UNI00c8] possibile caricare continuamente\nenergia dello stesso elemento.\nPer[UNI00f2], assorbendo un elemento\ndiverso, si perde l'intera carica."
	)
	helper_065641b0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "L'energia elementale assorbibile\ndipende dalla robustezza dell'arma.")
	helper_065641b0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Per usare l'energia elementale\nassorbita come magia, premi\n[l1] mentre sei in guardia con [r1]."
	)
	helper_065641b0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	if vm.wait() then
		return skip(6)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- Program 3000.
script[3000] = function()
	local sp: number = 0
	local junk = 0
	local tex_bank: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: s32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: s32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var29: s32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	local var41: s32 = 0
	local var42: s32 = 0
	local var43: s32 = 0
	local var44: s32 = 0
	local var45: s32 = 0
	local var46: s32 = 0
	local var47: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var51: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local yaw: f32 = 0
	local count: s32 = 0
	local var57: any = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_16358()
				local _ = helper_32fbc()
				junk += 1
			end
			return
		end
		if at <= 6 then
			if at <= 3 then
				helper_40515d20()
			end
			if at <= 4 then
				var2, var3, var4, var6 = helper_333d8(var2, var3, var4, var6)
				helper_33d44(var6)
				var11 = 12.5
				var12, var13, var14 = helper_34f80(var12, var13, var14)
				_, var6, var11 = helper_304e0(var6, var11, tex_bank, sp + junk + 59)
				junk += 2
			end
			if at <= 5 then
				helper_345fc(0)
			end
			return
		end
		if at <= 14 then
			if at <= 8 then
				var21 = 0
				helper_72643bb6(10)
				junk += 8
			end
			if at <= 9 then
				helper_72643bb6(25)
				junk += 1
			end
			if at <= 10 then
				helper_72643bb6(34)
				junk += 2
			end
			if at <= 11 then
				helper_72643bb6(39)
			end
			if at <= 12 then
				helper_72643bb6(50)
				junk += 2
			end
			if at <= 13 then
				helper_34190(var1)
				helper_345fc(0)
			end
			return
		end
		if at <= 15 then
			var42 = var42 - 1
			var46 = var46 + 1
			var46 = 0
			var46 = var46 + 1
			junk += 4
		end
		if at <= 16 then
			var46 = 0
			var46 = var46 + 1
			junk += 1
		end
		if at <= 17 then
			var41 = vm.i32(var41 + 1)
			helper_72643bb6(54)
		end
		if at <= 18 then
			helper_72643bb6(30)
		end
		if at <= 19 then
			helper_059d36ae(0)
			junk += 1
		end
		if at <= 20 then
			helper_72643bb6(90)
		end
		if at <= 22 then
			var57 = helper_a4e66753(0, 2002, 8, 256, 208, 2, 0)
			junk += 1
		end
		if at <= 24 then
			var11 = vm.f32(var11 - vm.f32(3.1415927))
			var8 = vm.f32(var8 + vm.f32(vm.sin(var11) * 50.0))
			var10 = vm.f32(var10 + vm.f32(vm.cos(var11) * 50.0))
			var46 = 0
			var18 = vm.f32(var18 + 1.0)
			var20 = vm.f32(var20 + 1.0)
			var46 = var46 + 1
			var6 = vm.f32(var6 - vm.f32(3.1415927))
			var8 = vm.f32(vm.f32(vm.sin(var6) * 100.0) + var8)
			var9 = vm.f32(var9 + 30.0)
			var10 = vm.f32(vm.f32(vm.cos(var6) * 100.0) + var10)
			helper_059d36ae(0)
			junk += 5
		end
		if at <= 25 then
			helper_72643bb6(20)
		end
		if at <= 26 then
			helper_34190(-1)
			helper_34190(var1)
			helper_345fc(var21)
			junk += 1
		end
	end
	if vm.wait() then
		return skip(1)
	end
	event.Initialize()
	helper_16358()
	event.SetMotion(0, "立ち")
	local t0 = helper_32fbc()
	if vm.skipping() then
		junk += 1
		return skip(2)
	end
	if t0 ~= 0 then
		event.Finish()
		return
	end
	event.SetStatusbarShow(0, 0.1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFile(
		"dungeon/sphida/c01_golf.gltf",
		"dungeon/chara/c01b_miss.gltf",
		"dungeon/sphida/gool_end.gltf",
		"dungeon/sphida/mizu_eff.gltf"
	)
	if vm.wait() then
		return skip(3)
	end
	helper_40515d20()
	if vm.skipping() then
		return skip(4)
	end
	event.LoadMotion(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.LoadMotion(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	tex_bank = event.SphidaGetTexb() or tex_bank
	event.LoadChara(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.CharaActive(0, 12)
	var1 = event.SndLoadSound(5, "snd2/mon/en_900.sound.json") or var1
	event.CreateSwordEffect(5, 64, 16)
	event.SwordEffectColor(128, 128, 128, 80, 128, 128, 128, 80)
	event.EsmInitialize(5, 1)
	event.EsmLoadBasePack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
	event.EsmInitFix(5)
	event.EohSyncChara(0, 2)
	event.EohSetShow(0, 0)
	event.SetCrossfade(15)
	event.SphidaResetPowgage()
	do
		local out1, out2, out3 = event.SphidaGetBallPos()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	var2, var3, var4, var6 = helper_333d8(var2, var3, var4, var6)
	helper_33d44(var6)
	event.SphidaSetStatusFlag(1)
	var11 = 12.5
	event.SphidaCalcCarry(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
	var12, var13, var14 = helper_34f80(var12, var13, var14)
	event.SphidaSetPowgageSafeLevel(var14)
	do
		local out1, out2, out3 = event.ZeroVector()
		var15 = out1 or var15
		var16 = out2 or var16
		var17 = out3 or var17
	end
	while true do
		event.SphidaSetMinimapFlag(1)
		event.SphidaSetMmLineFlag(1)
		local t1: s32
		t1, var6, var11 = helper_304e0(var6, var11, tex_bank, sp + junk + 58)
		local t2 = t1
		if vm.skipping() then
			junk += 1
			return skip(5)
		end
		if t2 ~= 0 then
			event.SphidaSetMinimapFlag(0)
			event.SphidaSetMmLineFlag(0)
			event.SphidaSetBallPos(var8, var9, var10)
			event.SetCharaPos(8, var8, var9, var10)
			event.SetCharaPos(9, var8, var9, var10)
			helper_345fc(0)
			if vm.skipping() then
				return skip(6)
			end
			return
		end
		event.SphidaSetMinimapFlag(0)
		event.SphidaSetMmLineFlag(0)
		local t3: s32
		t3, var12, var6, var16, var15, var14 = helper_31334(var12, tex_bank, var6, var16, var15, var1, var14)
		local t4 = if t3 == 0 then 1 else 0
		if vm.skipping() then
			junk += 1
			return skip(7)
		end
		if t4 ~= 0 then
			break
		else
			if vm.wait() then
				return skip(8)
			end
		end
	end
	do
		local out1, out2, out3 = event.CopyVector(var2, var3, var4)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	var21 = 0
	if var14 ~= 1 and var14 ~= -1 and var14 ~= 4 then
		event.SpriteSetType(0, 1)
		event.SpriteSetDraw(0, 1)
		event.SpriteSetPutsize(0, 10.8, 11.6)
		event.SpriteSetPos(0, var2, var3 + 30.0, var4)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		if var14 == 0 then
			event.SpriteSetUvsize(0, 78, 198, 54, 58)
		end
		if var14 == 2 or var14 == -2 then
			event.SpriteSetUvsize(0, 186, 190, 70, 66)
		end
		if var14 == 3 or var14 == -3 then
			event.SpriteSetUvsize(0, 132, 198, 54, 58)
		end
		event.EohSyncSprite(18, 0)
		event.ObjsInit(18)
		event.ObjsSyncObj(18, 18)
		event.ObjsSetColor(18, 128, 128, 128, 128, 4)
		event.ObjsColorDelay(18, 20)
		event.ObjsSetColor(18, 128, 128, 128, 0, 6)
		helper_72643bb6(10)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var12 <= vm.f32(0.3) then
		event.SetMotion(0, "小ショット", 2)
		helper_72643bb6(25)
		if vm.skipping() then
			return skip(10)
		end
		if var14 ~= 4 then
			event.SndSePlay(var1, 3)
		end
	elseif var12 <= vm.f32(0.6) then
		event.SetMotion(0, "中ショット", 2)
		helper_72643bb6(34)
		if vm.skipping() then
			return skip(11)
		end
		event.SndSePlay(var1, 2)
	else
		event.SetMotion(0, "大ショット", 2)
		helper_72643bb6(39)
		if vm.skipping() then
			return skip(12)
		end
		if var14 == 0 then
			event.SndSePlay(var1, 12)
		else
			event.SndSePlay(var1, 1)
		end
	end
	if var14 == 4 then
		helper_72643bb6(50)
		if vm.skipping() then
			return skip(13)
		end
		helper_34190(var1)
		event.SphidaSetBallPos(var8, var9, var10)
		event.SetCharaPos(8, var8, var9, var10)
		event.SetCharaPos(9, var8, var9, var10)
		helper_345fc(0)
		if vm.skipping() then
			return skip(14)
		end
		return
	end
	if var14 == 0 then
		event.SpriteSetType(1, 0)
		event.SpriteSetDraw(1, 1)
		event.SpriteSetPos(1, 256, 278)
		event.SpriteSetUvsize(1, 246, 104, 266, 42)
		event.SpriteSetPutsize(1, 266, 42)
		event.SpriteSetColor(1, 128, 128, 128, 0)
		event.SpriteSetScale(1, 10, 10, 10)
		event.EohSyncSprite(19, 1)
		event.ObjsInit(19)
		event.ObjsSyncObj(19, 19)
		event.ObjsJump(19, 256, 138, 0, 3.6, 20)
		event.ObjsSetScale(19, 1, 1, 1, 18)
		event.ObjsSetColor(19, 128, 128, 128, 128, 12)
		event.ObjsColorDelay(19, 30)
		event.ObjsSetColor(19, 128, 128, 128, 0, 6)
	end
	var12 = helper_dff48a5c(var12)
	var11 = vm.f32(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
	var12 = vm.f32(var12 - vm.f32(var12 * var11))
	var22 = vm.f32(vm.sin(var6) * vm.f32(var12 * vm.cos(var11)))
	var23 = vm.f32(var12 * vm.sin(var11))
	var24 = vm.f32(vm.cos(var6) * vm.f32(var12 * vm.cos(var11)))
	var16 = vm.f32(vm.f32(var16 * vm.f32(3.1415927)) / 2.0)
	var17 = vm.f32(vm.f32(vm.f32(-var24 * var13) * var15) * vm.f32(0.4))
	var15 = vm.f32(vm.f32(vm.f32(-var22 * var13) * var15) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.SphidaGetPinPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var29 = 0
	var14 = 0
	var42 = 0
	do
		local out1, out2, out3, out4, out5 =
			event.ChkIntersectionPoint_13(0, var2, var3 + 5.0, var4, var2, var3, var4, 0)
		var30 = out1 or var30
		var31 = out2 or var31
		var32 = out3 or var32
		var41 = out4 or var41
		var43 = out5 or var43
	end
	if var41 >= 0 and (var43 == 1 or var43 == 7) then
		print("----------------START_MIZU-------------------\n")
		var12 = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		var12 = 0.0
	end
	var46 = 0
	while true do
		if var3 >= 180.0 then
			var22 = vm.f32(var22 * vm.f32(0.999))
			var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0098) * (var46 + 1)))
			var24 = vm.f32(var24 * vm.f32(0.999))
		else
			var41 = event.ChkIntersectionPoint_9(12, var2, var3, var4, var2, vm.f32(var3 - 3.0) - vm.f32(0.01), var4, 0)
				or var41
			if var14 == 1 and var41 >= 0 then
				var22 = vm.f32(var22 * vm.f32(0.94))
				var23 = vm.f32(var23 + vm.f32(vm.f32(-0.00045) * (var46 + 1)))
				var24 = vm.f32(var24 * vm.f32(0.94))
				var22 = vm.f32(var22 + var15)
				var24 = vm.f32(var24 + var17)
				var15 = vm.f32(var15 * vm.f32(0.8))
				var17 = vm.f32(var17 * vm.f32(0.8))
			else
				var22 = vm.f32(var22 * vm.f32(0.999))
				var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0045) * (var46 + 1)))
				var24 = vm.f32(var24 * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.AddVector(var2, var3, var4, var22, var23, var24)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		if var16 ~= 0.0 then
			var11 = event.GetRefAngle(var18, var19, var20, var2, var3, var4) or var11
			var11 = vm.f32(var11 + var16)
			var11 = event.AngleLimit(var11) or var11
			var22 = vm.f32(var22 + vm.f32(vm.f32(vm.sin(var11) / 10.0) * var13))
			var24 = vm.f32(var24 + vm.f32(vm.f32(vm.cos(var11) / 10.0) * var13))
		end
		var40 = event.DistVector(var15, 0.0, var17) or var40
		if var40 > vm.f32(0.01) then
			var25 = event.DistVector(var15, 0.0, var17) or var25
			var11 = event.GetRefAngle(var18, var19, var20, var18 + var15, var19, var20 + var17) or var11
			do
				local out1, out2, out3 = event.GetCharaRot(8)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			event.SetCharaRot(8, var5, var11, var7)
			event.AddCharaRot(8, var25 * 12.0, 0.0, 0.0)
			event.SetCharaRot(9, var5, var11, var7)
			event.AddCharaRot(9, var25 * 12.0, 0.0, 0.0)
		else
			var25 = event.DistVector(var22, 0.0, var24) or var25
			var11 = event.GetRefAngle(var18, var19, var20, var2, var3, var4) or var11
			do
				local out1, out2, out3 = event.GetCharaRot(8)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			event.SetCharaRot(8, var5, var11, var7)
			event.AddCharaRot(8, var25 / 10.0, 0.0, 0.0)
			event.SetCharaRot(9, var5, var11, var7)
			event.AddCharaRot(9, var25 / 10.0, 0.0, 0.0)
		end
		var25 = event.DistVector(var22, var23, var24) or var25
		var39 = var25
		var11 = event.GetRefAngle(var18, var19, var20, var2, var3, var4) or var11
		var36 = vm.f32(vm.sin(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
		var38 = vm.f32(vm.cos(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
		event.SwordEffectAddPoint(
			var2 - var36,
			var3,
			var4 - var38,
			vm.f32(var2 + var36) + var36,
			var3,
			vm.f32(var4 + var38) + var38
		)
		do
			local out1, out2, out3 = event.CopyVector(var22, var23, var24)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3 = event.NormalVector(var36, var37, var38)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3 = event.ScaleVector(var36, var37, var38, 3.0)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3, out4, out5 =
				event.ChkIntersectionPoint_13(0, var18, var19, var20, var2 + var36, var3 + var37, var4 + var38, 0)
			var30 = out1 or var30
			var31 = out2 or var31
			var32 = out3 or var32
			var41 = out4 or var41
			var43 = out5 or var43
		end
		if var41 >= 0 and (var43 == 1 or var43 == 7) then
			event.EsmCreate("足水パシャ")
			event.EsmSetVect1(var30, var31, var32)
			if var42 <= 0 then
				event.SndSePlay(var1, 11)
				var42 = 10
			end
			if var12 == 0.0 then
				var12 = 1.0
				var22 = vm.f32(var22 * vm.f32(0.4))
				var23 = vm.f32(var23 * vm.f32(0.4))
				var24 = vm.f32(var24 * vm.f32(0.4))
				var15 = 0.0
				var17 = 0.0
				event.DeleteSwordEffect()
				print("----------------SE OFF-------------------\n")
			else
				var12 = 0.0
				print("----------------SE ON-------------------\n")
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.ChkIntersectionPoint_15(12, var18, var19, var20, var2 + var36, var3 + var37, var4 + var38, 1)
			var30 = out1 or var30
			var31 = out2 or var31
			var32 = out3 or var32
			var33 = out4 or var33
			var34 = out5 or var34
			var35 = out6 or var35
			var41 = out7 or var41
		end
		if var41 < 0 then
			if var3 >= 380.0 and var23 > 0.0 then
				do
					local out1, out2, out3 = event.CopyVector(var2, var3, var4)
					var30 = out1 or var30
					var31 = out2 or var31
					var32 = out3 or var32
				end
				do
					local out1, out2, out3 = event.CopyVector(var22, -var23, var24)
					var33 = out1 or var33
					var34 = out2 or var34
					var35 = out3 or var35
				end
				do
					local out1, out2, out3 = event.NormalVector(var33, var34, var35)
					var33 = out1 or var33
					var34 = out2 or var34
					var35 = out3 or var35
				end
				var41 = 1
			end
		end
		while var41 >= 0 do
			var16 = 0.0
			if var25 > 8.0 then
				helper_79d90c82()
			end
			if var12 ~= 1.0 and var42 <= 0 then
				event.SndSePlay(var1, 6)
				var42 = 10
			end
			do
				local out1, out2, out3 = event.CopyVector(-var22, -var23, -var24)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.NormalVector(var22, var23, var24)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.ScaleVector(var22, var23, var24, 3.0)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.AddVector(var30, var31, var32, var22, var23, var24)
				var30 = out1 or var30
				var31 = out2 or var31
				var32 = out3 or var32
			end
			do
				local out1, out2, out3 = event.SubVector(var18, var19, var20, var30, var31, var32)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			var40 = event.DistVector(var18, var19, var20) or var40
			var40 = vm.f32(var39 - var40)
			if var40 <= 0.0 then
				break
			else
				var39 = var40
				do
					local out1, out2, out3 = event.CopyVector(-var22, -var23, -var24)
					var22 = out1 or var22
					var23 = out2 or var23
					var24 = out3 or var24
				end
				if var23 < 0.0 and var34 > 0.0 then
					var22 = vm.f32(var15 * 2.0)
					var23 = 0.0
					var24 = vm.f32(var17 * 2.0)
					var15 = vm.f32(var15 * vm.f32(0.2))
					var17 = vm.f32(var17 * vm.f32(0.2))
				else
					if
						var22 < 0.0 and var33 > 0.0
						or var22 > 0.0 and var33 < 0.0
						or var24 < 0.0 and var35 > 0.0
						or var24 > 0.0 and var35 < 0.0
					then
						var15 = 0.0
						var17 = 0.0
					end
					var22 = 0.0
					var23 = 0.0
					var24 = 0.0
				end
				if var12 == 0.0 then
					var22 = vm.f32(vm.f32(vm.f32(var33 * var25) * vm.f32(0.9)) + var22)
					var23 = vm.f32(vm.f32(vm.f32(var34 * var25) * vm.f32(0.58)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var25) * vm.f32(0.9)) + var24)
				else
					print("MIZU______1--------------------------------------------------------------------\n")
					var22 = vm.f32(vm.f32(vm.f32(var33 * var25) * vm.f32(0.8)) + var22)
					var23 = vm.f32(vm.f32(vm.f32(var34 * var25) * vm.f32(0.4)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var25) * vm.f32(0.8)) + var24)
				end
				do
					local out1, out2, out3 = event.CopyVector(var30, var31, var32)
					var18 = out1 or var18
					var19 = out2 or var19
					var20 = out3 or var20
				end
				do
					local out1, out2, out3 = event.CopyVector(var22, var23, var24)
					var36 = out1 or var36
					var37 = out2 or var37
					var38 = out3 or var38
				end
				do
					local out1, out2, out3 = event.NormalVector(var36, var37, var38)
					var36 = out1 or var36
					var37 = out2 or var37
					var38 = out3 or var38
				end
				do
					local out1, out2, out3 = event.ScaleVector(var36, var37, var38, 3.0)
					var36 = out1 or var36
					var37 = out2 or var37
					var38 = out3 or var38
				end
				do
					local out1, out2, out3 = event.ScaleVector(var33, var34, var35, var40)
					var33 = out1 or var33
					var34 = out2 or var34
					var35 = out3 or var35
				end
				do
					local out1, out2, out3 = event.CopyVector(var30, var31, var32)
					var2 = out1 or var2
					var3 = out2 or var3
					var4 = out3 or var4
				end
				do
					local out1, out2, out3 = event.AddVector(var2, var3, var4, var33, var34, var35)
					var2 = out1 or var2
					var3 = out2 or var3
					var4 = out3 or var4
				end
				do
					local out1, out2, out3, out4, out5, out6, out7, out8 = event.ChkIntersectionPoint_16(
						12,
						var18,
						var19,
						var20,
						var2 + var36,
						var3 + var37,
						var4 + var38,
						1
					)
					var30 = out1 or var30
					var31 = out2 or var31
					var32 = out3 or var32
					var33 = out4 or var33
					var34 = out5 or var34
					var35 = out6 or var35
					var41 = out7 or var41
					var43 = out8 or var43
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.ChkIntersectionPoint_16(12, var2, var3, var4, var2, var3 - 3.0, var4, 1)
			var30 = out1 or var30
			var31 = out2 or var31
			var32 = out3 or var32
			var33 = out4 or var33
			var34 = out5 or var34
			var35 = out6 or var35
			var41 = out7 or var41
			var43 = out8 or var43
		end
		if var41 >= 0 then
			var16 = 0.0
			var3 = vm.f32(var31 + 3.0)
			var40 = event.DistVector(var22, 0.0, var24) or var40
			if var40 < vm.f32(2.6) or var23 >= -1.0 and var23 <= 0.0 then
				var23 = 0.0
				var14 = 1
			else
				if var12 == 0.0 then
					var22 = vm.f32(var22 * vm.f32(0.9))
					var23 = -vm.f32(var23 * vm.f32(0.58))
					var24 = vm.f32(var24 * vm.f32(0.9))
					var22 = vm.f32(var22 + vm.f32(var15 * 2.0))
					var24 = vm.f32(var24 + vm.f32(var17 * 2.0))
					var15 = vm.f32(var15 * vm.f32(0.2))
					var17 = vm.f32(var17 * vm.f32(0.2))
				else
					print("MIZU______2--------------------------------------------------------------------\n")
					var22 = vm.f32(var22 * vm.f32(0.8))
					var23 = -vm.f32(var23 * vm.f32(0.4))
					var24 = vm.f32(var24 * vm.f32(0.8))
					var15 = 0.0
					var17 = 0.0
				end
				if var25 > 8.0 then
					helper_79d90c82()
				end
				if var12 ~= 1.0 and var42 <= 0 then
					event.SndSePlay(var1, 5)
					var42 = 10
				end
			end
			var40 = event.DistVector(var15, 0.0, var17) or var40
			if var23 == 0.0 and var25 < vm.f32(1.6) and var40 < vm.f32(0.4) then
				if var43 == 6 then
					var29 = 1
					break
				end
				var43 = event.AmgGetAttrStatus(var2, var3, var4) or var43
				if not (var43 == 1) then
					break
				end
				var29 = 1
				break
			end
		end
		if var3 < -500.0 then
			var29 = 1
			break
		elseif var46 >= 480 then
			var29 = 1
			break
		else
			var44 = event.SphidaGetPinCol() or var44
			var45 = event.SphidaGetBallCol() or var45
			x = vm.f32(pos_x - var2)
			y = vm.f32(pos_y - var3)
			z = vm.f32(pos_z - var4)
			var47 = event.DistVector(x, y, z) or var47
			if var45 ~= var44 then
				var51 = event.LinePointDist(var18, var19, var20, var2, var3, var4, pos_x, pos_y, pos_z) or var51
				if var51 >= 0.0 and var51 <= 30.0 then
					var21 = 1
					break
				end
				if var47 ~= 0.0 then
					if var47 <= 120.0 then
						do
							local out1, out2, out3 = event.ScaleVector(x, y, z, vm.fdiv(vm.f32(0.6), var47))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.AddVector(var2, var3, var4, x, y, z)
							var2 = out1 or var2
							var3 = out2 or var3
							var4 = out3 or var4
						end
						do
							local out1, out2, out3 = event.AddVector(var22, var23, var24, x, y, z)
							var22 = out1 or var22
							var23 = out2 or var23
							var24 = out3 or var24
						end
					end
				else
					var21 = 1
					break
				end
			elseif var47 ~= 0.0 then
				if var47 <= 60.0 then
					do
						local out1, out2, out3 = event.ScaleVector(x, y, z, vm.fdiv(1.0, var47))
						x = out1 or x
						y = out2 or y
						z = out3 or z
					end
					do
						local out1, out2, out3 = event.SubVector(var2, var3, var4, x, y, z)
						var2 = out1 or var2
						var3 = out2 or var3
						var4 = out3 or var4
					end
					do
						local out1, out2, out3 = event.SubVector(var22, var23, var24, x, y, z)
						var22 = out1 or var22
						var23 = out2 or var23
						var24 = out3 or var24
					end
				end
			end
			event.SetCharaPos(8, var2, var3, var4)
			event.SetCharaPos(9, var2, var3, var4)
			do
				local out1, out2, out3 = event.CopyVector(var2, var3, var4)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			if var3 <= -50.0 then
				event.SetFcameraFollowFlag(0)
				if var29 >= 30 then
					if var29 >= 50 then
						break
					end
				else
					event.SetCameraRef(var2, var3, var4)
				end
				var29 = var29 + 1
			elseif var46 >= 20 then
				event.CtrlcMoveRange(20.0, 30.0, 60.0, 200.0)
				event.SetCameraSpeed(8.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				event.SetFcameraFollow(
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24
				)
				do
					local out1, out2, out3 = event.GetCameraPos()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				yaw = event.GetRefAngle(
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24,
					pos_x_2,
					pos_y_2,
					pos_z_2
				) or yaw
				event.CtrlcSetRotate(yaw)
				event.CtrlcMoveCamera(8)
				event.CtrlcStep()
			end
			event.SphidaSetBallPos(var2, var3, var4)
			if vm.wait() then
				return skip(15)
			end
			if var42 > 0 then
				var42 = var42 - 1
			end
			var46 = var46 + 1
		end
	end
	event.SetCharaPos(8, var2, var3, var4)
	event.SetCharaPos(9, var2, var3, var4)
	event.SphidaSetStatusFlag(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var29 == 0 then
		event.SphidaSetBallPos(var2, var3, var4)
		count = event.SphidaGetParCount() or count
		if var21 == 1 then
			event.CharaActive(0, 0)
			event.CharaActive(0, 8)
			event.CharaActive(0, 9)
			event.CharaActive(1, 12)
			event.SetCharaPos(12, pos_x, pos_y, pos_z)
			event.SetMotion(12, "発動", 6)
			event.SndSePlay(var1, 17)
			var46 = 0
			while var46 < 2 do
				event.SetCameraCtrl(0)
				event.SetFcameraFollowFlag(1)
				event.SetFcameraFollowA(pos_x, pos_y, pos_z)
				event.SetCameraSpeed(12.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				event.SetFcameraHeight(0.0)
				event.SetFcameraDist(100.0)
				event.FcameraStep(1)
				var46 = var46 + 1
				if vm.wait() then
					return skip(16)
				end
			end
			event.CharaActive(0, 10)
			do
				local out1, out2, out3 = event.SphidaGetPinPos()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			var46 = 0
			while var46 < 100 do
				event.SetCameraCtrl(0)
				event.SetFcameraFollowFlag(1)
				event.SetFcameraFollowA(pos_x, pos_y, pos_z)
				event.SetCameraSpeed(12.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				event.SetFcameraHeight(0.0)
				event.SetFcameraDist(100.0)
				event.FcameraStep(1)
				var46 = var46 + 1
				if vm.wait() then
					return skip(17)
				end
			end
			event.CharaActive(0, 11)
			var44 = event.DngGetStageId() or var44
			var45 = event.DngGetFloorId() or var45
			var41 = event.GetFloorInfo(var44, var45, 4) or var41
			do
				local out1, out2 = event.SphidaGetPrize(var41)
				var42 = out1 or var42
				var43 = out2 or var43
			end
			var41 = vm.i32(var41 + 1)
			event.SetFloorInfo(var44, var45, 4, var41)
			event.PostTreasureBox(pos_x, pos_y - 30.0, pos_z, var11, var42, var43)
			helper_72643bb6(54)
			if vm.skipping() then
				return skip(18)
			end
			helper_72643bb6(30)
			if vm.skipping() then
				return skip(19)
			end
			event.DeleteChara(8)
			event.DeleteChara(9)
			event.DeleteChara(10)
			event.DeleteChara(11)
			event.SphidaSetPlayFlag(0)
			var1 = event.SndLoadSound(8, "snd2/sp/sp_000.sound.json") or var1
			event.StopBgm(0)
			event.SndSePlay(var1, 0)
			event.CharaActive(1, 0)
			event.SetFcameraFollowFlag(0)
			event.SetCameraCtrl(0)
			event.CmrsInit()
			event.CmrsSyncObj(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.ObjsSetMotion(0, "カップインポーズ", 6)
			event.ObjsNormalDrive(0)
			event.ObjsNextMotion(0, "カップインポーズL", 4)
			event.ObjsResetDaPosition(0)
			var42 = event.GetLanguage() or var42
			if var42 == 0 then
				event.SpriteInit(0)
				event.SpriteSetType(0, 0)
				event.SpriteSetTexture(0, "sphida_bar", tex_bank)
				event.SpriteSetUvsize(0, 258, 0, 254, 54)
				event.SpriteSetPos(0, 256, 208)
				event.SpriteSetPutsize(0, 254, 54)
				event.SpriteSetColor(0, 128, 128, 128, 0)
				event.SpriteSetScale(0, 5.0, 5.0)
				event.SpriteSetDraw(0, 1)
			else
				event.SpriteInit(0)
				event.SpriteSetType(0, 0)
				event.SpriteSetTexture(0, "sphida_bar", tex_bank)
				event.SpriteSetUvsize(0, 206, 0, 306, 54)
				event.SpriteSetPos(0, 256, 208)
				event.SpriteSetPutsize(0, 254, 54)
				event.SpriteSetColor(0, 128, 128, 128, 0)
				event.SpriteSetScale(0, 5.0, 5.0)
				event.SpriteSetDraw(0, 1)
			end
			event.EohSyncSprite(1, 0)
			event.ObjsInit(1)
			event.ObjsSyncObj(1, 1)
			event.ObjsSetScale(1, 1.0, 1.0, 0.0, 60)
			event.ObjsSetColor(1, 128, 128, 128, 128, 60)
			helper_059d36ae(0)
			if vm.skipping() then
				return skip(20)
			end
			helper_72643bb6(90)
			if vm.skipping() then
				return skip(21)
			end
			if vm.wait() then
				return skip(22)
			end
			event.PlayBgm(0)
			event.CmrsReleaseObj()
			event.SpriteSetDraw(0, 0)
		elseif count >= 2 then
			event.SetMesWindowMode(0, 5)
			event.SetMesQuestionGyou(0, 0)
			var57 = helper_a4e66753(0, 2002, 8, 256, 208, 2, 0)
			if vm.skipping() then
				return skip(23)
			end
			if vm.wait() then
				return skip(24)
			end
			if var57 == 0 then
				do
					local out1, out2, out3, out4 = event.GetPartsFuncPos(var2, var3, var4, 100.0, "point")
					var41 = out1 or var41
					var8 = out2 or var8
					var9 = out3 or var9
					var10 = out4 or var10
				end
				if var41 == 0 then
					do
						local out1, out2, out3 = event.GetPartsOrigin(var2, var3, var4, 100.0)
						var8 = out1 or var8
						var9 = out2 or var9
						var10 = out3 or var10
					end
				end
				do
					local out1, out2, out3 = event.SphidaGetPinPos()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				var25 = event.DistVector2(var8, var9, var10, pos_x, pos_y, pos_z) or var25
				if var25 < 40.0 then
					var11 = event.GetRand(6.2831855) or var11
					var11 = vm.f32(var11 - vm.f32(3.1415927))
					var8 = vm.f32(var8 + vm.f32(vm.sin(var11) * 50.0))
					var10 = vm.f32(var10 + vm.f32(vm.cos(var11) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.GetNearTboxPos(var8, var9, var10)
						var30 = out1 or var30
						var31 = out2 or var31
						var32 = out3 or var32
						var41 = out4 or var41
					end
					var46 = 0
					while var41 >= 0 do
						do
							local out1, out2, out3 = event.CopyVector(var8, var9, var10)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						do
							local out1, out2, out3 = event.SubVector(var18, var19, var20, var30, var31, var32)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						var18 = vm.f32(var18 + 1.0)
						var20 = vm.f32(var20 + 1.0)
						do
							local out1, out2, out3 = event.NormalVector(var18, var19, var20)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						do
							local out1, out2, out3 = event.ScaleVector(var18, var19, var20, 30.1)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						do
							local out1, out2, out3 = event.CopyVector(var30, var31, var32)
							var8 = out1 or var8
							var9 = out2 or var9
							var10 = out3 or var10
						end
						do
							local out1, out2, out3 = event.AddVector(var8, var9, var10, var18, var19, var20)
							var8 = out1 or var8
							var9 = out2 or var9
							var10 = out3 or var10
						end
						var46 = var46 + 1
						if var46 > 6 then
							break
						end
						do
							local out1, out2, out3, out4 = event.GetNearTboxPos(var8, var9, var10)
							var30 = out1 or var30
							var31 = out2 or var31
							var32 = out3 or var32
							var41 = out4 or var41
						end
					end
				end
				var6 = event.GetRefAngle(var8, var9, var10, var2, var3, var4) or var6
				event.SetCharaPos(0, var8, var9, var10)
				event.SetCharaRot(0, 0.0, var6, 0.0)
				event.SetCameraRef(var8, var9 + 30.0, var10)
				var6 = vm.f32(var6 - vm.f32(3.1415927))
				var6 = event.AngleLimit(var6) or var6
				var8 = vm.f32(vm.f32(vm.sin(var6) * 100.0) + var8)
				var9 = vm.f32(var9 + 30.0)
				var10 = vm.f32(vm.f32(vm.cos(var6) * 100.0) + var10)
				event.SetCameraPos(var8, var9, var10)
				event.ResetCamera(0)
			end
		end
	else
		event.SndSePlay(var1, 18)
		event.SetFcameraFollowFlag(0)
		event.SetCameraCtrl(0)
		event.CmrsInit()
		event.CmrsSyncObj(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
		event.ObjsSetMotion(0, "だめだめ", 6)
		event.ObjsNormalDrive(0)
		event.ObjsNextMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "sphida_bar", tex_bank)
		event.SpriteSetUvsize(0, 334, 54, 178, 34)
		event.SpriteSetPos(0, 256, -25)
		event.SpriteSetPutsize(0, 160, 50)
		event.SpriteSetColor(0, 128, 128, 128, 128)
		event.SpriteSetDraw(0, 1)
		event.EohSyncSprite(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 1.2, 16)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 2.0, 12)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 1.5, 8)
		helper_059d36ae(0)
		if vm.skipping() then
			return skip(25)
		end
		helper_72643bb6(20)
		if vm.skipping() then
			return skip(26)
		end
		event.SpriteSetDraw(0, 0)
		event.SphidaSetBallPos(var8, var9, var10)
		event.SetCharaPos(8, var8, var9, var10)
		event.SetCharaPos(9, var8, var9, var10)
		event.CmrsReleaseObj()
	end
	if var21 == 1 then
		helper_34190(-1)
	else
		helper_34190(var1)
	end
	helper_345fc(var21)
	if vm.skipping() then
		return skip(27)
	end
end

--- Program 3001.
script[3001] = function()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_34190(-1)
		end
	end
	event.Initialize()
	helper_16358()
	event.SetMesWindowMode(0, 5)
	event.SetMesQuestionGyou(0, 0)
	var0 = helper_a4e66753(0, 2004, 8, 0, 0, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.SphidaSetBallPos(var1, var2 + 3.0, var3)
		event.SetCharaPos(8, var1, var2 + 3.0, var3)
		event.SetCharaPos(9, var1, var2 + 3.0, var3)
		helper_34190(-1)
		event.SetCrossfade(15)
	end
	if vm.wait() then
		return skip(2)
	end
	event.Finish()
end

--- Program 3002.
script[3002] = function()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = helper_a4e66753(0, -1, 8, 0, 0, 2, 1)
		end
	end
	event.Initialize()
	helper_16358()
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "Questa [UNI00e8] l'ultima volta che potrai\navvicinare la Sphera.")
	helper_065641b0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 5)
	event.SetMesQuestionGyou(0, 0)
	event.MesMake_2(0, "Avvicinare la Sphera?")
	var0 = helper_a4e66753(0, -1, 8, 0, 0, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	if var0 == 0 then
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.SphidaSetBallPos(var1, var2 + 3.0, var3)
		event.SetCharaPos(8, var1, var2 + 3.0, var3)
		event.SetCharaPos(9, var1, var2 + 3.0, var3)
		event.SphidaSetLastChallenge(1)
		event.SetCrossfade(15)
	end
	if vm.wait() then
		return skip(3)
	end
	event.Finish()
end

--- Program 4000.
script[4000] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3eec4(0)
			if not vm.skipping() then
				return part2()
			end
		end
		helper_16f40(0, -1)
	end
	function part2()
		helper_16f40(0, -1)
	end
	event.Initialize()
	helper_16b7c()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d02f01", "d02f01", 1)
	helper_3eec4(0)
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 12551.
script[12551] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_49ce4()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d02b01")
	if vm.wait() then
		return skip(2)
	end
	event.LoadScript("d02b01/d02b01.stb", 12551)
end

--- Program 12552.
script[12552] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_49ce4()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d02b01")
	if vm.wait() then
		return skip(2)
	end
	event.LoadScript("d02b01/d02b01.stb", 12552)
end

--- Program 12560.
script[12560] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_49ce4()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d02b01")
	if vm.wait() then
		return skip(2)
	end
	event.LoadScript("d02b01/d02b01.stb", 12560)
end

--- Program 12570.
script[12570] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_49ce4()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d02b02")
	if vm.wait() then
		return skip(2)
	end
	event.LoadScript("d02b02/d02b02.stb", 12570)
end

--- Program 12600.
script[12600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_49ce4()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d02b02")
	if vm.wait() then
		return skip(2)
	end
	event.LoadScript("d02b02/d02b02.stb", 12600)
end

--- Program 22030.
script[22030] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCharaMaxhp(0, 64)
	event.SetCharaMaxhp(1, 64)
	event.SetCharaDefence(0, 16)
	event.SetCharaDefence(1, 16)
	event.AddItem(18)
	event.SetCharaEquip(0, 18)
	event.AddItem(25)
	event.SetCharaEquip(0, 25)
	event.AddItem(48)
	event.SetCharaEquip(1, 48)
	event.AddItem(92)
	event.SetCharaEquip(1, 92)
	event.LoadDungeonMapFile("d02b02")
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("d02b02/d02b02.stb", 200)
end

--- Program 26010.
script[26010] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCharaMaxhp(0, 160)
	event.SetCharaMaxhp(1, 160)
	event.SetCharaDefence(0, 50)
	event.SetCharaDefence(1, 50)
	argc = event.GetItemNum(270) or argc
	if argc < 20 then
		event.AddItem(270, vm.i32(20 - argc))
	end
	event.AddItem(16)
	event.SetCharaEquip(0, 16)
	event.AddItem(27)
	event.SetCharaEquip(0, 27)
	event.AddItem(71)
	event.SetCharaEquip(1, 71)
	event.AddItem(100)
	event.SetCharaEquip(1, 100)
	event.LoadDungeonMapFile("s13")
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s13/s13.stb", 26010)
end

return script
