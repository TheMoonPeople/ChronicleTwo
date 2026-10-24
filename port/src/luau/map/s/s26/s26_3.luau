--!strict
-- map/s/s26/s26_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_6b9da980 = require("@lib/event/helper_6b9da980")
local helper_6e932de7 = require("@lib/event/helper_6e932de7")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_912a9646 = require("@lib/event/helper_912a9646")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_a518823a = require("@lib/event/helper_a518823a")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c28d4a31 = require("@lib/event/helper_c28d4a31")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_cb265f35 = require("@lib/event/helper_cb265f35")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_11388()
	local active_chr_no: s32 = 0
	local block_2: s32 = 0
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
local function helper_21700000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
	print("00000000000000000000000000000000000000000000\n")
	print("1111111111111111111111111111111111111111111111\n")
end

--- Helper function.
local function helper_10f00()
	local active_chr_no: s32 = 0
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
local function helper_128f0()
	local var0: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
		event.Initialize()
		event.SetMesPreset(0, 0)
		event.CmrsInit()
		event.CmrsSetPos(88.14, 44.81, 0.0)
		event.CmrsSetRef(0.0, 19.45, 0.0)
		event.SetFadeOut(0)
		at = 1
		vm.wait(1)
		event.LoadSound(2239)
		var5 = event.SndLoadSound_2(2239) or var5
		event.StopBgm(0)
		at = 2
		helper_25abe6d2(4)
		event.LoadBgm(57)
		helper_11388()
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
		at = 3
		helper_25abe6d2(30)
		event.MesMake_2(
			0,
			"Dies sind Geosteine. Sie enthalten\ndas Wissen der alten Zivilisation.<page>Legt man sie in den Reaktor, kann\nman verschiedene Dinge mit dem\nSchreinerium bauen."
		)
		at = 4
		helper_b5a98ffa(0, -1, 36, global1, var4)
		event.ObjsSetMotion(3, "炉にくべる", 2)
		at = 5
		helper_25abe6d2(23)
		event.SndSePlay(var5, 9)
		do
			local out1, out2, out3 = event.EohGetFramePos(4, "gio")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.DelReference(35)
		print("x=", pos_x, "y=", pos_y, "z=", pos_z, "\n")
		event.ObjsSetPos(4, pos_x, pos_y, pos_z)
		event.ObjsJump(4, 0.0, 0.0, 0.0, -0.25, 30)
		at = 6
		helper_25abe6d2(30)
		event.SndSePlay(var5, 10)
		event.CharaActive(0, 35)
		at = 7
		helper_25abe6d2(15)
		event.SetMenuEtc(5, 5, 74)
		var0 = 0
		while var0 == 0 do
			at = 8
			vm.wait(8)
			var0 = event.GetMenuEtc_2(8) or var0
		end
		event.SetMenuEtc(4)
		event.SetMenuEtc(3, 1)
		var0 = 0
		while var0 == 0 do
			at = 9
			vm.wait(9)
			local _ = helper_6e932de7(64)
			do
				local _, out1 = event.GetMenuEtc_3(7) -- retail: argument 2 is a value where the handler writes an output; the output is discarded
				var0 = out1 or var0
			end
		end
		event.SetMenuEtc(3, 0)
		event.SetMenuEtc(7)
		event.ObjsSetMotion(3, "会話2")
		event.MesMake_2(0, "Ah ja! Fast\nh[UNI00e4]tt ich's vergessen.")
		at = 10
		helper_b5a98ffa(0, -1, 36, global1, var4)
		event.MesMake_2(
			0,
			"Geosteine liefern Informationen [UNI00fc]ber\nden Bau von Dingen und Daten f[UNI00fc]r\neine bessere Zukunft."
		)
		at = 11
		helper_b5a98ffa(0, -1, 36, global1, var4)
		event.SetMapDraw(0)
		event.SpriteSetDraw(0, 2)
		event.ObjsSetColor(20, 128.0, 128.0, 128.0, 128.0)
		event.SetCrossfade(15)
		at = 12
		helper_25abe6d2(15)
		event.MesMake_2(
			0,
			'Beim Bau der neuen Welt kannst du\ndeine Fortschritte mit "Analyse" im\nGeorama-Men[UNI00fc] einsehen.'
		)
		at = 13
		helper_b5a98ffa(0, -1, 36, global1, var4)
		event.SpriteSetDraw(1, 2)
		event.ObjsSetColor(21, 128.0, 128.0, 128.0, 128.0)
		event.SetCrossfade(15)
		at = 14
		helper_25abe6d2(15)
		event.SpriteSetDraw(0, 0)
		event.MesMake_2(0, 'Oben rechts im Georama-Men[UNI00fc] siehst\ndu die Anzeige\n"Verbl. Polyn".')
		at = 15
		helper_b5a98ffa(0, -1, 36, global1, var4)
		event.MesMake_2(0, "Zum Existieren brauchen Dinge eine\nbestimmte Energie.<page>Diese nennen wir Polyn.")
		at = 16
		helper_b5a98ffa(0, -1, 36, global1, var4)
		event.MesMake_2(
			0,
			"Es kann nur eine begrenzte Menge\nPolyn im Georama-Feld geben. Das\nSchreinerium l[UNI00e4]sst ein [UNI00dc]berschreiten\ndes Maximums nicht zu.<page>Merk dir das."
		)
		at = 17
		helper_b5a98ffa(0, -1, 36, global1, var4)
		event.SetMapDraw(1)
		event.SpriteSetDraw(1, 0)
		event.SetCrossfade(15)
		at = 18
		helper_25abe6d2(15)
		event.MesMake_2(
			0,
			"Wenn du etwas wissen willst, kannst\ndu mich [UNI00fc]ber den Hilfe-Funk fragen.\nIch geb dir gerne Auskunft."
		)
		at = 19
		helper_b5a98ffa(0, -1, 36, global1, var4)
		event.MesMake_2(0, "Den Rest [UNI00fc]berlass ich euch jungen\n Leuten. Ich geh jetzt zu dem\nZug-Dingsbums.")
		at = 20
		helper_b5a98ffa(0, -1, 36, global1, var4)
		event.MesMake_2(
			0,
			"Ich bin im letzten Waggon,\nschaut mal vorbei. O. K.?<page>Braucht ihr Georamamaterialien,\nbin ich gern behilflich."
		)
		at = 21
		helper_b5a98ffa(0, -1, 36, global1, var4)
		event.CmrsSetPos(15.0, 17.57, 15.0)
		event.CmrsSetRef(-20.0, 15.0, -20.0)
		event.CmrsMove(4.35, 17.57, 4.35, -20.0, 15.0, -20.0, 300)
		event.ObjsSetMotion(3, "会話2")
		event.MesMake_2(0, "Also gut. Fangen wir an!\nBist du bereit?")
		at = 22
		helper_b5a98ffa(0, -1, 36, global1, var4)
		event.ObjsSetMotion(3, "立ち")
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		at = 23
		helper_25abe6d2(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_d3f20302(4)
		end
		if at <= 2 then
			helper_21700000()
			helper_d3f20302(30)
		end
		if at <= 3 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 4 then
			helper_d3f20302(23)
		end
		if at <= 5 then
			print("x=", pos_x, "y=", pos_y, "z=", pos_z, "\n")
			helper_d3f20302(30)
		end
		if at <= 6 then
			helper_d3f20302(15)
		end
		if at <= 7 then
			var0 = 0
		end
		if at <= 8 then
			local _ = if var0 == 0 then 1 else 0
			var0 = 0
		end
		if at <= 9 then
			local _ = helper_6b9da980(64)
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 10 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 11 then
			helper_d3f20302(15)
		end
		if at <= 12 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 13 then
			helper_d3f20302(15)
		end
		if at <= 14 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 15 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 16 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 17 then
			helper_d3f20302(15)
		end
		if at <= 18 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 19 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 20 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 21 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 22 then
			helper_d3f20302(30)
		end
		return true
	end)
	event.CancelDramaScene()
	event.SetMapDraw(1)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.SetMenuEtc(4)
	event.SetMenuEtc(7)
	helper_10f00()
	event.Finish()
	event.ResetCamera(0)
	event.SetFadeIn(30)
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
	vm.section(function()
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.LoadSound(2231)
		helper_d350()
		event.StopBgm(0)
		helper_25abe6d2(4)
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
		helper_25abe6d2(90)
		event.PlayBgm(0)
		event.ObjsTexAnime(0, 1, "うれし半口")
		event.ObjsSetMotion(0, "立ち", 0)
		event.ObjsMotionDelay(0, 30)
		event.ObjsSetMotion(0, "かなりキョロキョロ", 4, -1.0, 1)
		event.ObjsSetMotion(1, "立ち", 0)
		event.ObjsSetMotion(5, "会話2", 6, -1.0, 1)
		event.ObjsNextMotion(5, "立ち", 4)
		helper_e34416e2(2500300)
		event.CmrsSetPos(-8.78, 24.17, 51.3)
		event.CmrsSetRef(-16.28, 24.17, 38.68)
		event.CmrsMove2(-8.78, 24.17, 51.3, 4.48, 24.17, 43.59, 210, 2, 0.4)
		helper_e34416e2(2500310)
		event.CmrsInit()
		event.CmrsSetPos(61.11, 28.64, 11.99)
		event.CmrsSetRef(-6.39, 26.92, -14.44)
		helper_e34416e2(2500320)
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
		helper_e34416e2(2500330)
		event.ResetPakuAnim()
		event.ObjsSetMotion(5, "会話", 6, -1.0, 1)
		event.ObjsNextMotion(5, "立ち", 0)
		helper_e34416e2(2500340)
		event.SetPakuAnim(1, "わらい口パク")
		helper_e34416e2(2500350)
		event.ResetPakuAnim()
		event.ObjsSetMotion(0, "これは？", 6, -1.0, 1)
		event.ObjsNextMotion(0, "これは？L", 4)
		event.CmrsPrdelay(10)
		event.CmrsMove2(7.29, 21.91, 58.86, -13.44, 17.54, 2.84, 30, 2, 0.4)
		event.SetPakuAnim(0, "通常口パク")
		helper_e34416e2(2500360)
		event.ResetPakuAnim()
		event.ObjsSetMotion(5, "会話2", 6, -1.0, 1)
		event.ObjsNextMotion(5, "立ち", 0)
		helper_e34416e2(2500370)
		event.SetPakuAnim(0, "通常口パク")
		helper_e34416e2(2500380)
		event.ResetPakuAnim()
		helper_c624bc16()
		event.SpriteSetDraw(0, 1)
		event.ObjsSetColor(9, 128.0, 128.0, 128.0, 128.0, 10)
		helper_e34416e2(2500390)
		helper_e34416e2(2500400)
		helper_e34416e2(2500410)
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
		helper_c28d4a31(2500420, 260)
		helper_c28d4a31(2500425, 90)
		event.CmrsInit()
		event.CmrsSetPos(12.93, 17.36, -15.66)
		event.CmrsSetRef(8.82, 17.73, -6.03)
		event.CmrsMove2(12.93, 17.36, -15.66, 2.22, 17.73, -16.01, 270, 2, 0.4)
		event.ObjsSetRot(1, 0.0, 1.32, 0.0)
		helper_c28d4a31(2500430, 300)
		event.FadeOutBgm(30)
		event.SetMesWindowMode(0, 8)
		event.MesMake_2(0, "Die Georama-Erkl[UNI00e4]rung wurde\ndem Hilfe-Men[UNI00fc] hinzugef[UNI00fc]gt.")
		helper_9e7d1511(0, -1, 8, 0, 0)
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		helper_25abe6d2(4)
		event.LoadBgm(22)
		event.PlayBgm(0)
		event.SetFlag(43, 0)
		event.CmrsInit()
		event.CmrsSetPos(4.11, 22.66, -17.12)
		event.CmrsSetRef(0.71, 19.07, 8.38)
		event.CmrsMove2(2.27, 22.66, -3.34, -1.12, 19.07, 22.16, 180, 2, 0.4)
		helper_c28d4a31(2500440, 210)
		helper_c28d4a31(2500450, 252)
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
		helper_e34416e2(2500460)
		event.ResetPakuAnim()
		helper_0958ca60(1)
		event.ObjsSetMotion(0, "会話", 2)
		event.ObjsNextMotion(0, "立ち", 0)
		event.SetPakuAnim(0, "通常口パク")
		helper_e34416e2(2500470)
		event.ResetPakuAnim()
		event.ObjsSetMotion(1, "左向く", 6)
		event.ObjsNextMotion(1, "左向くL", 4)
		event.SetPakuAnim(1, "通常口パク")
		helper_e34416e2(2500480)
		event.ResetPakuAnim()
		event.ObjsSetMotion(5, "会話", 6)
		event.ObjsNextMotion(5, "立ち", 0)
		helper_e34416e2(2500490)
		event.SetFadeOut(30)
		helper_25abe6d2(30)
	end)
	event.CancelDramaScene()
	event.FuncPointShow("", "fire-0", 1)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	helper_d000()
	event.StopEnvBgm()
	event.SetFadeOut(0)
end

--- Helper function.
local function helper_14ad4()
	local active_chr_no: s32 = 0
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
local function helper_21b00000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_146a8()
	local active_chr_no: s32 = 0
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
	event.MapJump_3(-1, "s02", 503)
end

--- Helper function.
local function helper_15f24()
	local var0: s32 = 0
	local at: number = 0
	vm.section(function()
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		at = 1
		helper_25abe6d2(4)
		event.LoadBgm(112)
		event.LoadSound(2514)
		var0 = event.SndLoadSound_2(2514) or var0
		event.PlayBgm(0)
		helper_14ad4()
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
		at = 2
		helper_25abe6d2(15)
		at = 3
		helper_25abe6d2(90)
		event.SndSePlay(var0, 16)
		event.ObjsSetMotion(5, "手紙を開く", 2)
		event.ObjsNextMotion(5, "手紙を開くL", 4)
		at = 4
		helper_25abe6d2(60)
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
		at = 5
		helper_25abe6d2(15)
		at = 6
		helper_25abe6d2(60)
		at = 7
		helper_e34416e2(2800220)
		event.SetCameraSpeed(0)
		event.CmrsInit()
		event.CmrsMoveAhd2(-1.6, 0.32, 7.71, 250, 1, 1.0)
		event.CmrsMoveAhd(1.6, 0.32, 7.71, 500)
		event.CmrsAhddelay(1)
		event.CmrsMoveAhd2(0.0, 0.32, 7.71, 250, 2, 1.0)
		event.SetMesOkuri(0, 0)
		at = 8
		helper_cb265f35(2800225, -1, 16)
		at = 9
		helper_cb265f35(2800230, -1, 16)
		at = 10
		helper_cb265f35(2800240, -1, 20)
		at = 11
		helper_cb265f35(2800250, -1, 16)
		at = 12
		helper_cb265f35(2800260, -1, 16)
		at = 13
		helper_cb265f35(2800270, -1, 16)
		at = 14
		helper_cb265f35(2800275, -1, 16)
		event.SetMesOkuri(0, 1)
		event.ObjsSetMotion(5, "手紙を開くL")
		at = 15
		helper_c624bc16()
		at = 16
		helper_25abe6d2(30)
		event.SndSePlay(var0, 17)
		event.ObjsSetMotion(5, "手紙を閉じる", 4)
		event.ObjsNextMotion(5, "手紙を閉じるL", 4)
		at = 17
		helper_25abe6d2(60)
		event.CmrsSetPos(-92.53, 119.19, 118.35)
		event.CmrsSetRef(11.54, 11.66, -7.56)
		event.ObjsSetMotion(6, "泣く", 4)
		event.ObjsSetMotion(8, "泣く", 4)
		event.ObjsSetMotion(4, "泣く", 4)
		event.ObjsSetMotion(7, "泣く", 4)
		at = 18
		helper_25abe6d2(15)
		at = 19
		helper_e34416e2(2800280)
		at = 20
		helper_25abe6d2(30)
		event.EohSetFrameShow(5, "letter", 0)
		event.EohSetFrameShow(5, "letter4", 0)
		event.CmrsSetPos(-13.25, 21.72, -2.6)
		event.CmrsSetRef(3.29, 19.71, -29.35)
		event.ObjsSetMotion(5, "グスッ", 4)
		at = 21
		helper_25abe6d2(15)
		at = 22
		helper_e34416e2(2800290)
		at = 23
		helper_e34416e2(2800295)
		at = 24
		helper_25abe6d2(30)
		event.CmrsSetPos(-12.64, 27.88, 28.23)
		event.CmrsSetRef(-0.15, 19.71, 58.96)
		event.ObjsSetMotion(1, "はい？（会話リアクション）", 4, -1.0, 1)
		event.ObjsNextMotion(1, "立ち", 4)
		at = 25
		helper_25abe6d2(15)
		event.SetPakuAnim(1, "通常口パク")
		at = 26
		helper_e34416e2(2800300)
		event.ResetPakuAnim()
		at = 27
		helper_25abe6d2(30)
		event.CmrsSetPos(-13.25, 21.72, -2.6)
		event.CmrsSetRef(3.29, 19.71, -29.35)
		event.ObjsSetMotion(5, "座り", 4)
		at = 28
		helper_25abe6d2(15)
		at = 29
		helper_e34416e2(2800310)
		at = 30
		helper_25abe6d2(30)
		event.CmrsSetPos(-92.53, 119.19, 118.35)
		event.CmrsSetRef(11.54, 11.66, -7.56)
		at = 31
		helper_25abe6d2(15)
		at = 32
		helper_e34416e2(2800320)
		at = 33
		helper_e34416e2(2800330)
		at = 34
		helper_25abe6d2(60)
		event.ObjsSetMotion(5, "見をのりだす", 4)
		event.ObjsNextMotion(5, "見をのりだすL", 4)
		at = 35
		helper_c28d4a31(2800340, 60)
		at = 36
		helper_25abe6d2(30)
		event.CmrsSetPos(-12.64, 27.88, 28.23)
		event.CmrsSetRef(-0.15, 19.71, 58.96)
		event.ObjsSetMotion(1, "はい？（会話リアクション）", 4, -1.0, 1)
		event.ObjsNextMotion(1, "立ち", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 37
		helper_e34416e2(2800350)
		event.ResetPakuAnim()
		at = 38
		helper_25abe6d2(30)
		event.CmrsSetPos(0.0, 20.92, -6.23)
		event.CmrsSetRef(0.0, 19.86, -20.55)
		at = 39
		helper_25abe6d2(15)
		at = 40
		helper_e34416e2(2800360)
		at = 41
		helper_25abe6d2(30)
		event.CmrsSetPos(-5.07, 23.48, 27.69)
		event.CmrsSetRef(2.31, 23.67, 72.31)
		at = 42
		helper_25abe6d2(15)
		event.ObjsSetMotion(1, "会話", 2)
		event.ObjsNextMotion(1, "立ち", 4)
		event.SetPakuAnim(1, "わらい口パク")
		at = 43
		helper_e34416e2(2800370)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsRotation(1, 0.0, 2.28, 0.0, 20)
		at = 44
		helper_0958ca60(1)
		event.ObjsMove(1, 29.3, 0.0, 46.07, 60)
		event.CmrsMove2(-18.11, 17.54, 36.58, -0.8, 23.67, 74.6, 480, 0, 0)
		at = 45
		helper_c28d4a31(2800380, 120)
		at = 46
		helper_c28d4a31(2800390, 270)
		at = 47
		helper_e34416e2(2800400)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_21b00000()
			helper_d3f20302(15)
		end
		if at <= 2 then
			helper_d3f20302(90)
		end
		if at <= 3 then
			helper_d3f20302(60)
		end
		if at <= 4 then
			helper_d3f20302(15)
		end
		if at <= 5 then
			helper_d3f20302(60)
		end
		if at <= 6 then
			helper_8cd371d7(2800220)
		end
		if at <= 7 then
			helper_a518823a(2800225, -1, 16)
		end
		if at <= 8 then
			helper_a518823a(2800230, -1, 16)
		end
		if at <= 9 then
			helper_a518823a(2800240, -1, 20)
		end
		if at <= 10 then
			helper_a518823a(2800250, -1, 16)
		end
		if at <= 11 then
			helper_a518823a(2800260, -1, 16)
		end
		if at <= 12 then
			helper_a518823a(2800270, -1, 16)
		end
		if at <= 13 then
			helper_a518823a(2800275, -1, 16)
		end
		if at <= 14 then
			helper_344d6cd8()
		end
		if at <= 15 then
			helper_d3f20302(30)
		end
		if at <= 16 then
			helper_d3f20302(60)
		end
		if at <= 17 then
			helper_d3f20302(15)
		end
		if at <= 18 then
			helper_8cd371d7(2800280)
		end
		if at <= 19 then
			helper_d3f20302(30)
		end
		if at <= 20 then
			helper_d3f20302(15)
		end
		if at <= 21 then
			helper_8cd371d7(2800290)
		end
		if at <= 22 then
			helper_8cd371d7(2800295)
		end
		if at <= 23 then
			helper_d3f20302(30)
		end
		if at <= 24 then
			helper_d3f20302(15)
		end
		if at <= 25 then
			helper_8cd371d7(2800300)
		end
		if at <= 26 then
			helper_d3f20302(30)
		end
		if at <= 27 then
			helper_d3f20302(15)
		end
		if at <= 28 then
			helper_8cd371d7(2800310)
		end
		if at <= 29 then
			helper_d3f20302(30)
		end
		if at <= 30 then
			helper_d3f20302(15)
		end
		if at <= 31 then
			helper_8cd371d7(2800320)
		end
		if at <= 32 then
			helper_8cd371d7(2800330)
		end
		if at <= 33 then
			helper_d3f20302(60)
		end
		if at <= 34 then
			helper_52aadc70(2800340, 60)
		end
		if at <= 35 then
			helper_d3f20302(30)
		end
		if at <= 36 then
			helper_8cd371d7(2800350)
		end
		if at <= 37 then
			helper_d3f20302(30)
		end
		if at <= 38 then
			helper_d3f20302(15)
		end
		if at <= 39 then
			helper_8cd371d7(2800360)
		end
		if at <= 40 then
			helper_d3f20302(30)
		end
		if at <= 41 then
			helper_d3f20302(15)
		end
		if at <= 42 then
			helper_8cd371d7(2800370)
		end
		if at <= 43 then
			helper_238b5abc(1)
		end
		if at <= 44 then
			helper_52aadc70(2800380, 120)
		end
		if at <= 45 then
			helper_52aadc70(2800390, 270)
		end
		if at <= 46 then
			helper_8cd371d7(2800400)
		end
		return true
	end)
	event.CancelDramaScene()
	event.BgmLoadCancel()
	helper_146a8()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_1ef0d4b2

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_128f0

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_e398()
	event.SetFadeOut(0)
	vm.wait(2)
	event.BgmLoadCancel()
	event.MapJump_3(-1, "g01", 504)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_128f0()
	event.MapJump_3(-1, "g01", 506)
	vm.wait(2)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	helper_912a9646()
	event.MapJump_3(-1, "s70", 532)
	vm.wait(2)
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	helper_e398()
	event.SetFadeIn(30)
end

--- Event 700, which map data, a script or the engine runs by number.
function script.event_700()
	event.SubItem(385)
	helper_15f24()
	event.SetFadeIn(30)
end

return script
