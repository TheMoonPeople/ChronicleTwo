--!strict
-- map/s/s26/s26_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")
local helper_261c70db = require("@lib/event/helper_261c70db")
local helper_2e56adcc = require("@lib/event/helper_2e56adcc")
local helper_366d50dc = require("@lib/event/helper_366d50dc")
local helper_3ea45d11 = require("@lib/event/helper_3ea45d11")
local helper_42ed5322 = require("@lib/event/helper_42ed5322")
local helper_4896c0c7 = require("@lib/event/helper_4896c0c7")
local helper_5cfcf598 = require("@lib/event/helper_5cfcf598")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")
local helper_b055e396 = require("@lib/event/helper_b055e396")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_11368()
	local active_chr_no: s32 = 0
	local block_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
		print("00000000000000000000000000000000000000000000\n")
		print("1111111111111111111111111111111111111111111111\n")
	end
	if vm.skipping() then
		return skip(1)
	end
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e254/e254_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 38)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e254/e254_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 38)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 38)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e254/e254_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 38)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e254/e254_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e200/e254/e254_conda.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(3, 36)
	event.ObjsSyncObj(3, 4)
	event.LoadChara(5, "effect/giostone.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(5, 35)
	event.ObjsInit(4, 35)
	event.ObjsSyncObj(4, 5)
	print("00000000000000000000000000000000000000000000\n")
	event.LoadImg_4(5, "textures/menu/eventdl.json", 0)
	block_2 = event.LoadImg_4(5, "textures/event/e200/e254/e254_1.json", 1) or block_2
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e25401", block_2)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 416)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(20, 0)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e25402", block_2)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 416)
	event.SpriteSetPutsize(1, 512, 416)
	event.SpriteSetPos(1, 256, 208)
	event.SpriteSetDraw(1, 0)
	event.EohSyncSprite(21, 1)
	event.ObjsInit(21)
	event.ObjsSyncObj(21, 21)
	print("1111111111111111111111111111111111111111111111\n")
end

--- Helper function.
local function helper_10ee0()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(38)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(38)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.DeleteChara(36)
	event.DeleteChara(35)
	event.DelImg(0)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.DelImg(1)
end

--- Helper function.
local function helper_128d0()
	local var0: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				helper_adea7ba0(4)
			end
			if at <= 2 then
				helper_11368()
				helper_adea7ba0(30)
			end
			if at <= 3 then
				helper_5cfcf598(0, -1, 36, global1, var4)
			end
			if at <= 4 then
				helper_adea7ba0(23)
			end
			if at <= 5 then
				print(
					"x=",
					string.format("%f", pos_x),
					"y=",
					string.format("%f", pos_y),
					"z=",
					string.format("%f", pos_z),
					"\n"
				)
				helper_adea7ba0(30)
			end
			if at <= 6 then
				helper_adea7ba0(15)
			end
			if at <= 7 then
				var0 = 0
			end
			if at <= 8 then
				var0 = 0
			end
			if at <= 9 then
				var9 = helper_2e56adcc(64)
				helper_5cfcf598(0, -1, 36, global1, var4)
			end
			if at <= 10 then
				helper_5cfcf598(0, -1, 36, global1, var4)
			end
			if at <= 11 then
				helper_adea7ba0(15)
			end
			if at <= 12 then
				helper_5cfcf598(0, -1, 36, global1, var4)
			end
			if at <= 13 then
				helper_adea7ba0(15)
			end
			if at <= 14 then
				helper_5cfcf598(0, -1, 36, global1, var4)
			end
			if at <= 15 then
				helper_5cfcf598(0, -1, 36, global1, var4)
			end
			if at <= 16 then
				helper_5cfcf598(0, -1, 36, global1, var4)
			end
			if at <= 17 then
				helper_adea7ba0(15)
			end
			if at <= 18 then
				helper_5cfcf598(0, -1, 36, global1, var4)
			end
			if at <= 19 then
				helper_5cfcf598(0, -1, 36, global1, var4)
			end
			if at <= 20 then
				helper_5cfcf598(0, -1, 36, global1, var4)
			end
			if at <= 21 then
				helper_5cfcf598(0, -1, 36, global1, var4)
			end
			if at <= 22 then
				helper_adea7ba0(30)
			end
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
		helper_10ee0()
	end
	function part2()
		event.CancelDramaScene()
		event.SetMapDraw(1)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.SetMenuEtc(4)
		event.SetMenuEtc(7)
		helper_10ee0()
		event.Finish()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesPreset(0, 0)
	event.CmrsInit()
	event.CmrsSetPos(88.14, 44.81, 0.0)
	event.CmrsSetRef(0.0, 19.45, 0.0)
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadSound(2239)
	var5 = event.SndLoadSound(2239) or var5
	event.StopBgm(0)
	helper_adea7ba0(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(57)
	helper_11368()
	event.InitDramaScene()
	event.PlayBgm(0)
	event.CmrsInit()
	event.CmrsSetPos(88.14, 44.81, 0.0)
	event.CmrsSetRef(0.0, 19.45, 0.0)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 38)
	event.CharaActive(1, 36)
	event.CharaActive(1, 35)
	event.ObjsSetPos(0, -20.0, 0.0, 20.0)
	event.ObjsSetRot(0, 0.0, 2.3561945, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetPos(1, 20.0, 0.0, 20.0)
	event.ObjsSetRot(1, 0.0, -2.3561945, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetPos(3, -20.0, 0.0, -20.0)
	event.ObjsSetRot(3, 0.0, 0.7853982, 0.0)
	event.ObjsSetMotion(3, "ジオストーン持ち", 4)
	event.SetReference(36, "gio", 35)
	event.SetFadeIn(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"This is a Geostone. It's filled\nwith the wisdom of the ancients.<page>When you put these in the reactor,\nyou can build more types of things\nwith the Carpenterion."
	)
	helper_5cfcf598(0, -1, 36, global1, var4)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(3, "炉にくべる", 2)
	helper_adea7ba0(23)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var5, 9)
	do
		local out1, out2, out3 = event.EohGetFramePos(4, "gio")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.DelReference(35)
	print("x=", string.format("%f", pos_x), "y=", string.format("%f", pos_y), "z=", string.format("%f", pos_z), "\n")
	event.ObjsSetPos(4, pos_x, pos_y, pos_z)
	event.ObjsJump(4, 0.0, 0.0, 0.0, -0.25, 30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var5, 10)
	event.CharaActive(0, 35)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMenuEtc(5, 5, 74)
	var0 = 0
	while var0 == 0 do
		if vm.wait() then
			return skip(8)
		end
		var0 = event.GetMenuEtc_2(8) or var0
	end
	event.SetMenuEtc(4)
	event.SetMenuEtc(3, 1)
	var0 = 0
	while var0 == 0 do
		if vm.wait() then
			return skip(9)
		end
		var9 = helper_2e56adcc(64)
		var0 = event.ExtTyped(564, "iiI", 7, var9) or var0
	end
	event.SetMenuEtc(3, 0)
	event.SetMenuEtc(7)
	event.ObjsSetMotion(3, "会話2")
	event.MesMake_2(0, "Oh, yeah!\nI almost forgot.")
	helper_5cfcf598(0, -1, 36, global1, var4)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"Geostones not only have info on how\nto build things, but data on\nhow to develop a better future."
	)
	helper_5cfcf598(0, -1, 36, global1, var4)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMapDraw(0)
	event.SpriteSetDraw(0, 2)
	event.ObjsSetColor(20, 128.0, 128.0, 128.0, 128.0)
	event.SetCrossfade(15)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(12)
	end
	event.MesMake_2(
		0,
		"As you build the new world, you can\nsee how it's going with the Analyse\ncommand on the Georama Menu."
	)
	helper_5cfcf598(0, -1, 36, global1, var4)
	if vm.skipping() then
		return skip(13)
	end
	event.SpriteSetDraw(1, 2)
	event.ObjsSetColor(21, 128.0, 128.0, 128.0, 128.0)
	event.SetCrossfade(15)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(14)
	end
	event.SpriteSetDraw(0, 0)
	event.MesMake_2(
		0,
		"Now, in the upper right of your Georama\nmenu, you'll see this thing that\n says Polyn Remaining."
	)
	helper_5cfcf598(0, -1, 36, global1, var4)
	if vm.skipping() then
		return skip(15)
	end
	event.MesMake_2(0, "For things to exist there requires\na certain type of energy.<page>We call that energy Polyn.")
	helper_5cfcf598(0, -1, 36, global1, var4)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"There's a limit to the amount of Polyn\nyou can have on the Georama field,\nand the Carpenterion can't\nlet you go over that limit.<page>You remember that, now."
	)
	helper_5cfcf598(0, -1, 36, global1, var4)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMapDraw(1)
	event.SpriteSetDraw(1, 0)
	event.SetCrossfade(15)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(18)
	end
	event.MesMake_2(
		0,
		"If you ever want to know anything\nelse, you can just ask me with your\nHelp Receiver. I'll fill you in."
	)
	helper_5cfcf598(0, -1, 36, global1, var4)
	if vm.skipping() then
		return skip(19)
	end
	event.MesMake_2(
		0,
		"Now then, I think I'll leave the rest up\n to you young folks and get myself onto\nthat train thingamajiggy."
	)
	helper_5cfcf598(0, -1, 36, global1, var4)
	if vm.skipping() then
		return skip(20)
	end
	event.MesMake_2(
		0,
		"I'll be in the last car, so be sure\nto show yer face once in a while. Okey-dokey?<page>If you ever need Georama materials,\nI should be able to help."
	)
	helper_5cfcf598(0, -1, 36, global1, var4)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsSetPos(15.0, 17.57, 15.0)
	event.CmrsSetRef(-20.0, 15.0, -20.0)
	event.CmrsMove(4.35, 17.57, 4.35, -20.0, 15.0, -20.0, 300)
	event.ObjsSetMotion(3, "会話2")
	event.MesMake_2(0, "OK, then. Let's get started!\nAre you all set?")
	helper_5cfcf598(0, -1, 36, global1, var4)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsSetMotion(3, "立ち")
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

--- Helper function.
local function helper_d350()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e250/e250_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e250/e250_conda.gltf", "info", 39)
	event.EohSyncChara(5, 39)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.CharaActive(0, 39)
	block = event.LoadImg_4(5, "textures/event/e200/e250/e250_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e25001", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(9, 0)
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSetFrameShow(5, "tue", 0)
	event.LoadMes(0, 5, "event/e200/e250/e250_1.txt")
end

--- Helper function.
local function helper_d000()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
	event.SpriteSetDraw(0, 0)
	event.DeleteChara(39)
	event.DelImg(0)
end

--- Helper function.
local function helper_e398()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 28 then
			if at <= 1 then
				helper_adea7ba0(90)
			end
			if at <= 2 then
				helper_4896c0c7(2500300)
			end
			if at <= 3 then
				helper_4896c0c7(2500310)
			end
			if at <= 4 then
				helper_4896c0c7(2500320)
			end
			if at <= 5 then
				helper_4896c0c7(2500330)
			end
			if at <= 6 then
				helper_4896c0c7(2500340)
			end
			if at <= 7 then
				helper_4896c0c7(2500350)
			end
			if at <= 8 then
				helper_4896c0c7(2500360)
			end
			if at <= 9 then
				helper_4896c0c7(2500370)
			end
			if at <= 10 then
				helper_4896c0c7(2500380)
			end
			if at <= 11 then
				helper_261c70db()
			end
			if at <= 12 then
				helper_4896c0c7(2500390)
			end
			if at <= 13 then
				helper_4896c0c7(2500400)
			end
			if at <= 14 then
				helper_4896c0c7(2500410)
			end
			if at <= 15 then
				helper_3ea45d11(2500420, 260)
			end
			if at <= 16 then
				helper_3ea45d11(2500425, 90)
			end
			if at <= 17 then
				helper_3ea45d11(2500430, 300)
			end
			if at <= 18 then
				helper_b055e396(0, -1, 8, 0, 0)
			end
			if at <= 19 then
				helper_adea7ba0(4)
			end
			if at <= 20 then
				helper_3ea45d11(2500440, 210)
			end
			if at <= 21 then
				helper_3ea45d11(2500450, 252)
			end
			if at <= 22 then
				helper_4896c0c7(2500460)
			end
			if at <= 23 then
				helper_23bda4ba(1)
			end
			if at <= 24 then
				helper_4896c0c7(2500470)
			end
			if at <= 25 then
				helper_4896c0c7(2500480)
			end
			if at <= 26 then
				helper_4896c0c7(2500490)
			end
			if at <= 27 then
				helper_adea7ba0(30)
			end
			if vm.skip_end() then
				return skip(29)
			end
			return part2()
		end
		helper_d000()
	end
	function part2()
		event.CancelDramaScene()
		event.FuncPointShow("", "fire-0", 1)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_d000()
		event.StopEnvBgm()
		event.SetFadeOut(0)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(2231)
	helper_d350()
	event.StopBgm(0)
	helper_adea7ba0(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(192)
	event.PlayEnvBgm(220)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.EohSetFootSoundId(0, 3)
	event.EohSetFootSoundId(1, 3)
	event.SetFlag(43, 1)
	event.FuncPointShow("", "fire-0", 0)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 39)
	event.CmrsSetPos(61.11, 28.64, 11.99)
	event.CmrsSetRef(34.15, 26.92, 87.57)
	event.CmrsMove2(61.11, 28.64, 11.99, -6.39, 26.92, -14.44, 90, 2, 0.2)
	event.ObjsSetPos(0, -24.93, 0.0, -74.55)
	event.ObjsSetRot(0, 0.0, -0.77, 0.0)
	event.ObjsSetPos(1, -6.49, 0.0, -68.74)
	event.ObjsSetRot(1, 0.0, -0.24, 0.0)
	event.ObjsSetPos(5, -36.31, 0.0, -7.52)
	event.ObjsSetRot(5, 0.0, 2.52, 0.0)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMove(0, -28.68, 0.0, -40.21, 90)
	event.ObjsRotation(0, 0.0, 0.19, 0.0, 30)
	event.ObjsMove(1, -28.95, 0.0, -26.6, 90)
	event.ObjsRotation(1, 0.0, 0.12, 0.0, 30)
	helper_adea7ba0(90)
	if vm.skipping() then
		return skip(2)
	end
	event.PlayBgm(0)
	event.ObjsTexAnime(0, 1, "うれし半口")
	event.ObjsSetMotion(0, "立ち", 0)
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "かなりキョロキョロ", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 0)
	event.ObjsSetMotion(5, "会話2", 6, -1.0, 1)
	event.ObjsNextMotion(5, "立ち", 4)
	helper_4896c0c7(2500300)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-8.78, 24.17, 51.3)
	event.CmrsSetRef(-16.28, 24.17, 38.68)
	event.CmrsMove2(-8.78, 24.17, 51.3, 4.48, 24.17, 43.59, 210, 2, 0.4)
	helper_4896c0c7(2500310)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsInit()
	event.CmrsSetPos(61.11, 28.64, 11.99)
	event.CmrsSetRef(-6.39, 26.92, -14.44)
	helper_4896c0c7(2500320)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(7.29, 21.91, 58.86)
	event.CmrsSetRef(-28.35, 17.54, 8.66)
	event.ObjsSetPos(0, -25.04, 0.0, -22.19)
	event.ObjsSetRot(0, 0.0, 1.39, 0.0)
	event.ObjsSetPos(1, -42.75, 0.0, -17.11)
	event.ObjsSetRot(1, 0.0, 0.36, 0.0)
	event.ObjsSetPos(5, -35.97, 0.0, 6.92)
	event.ObjsSetRot(5, 0.0, 2.88, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(0, "→下見立ち", 6, -1.0, 1)
	event.Ext(466, 0, "下見立ち", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
	event.SetPakuAnim(1, "わらい口パク")
	helper_4896c0c7(2500330)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(5, "会話", 6, -1.0, 1)
	event.ObjsNextMotion(5, "立ち", 0)
	helper_4896c0c7(2500340)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_4896c0c7(2500350)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "これは？", 6, -1.0, 1)
	event.ObjsNextMotion(0, "これは？L", 4)
	event.CmrsPrdelay(10)
	event.CmrsMove2(7.29, 21.91, 58.86, -13.44, 17.54, 2.84, 30, 2, 0.4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(2500360)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(5, "会話2", 6, -1.0, 1)
	event.ObjsNextMotion(5, "立ち", 0)
	helper_4896c0c7(2500370)
	if vm.skipping() then
		return skip(10)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(2500380)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	helper_261c70db()
	if vm.skipping() then
		return skip(12)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(9, 128.0, 128.0, 128.0, 128.0, 10)
	helper_4896c0c7(2500390)
	if vm.skipping() then
		return skip(13)
	end
	helper_4896c0c7(2500400)
	if vm.skipping() then
		return skip(14)
	end
	helper_4896c0c7(2500410)
	if vm.skipping() then
		return skip(15)
	end
	event.SpriteSetDraw(0, 0)
	event.CmrsSetPos(52.08, 130.61, 41.85)
	event.CmrsSetRef(2.22, 22.34, 3.5)
	event.ObjsSetPos(0, -23.71, -1.07, -19.28)
	event.ObjsSetRot(0, 0.0, 0.91, 0.0)
	event.ObjsSetPos(1, -28.62, 0.82, 11.54)
	event.ObjsSetRot(1, 0.0, 1.68, 0.0)
	event.ObjsSetPos(5, -2.8, -0.0, 32.42)
	event.ObjsSetRot(5, 0.0, 3.0, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.CmrsMove2(45.54, 116.59, 36.82, -4.32, 8.32, -1.53, 330, 2, 0.4)
	helper_3ea45d11(2500420, 260)
	if vm.skipping() then
		return skip(16)
	end
	helper_3ea45d11(2500425, 90)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsInit()
	event.CmrsSetPos(12.93, 17.36, -15.66)
	event.CmrsSetRef(8.82, 17.73, -6.03)
	event.CmrsMove2(12.93, 17.36, -15.66, 2.22, 17.73, -16.01, 270, 2, 0.4)
	event.ObjsSetRot(1, 0.0, 1.32, 0.0)
	helper_3ea45d11(2500430, 300)
	if vm.skipping() then
		return skip(18)
	end
	event.FadeOutBgm(30)
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(0, "Georama explanation added to Help Menu.")
	helper_b055e396(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(19)
	end
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_adea7ba0(4)
	if vm.skipping() then
		return skip(20)
	end
	event.LoadBgm(22)
	event.PlayBgm(0)
	event.SetFlag(43, 0)
	event.CmrsInit()
	event.CmrsSetPos(4.11, 22.66, -17.12)
	event.CmrsSetRef(0.71, 19.07, 8.38)
	event.CmrsMove2(2.27, 22.66, -3.34, -1.12, 19.07, 22.16, 180, 2, 0.4)
	helper_3ea45d11(2500440, 210)
	if vm.skipping() then
		return skip(21)
	end
	helper_3ea45d11(2500450, 252)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(-45.1, 19.94, -58.7)
	event.CmrsSetRef(-8.21, 23.23, 19.97)
	event.ObjsSetPos(0, -34.66, 0.0, 3.86)
	event.ObjsSetRot(0, 0.0, 1.15, 0.0)
	event.ObjsSetPos(1, -22.93, -0.0, 24.09)
	event.ObjsSetRot(1, 0.0, 1.8, 0.0)
	event.ObjsSetPos(5, 21.52, -0.0, 23.04)
	event.ObjsSetRot(5, 0.0, -1.96, 0.0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(1, "会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_4896c0c7(2500460)
	if vm.skipping() then
		return skip(23)
	end
	event.ResetPakuAnim()
	helper_23bda4ba(1)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "立ち", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(2500470)
	if vm.skipping() then
		return skip(25)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4896c0c7(2500480)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(5, "会話", 6)
	event.ObjsNextMotion(5, "立ち", 0)
	helper_4896c0c7(2500490)
	if vm.skipping() then
		return skip(27)
	end
	event.SetFadeOut(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(28)
	end
	return part2()
end

--- Helper function.
local function helper_1868c()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.DeleteChara(39)
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(36)
	event.DeleteChara(38)
	event.DeleteChara(40)
	event.DeleteChara(41)
end

--- Helper function.
local function helper_19148()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_4896c0c7(6160120)
			end
			if vm.skip_end() then
				return skip(3)
			end
			return part2()
		end
		if at <= 3 then
			helper_adea7ba0(30)
		end
		helper_1868c()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_adea7ba0(30)
		if vm.skipping() then
			return skip(4)
		end
		event.BgmLoadCancel()
		event.SndSeAllStop(4)
		helper_1868c()
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = event.SndLoadSound(7201) or var0
	helper_42ed5322()
	event.CharaActive(0, 0)
	event.InitDramaScene()
	event.CharaActive(0, 39)
	event.CharaActive(1, 34)
	event.CharaActive(1, 35)
	event.CharaActive(1, 36)
	event.CharaActive(1, 38)
	event.CharaActive(1, 40)
	event.CharaActive(1, 41)
	event.CmrsSetPos(-92.53, 119.19, 118.35)
	event.CmrsSetRef(11.54, 11.66, -7.56)
	event.ObjsSetPos(5, 0.0, -1.79, -22.77)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetPos(6, -74.9, 0.0, 55.92)
	event.ObjsSetRot(6, 0.0, -0.84, 0.0)
	event.ObjsSetMotion(6, "座り", 4)
	event.ObjsSetPos(8, -30.74, -0.0, 94.88)
	event.ObjsSetRot(8, 0.0, -0.36, 0.0)
	event.ObjsSetMotion(8, "座り", 4)
	event.ObjsSetPos(4, 75.6, 0.0, 56.38)
	event.ObjsSetRot(4, 0.0, 0.88, 0.0)
	event.ObjsSetMotion(4, "座り", 4)
	event.ObjsSetPos(7, 29.93, 0.0, 90.74)
	event.ObjsSetRot(7, 0.0, 0.36, 0.0)
	event.ObjsSetMotion(7, "座り", 4)
	event.ObjsSetPos(2, -95.26, 0.0, 0.75)
	event.ObjsSetRot(2, 0.0, -1.56, 0.0)
	event.ObjsSetMotion(2, "座り", 4)
	event.ObjsSetPos(3, 96.35, 0.0, 0.25)
	event.ObjsSetRot(3, 0.0, 1.44, 0.0)
	event.ObjsSetMotion(3, "座り", 4)
	event.SetFadeIn(30)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(0.71, 26.98, -38.91, 67.53, 23.31, -5.86)
	event.CmrsAddPas(0.71, 26.98, -38.91, 45.47, 23.31, 20.84)
	event.CmrsAddPas(0.71, 26.98, -38.91, 16.34, 23.31, 34.32)
	event.CmrsAddPas(0.71, 26.98, -38.91, -16.58, 23.31, 34.18)
	event.CmrsAddPas(0.71, 26.98, -38.91, -45.53, 23.31, 20.41)
	event.CmrsAddPas(0.71, 26.98, -38.91, -68.63, 23.31, -9.13)
	event.CmrsStartPas()
	helper_261c70db()
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(5, "援護するのじゃ", 6)
	event.ObjsMotionDelay(5, 60)
	event.ObjsSetMotion(5, "撃て！！", 2)
	event.ObjsNextMotion(5, "撃て！！Ｌ", 4)
	event.ObjsSeDelay(5, 60)
	event.ObjsSePlay(5, var0, 11)
	event.CharaActive(1, 39)
	event.CmrsSetPos(61.6, 45.22, 21.01)
	event.CmrsSetRef(18.5, 27.58, -10.21)
	helper_4896c0c7(6160120)
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Helper function.
local function helper_14ae4()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e280/e280_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e280/e280_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e280/e280_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e280/e280_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e280/e280_conda.gltf", "info", 39)
	event.EohSyncChara(5, 39)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.CharaActive(0, 39)
	event.LoadChara(5, "event/e200/e280/e280_noam.gltf", "info", 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 34)
	event.LoadChara(5, "event/e200/e280/e280_zak.gltf", "info", 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(0, 35)
	event.LoadChara(5, "event/e200/e280/e280_wicky.gltf", "info", 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CharaActive(0, 36)
	event.LoadChara(5, "event/e200/e280/e280_mogri.gltf", "info", 38)
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.CharaActive(0, 38)
	event.LoadChara(5, "event/e200/e280/e280_tobo.gltf", "info", 40)
	event.EohSyncChara(7, 40)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.CharaActive(0, 40)
	event.LoadChara(5, "event/e200/e280/e280_rococo.gltf", "info", 41)
	event.EohSyncChara(8, 41)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.CharaActive(0, 41)
	event.LoadMes(0, 5, "event/e200/e280/e280b_1.txt")
end

--- Helper function.
local function helper_146b8()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
	event.DeleteChara(39)
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(36)
	event.DeleteChara(38)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.MapJump(-1, "s02", 503)
end

--- Helper function.
local function helper_15f34()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 47 then
			if at <= 1 then
				helper_14ae4()
				helper_adea7ba0(15)
			end
			if at <= 2 then
				helper_adea7ba0(90)
			end
			if at <= 3 then
				helper_adea7ba0(60)
			end
			if at <= 4 then
				helper_adea7ba0(15)
			end
			if at <= 5 then
				helper_adea7ba0(60)
			end
			if at <= 6 then
				helper_4896c0c7(2800220)
			end
			if at <= 7 then
				helper_366d50dc(2800225, -1, 16)
			end
			if at <= 8 then
				helper_366d50dc(2800230, -1, 16)
			end
			if at <= 9 then
				helper_366d50dc(2800240, -1, 20)
			end
			if at <= 10 then
				helper_366d50dc(2800250, -1, 16)
			end
			if at <= 11 then
				helper_366d50dc(2800260, -1, 16)
			end
			if at <= 12 then
				helper_366d50dc(2800270, -1, 16)
			end
			if at <= 13 then
				helper_366d50dc(2800275, -1, 16)
			end
			if at <= 14 then
				helper_261c70db()
			end
			if at <= 15 then
				helper_adea7ba0(30)
			end
			if at <= 16 then
				helper_adea7ba0(60)
			end
			if at <= 17 then
				helper_adea7ba0(15)
			end
			if at <= 18 then
				helper_4896c0c7(2800280)
			end
			if at <= 19 then
				helper_adea7ba0(30)
			end
			if at <= 20 then
				helper_adea7ba0(15)
			end
			if at <= 21 then
				helper_4896c0c7(2800290)
			end
			if at <= 22 then
				helper_4896c0c7(2800295)
			end
			if at <= 23 then
				helper_adea7ba0(30)
			end
			if at <= 24 then
				helper_adea7ba0(15)
			end
			if at <= 25 then
				helper_4896c0c7(2800300)
			end
			if at <= 26 then
				helper_adea7ba0(30)
			end
			if at <= 27 then
				helper_adea7ba0(15)
			end
			if at <= 28 then
				helper_4896c0c7(2800310)
			end
			if at <= 29 then
				helper_adea7ba0(30)
			end
			if at <= 30 then
				helper_adea7ba0(15)
			end
			if at <= 31 then
				helper_4896c0c7(2800320)
			end
			if at <= 32 then
				helper_4896c0c7(2800330)
			end
			if at <= 33 then
				helper_adea7ba0(60)
			end
			if at <= 34 then
				helper_3ea45d11(2800340, 60)
			end
			if at <= 35 then
				helper_adea7ba0(30)
			end
			if at <= 36 then
				helper_4896c0c7(2800350)
			end
			if at <= 37 then
				helper_adea7ba0(30)
			end
			if at <= 38 then
				helper_adea7ba0(15)
			end
			if at <= 39 then
				helper_4896c0c7(2800360)
			end
			if at <= 40 then
				helper_adea7ba0(30)
			end
			if at <= 41 then
				helper_adea7ba0(15)
			end
			if at <= 42 then
				helper_4896c0c7(2800370)
			end
			if at <= 43 then
				helper_23bda4ba(1)
			end
			if at <= 44 then
				helper_3ea45d11(2800380, 120)
			end
			if at <= 45 then
				helper_3ea45d11(2800390, 270)
			end
			if at <= 46 then
				helper_4896c0c7(2800400)
			end
			if vm.skip_end() then
				return skip(48)
			end
			return part2()
		end
		helper_146b8()
	end
	function part2()
		event.CancelDramaScene()
		event.BgmLoadCancel()
		helper_146b8()
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_adea7ba0(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(112)
	event.LoadSound(2514)
	var0 = event.SndLoadSound(2514) or var0
	event.PlayBgm(0)
	helper_14ae4()
	event.InitDramaScene()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 39)
	event.CharaActive(1, 34)
	event.CharaActive(1, 35)
	event.CharaActive(1, 36)
	event.CharaActive(1, 38)
	event.CharaActive(1, 40)
	event.CharaActive(1, 41)
	event.CmrsSetPos(-92.53, 119.19, 118.35)
	event.CmrsSetRef(11.54, 11.66, -7.56)
	event.ObjsSetPos(0, -6.46, 0.0, 61.2)
	event.ObjsSetRot(0, 0.0, 3.12, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetPos(1, 7.05, 0.0, 67.92)
	event.ObjsSetRot(1, 0.0, -2.92, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsSetPos(5, 0.0, 0.0, -28.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "手紙を閉じるL", 4)
	event.ObjsSetPos(6, 23.39, 0.0, -13.65)
	event.ObjsSetRot(6, 0.0, -1.08, 0.0)
	event.ObjsSetMotion(6, "立ち", 4)
	event.ObjsSetPos(8, 25.95, 0.0, 9.52)
	event.ObjsSetRot(8, 0.0, -1.92, 0.0)
	event.ObjsSetMotion(8, "立ち", 4)
	event.ObjsSetPos(4, 7.8, 0.0, 25.45)
	event.ObjsSetRot(4, 0.0, -2.88, 0.0)
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsSetPos(7, -14.77, 0.0, 24.05)
	event.ObjsSetRot(7, 0.0, 2.68, 0.0)
	event.ObjsSetMotion(7, "立ち", 4)
	event.ObjsSetPos(2, -25.0, 0.0, 11.97)
	event.ObjsSetRot(2, 0.0, 1.8, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetPos(3, -24.95, 0.0, -10.56)
	event.ObjsSetRot(3, 0.0, 0.96, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	event.SetFadeIn(30)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(2)
	end
	helper_adea7ba0(90)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 16)
	event.ObjsSetMotion(5, "手紙を開く", 2)
	event.ObjsNextMotion(5, "手紙を開くL", 4)
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(0.0, 17.78, 7.71)
	event.CmrsSetRef(0.0, 17.46, 0.0)
	event.ObjsSetMotion(5, "手紙を読む", 4)
	event.ObjsSetMotion(6, "立ち", 4)
	event.ObjsSetMotion(8, "ぷるぷる", 4)
	event.ObjsSetMotion(4, "下向き立ち", 4)
	event.ObjsSetMotion(7, "立ち", 4)
	event.ObjsSetMotion(2, "泣く", 4)
	event.ObjsSetMotion(3, "泣く", 4)
	event.SetCrossfade(30)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(5)
	end
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(6)
	end
	helper_4896c0c7(2800220)
	if vm.skipping() then
		return skip(7)
	end
	event.SetCameraSpeed(0)
	event.CmrsInit()
	event.CmrsMoveAhd2(-1.6, 0.32, 7.71, 250, 1, 1.0)
	event.CmrsMoveAhd(1.6, 0.32, 7.71, 500)
	event.CmrsAhddelay(1)
	event.CmrsMoveAhd2(0.0, 0.32, 7.71, 250, 2, 1.0)
	event.SetMesOkuri(0, 0)
	helper_366d50dc(2800225, -1, 16)
	if vm.skipping() then
		return skip(8)
	end
	helper_366d50dc(2800230, -1, 16)
	if vm.skipping() then
		return skip(9)
	end
	helper_366d50dc(2800240, -1, 20)
	if vm.skipping() then
		return skip(10)
	end
	helper_366d50dc(2800250, -1, 16)
	if vm.skipping() then
		return skip(11)
	end
	helper_366d50dc(2800260, -1, 16)
	if vm.skipping() then
		return skip(12)
	end
	helper_366d50dc(2800270, -1, 16)
	if vm.skipping() then
		return skip(13)
	end
	helper_366d50dc(2800275, -1, 16)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMesOkuri(0, 1)
	event.ObjsSetMotion(5, "手紙を開くL")
	helper_261c70db()
	if vm.skipping() then
		return skip(15)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(16)
	end
	event.SndSePlay(var0, 17)
	event.ObjsSetMotion(5, "手紙を閉じる", 4)
	event.ObjsNextMotion(5, "手紙を閉じるL", 4)
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-92.53, 119.19, 118.35)
	event.CmrsSetRef(11.54, 11.66, -7.56)
	event.ObjsSetMotion(6, "泣く", 4)
	event.ObjsSetMotion(8, "泣く", 4)
	event.ObjsSetMotion(4, "泣く", 4)
	event.ObjsSetMotion(7, "泣く", 4)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(18)
	end
	helper_4896c0c7(2800280)
	if vm.skipping() then
		return skip(19)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(20)
	end
	event.EohSetFrameShow(5, "letter", 0)
	event.EohSetFrameShow(5, "letter4", 0)
	event.CmrsSetPos(-13.25, 21.72, -2.6)
	event.CmrsSetRef(3.29, 19.71, -29.35)
	event.ObjsSetMotion(5, "グスッ", 4)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(21)
	end
	helper_4896c0c7(2800290)
	if vm.skipping() then
		return skip(22)
	end
	helper_4896c0c7(2800295)
	if vm.skipping() then
		return skip(23)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(-12.64, 27.88, 28.23)
	event.CmrsSetRef(-0.15, 19.71, 58.96)
	event.ObjsSetMotion(1, "はい？（会話リアクション）", 4, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(25)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_4896c0c7(2800300)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsSetPos(-13.25, 21.72, -2.6)
	event.CmrsSetRef(3.29, 19.71, -29.35)
	event.ObjsSetMotion(5, "座り", 4)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(28)
	end
	helper_4896c0c7(2800310)
	if vm.skipping() then
		return skip(29)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(-92.53, 119.19, 118.35)
	event.CmrsSetRef(11.54, 11.66, -7.56)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(31)
	end
	helper_4896c0c7(2800320)
	if vm.skipping() then
		return skip(32)
	end
	helper_4896c0c7(2800330)
	if vm.skipping() then
		return skip(33)
	end
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(34)
	end
	event.ObjsSetMotion(5, "見をのりだす", 4)
	event.ObjsNextMotion(5, "見をのりだすL", 4)
	helper_3ea45d11(2800340, 60)
	if vm.skipping() then
		return skip(35)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(36)
	end
	event.CmrsSetPos(-12.64, 27.88, 28.23)
	event.CmrsSetRef(-0.15, 19.71, 58.96)
	event.ObjsSetMotion(1, "はい？（会話リアクション）", 4, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4896c0c7(2800350)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(0.0, 20.92, -6.23)
	event.CmrsSetRef(0.0, 19.86, -20.55)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(39)
	end
	helper_4896c0c7(2800360)
	if vm.skipping() then
		return skip(40)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(-5.07, 23.48, 27.69)
	event.CmrsSetRef(2.31, 23.67, 72.31)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(42)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_4896c0c7(2800370)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsRotation(1, 0.0, 2.28, 0.0, 20)
	helper_23bda4ba(1)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsMove(1, 29.3, 0.0, 46.07, 60)
	event.CmrsMove2(-18.11, 17.54, 36.58, -0.8, 23.67, 74.6, 480, 0, 0)
	helper_3ea45d11(2800380, 120)
	if vm.skipping() then
		return skip(45)
	end
	helper_3ea45d11(2800390, 270)
	if vm.skipping() then
		return skip(46)
	end
	helper_4896c0c7(2800400)
	if vm.skipping() then
		return skip(47)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_1ef0d4b2

--- Program 100.
-- Defined empty, so the engine runs this instead of its default.
script[100] = function() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_128d0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e398()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(2)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "g01", 504)
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_128d0()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g01", 506)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 550.
script[550] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_19148()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s70", 532)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e398()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(30)
end

--- Program 700.
script[700] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SubItem(385)
	helper_15f34()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(30)
end

return script
