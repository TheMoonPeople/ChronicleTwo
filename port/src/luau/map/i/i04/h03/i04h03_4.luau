--!strict
-- map/i/i04/h03/i04h03_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09f03e07 = require("@lib/event/helper_09f03e07")
local helper_0f1a8d4c = require("@lib/event/helper_0f1a8d4c")
local helper_126faf7c = require("@lib/event/helper_126faf7c")
local helper_135c47c2 = require("@lib/event/helper_135c47c2")
local helper_338c09af = require("@lib/event/helper_338c09af")
local helper_36b4b27c = require("@lib/event/helper_36b4b27c")
local helper_36bc4ca6 = require("@lib/event/helper_36bc4ca6")
local helper_4005e7b5 = require("@lib/event/helper_4005e7b5")
local helper_417760a7 = require("@lib/event/helper_417760a7")
local helper_4413bb92 = require("@lib/event/helper_4413bb92")
local helper_56839ab3 = require("@lib/event/helper_56839ab3")
local helper_586df9ca = require("@lib/event/helper_586df9ca")
local helper_614e6a96 = require("@lib/event/helper_614e6a96")
local helper_6ed96194 = require("@lib/event/helper_6ed96194")
local helper_782657f7 = require("@lib/event/helper_782657f7")
local helper_7d9a42e5 = require("@lib/event/helper_7d9a42e5")
local helper_8333218b = require("@lib/event/helper_8333218b")
local helper_8fec6047 = require("@lib/event/helper_8fec6047")
local helper_9239d177 = require("@lib/event/helper_9239d177")
local helper_97e40e9b = require("@lib/event/helper_97e40e9b")
local helper_9817d359 = require("@lib/event/helper_9817d359")
local helper_9cbf7600 = require("@lib/event/helper_9cbf7600")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_b36d7735 = require("@lib/event/helper_b36d7735")
local helper_b370ce8a = require("@lib/event/helper_b370ce8a")
local helper_b5e70035 = require("@lib/event/helper_b5e70035")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_c17a8778 = require("@lib/event/helper_c17a8778")
local helper_c729682a = require("@lib/event/helper_c729682a")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")
local helper_d8d161f8 = require("@lib/event/helper_d8d161f8")
local helper_dfb95bfd = require("@lib/event/helper_dfb95bfd")
local helper_ee2fed44 = require("@lib/event/helper_ee2fed44")
local helper_ef3dadd9 = require("@lib/event/helper_ef3dadd9")
local helper_f1049565 = require("@lib/event/helper_f1049565")
local helper_fe03cbd6 = require("@lib/event/helper_fe03cbd6")

--- Helper function.
local function helper_3c748(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(0, "p08_i04h03")
	event.EohSetShow(0, arg0)
	event.FuncPointShow("", "func0", arg0)
end

--- Helper function.
local function helper_3c860()
	local flag: s32 = 0
	flag = event.GetFlag(37) or flag
	helper_3c748(if flag == 0 then 1 else 0)
end

--- Helper function.
local function helper_37d1c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_a45deb91(arg0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.MesMake_2(0, "Ciao.\nMonica, giusto?")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Mi chiamo Parn.\nSono un artista magico.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Ehi, Max!<page>Come fai ad essere\nsempre cos[UNI00ec] in forma?!")
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_38108(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b0211f82(30)
		end
		if at <= 2 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_126faf7c(1)
		end
		if at <= 5 then
			helper_126faf7c(1)
		end
		if at <= 6 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_126faf7c(0)
		end
		if at <= 8 then
			helper_b0211f82(30)
		end
		if at <= 9 then
			helper_d1353c5b(0, -1, 2, 341, 416)
		end
		if at <= 10 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
		if at <= 11 then
			helper_b0211f82(30)
		end
	end
	event.SetMotion(arg1, "立ち")
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesPreset(0, 0)
	event.EohSyncChara(0, arg1)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, arg0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CmrsInit()
	event.CmrsSetPos(-41.63, 18.05, -20.16)
	event.CmrsSetRef(30.4, 34.28, -73.36)
	event.ObjsSetPos(0, 30.52, 0.2, -56.3)
	event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 23.52, 0.2, -84.52)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "立ち")
	event.SetFadeIn(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(0, "Ciao.\nMonica, giusto?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Mi chiamo Parn.\nSono un artista magico.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsReference(1, 60.0, 0.0, -100.0, 30)
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(0, "Non vi ho ancora presentato, vero?<page>Ecco Julia, la mia futura moglie.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsReference(0, 60.0, 0.0, -100.0, 30)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "...")
	helper_d1353c5b(0, -1, 2, 341, 416)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)] Monica non [UNI00e8] molto brava in queste\n   situazioni. Forse pu[UNI00f2] fare qualcosa,\n   forse no. Meglio riprovare come Max."
	)
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.ResetCamera(1, 3.14, 20.0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_38e0c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b0211f82(30)
		end
		if at <= 2 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_126faf7c(1)
		end
		if at <= 4 then
			helper_126faf7c(1)
		end
		if at <= 5 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_126faf7c(0)
		end
		if at <= 7 then
			helper_b0211f82(30)
		end
		if at <= 8 then
			helper_d1353c5b(0, -1, 2, 341, 416)
		end
		if at <= 9 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_126faf7c(0)
		end
		if at <= 13 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_126faf7c(1)
		end
		if at <= 16 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 18 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
		if at <= 19 then
			helper_b0211f82(30)
		end
	end
	event.SetMotion(arg1, "立ち")
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesPreset(0, 0)
	event.EohSyncChara(0, arg1)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, arg0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CmrsInit()
	event.CmrsSetPos(-41.63, 18.05, -20.16)
	event.CmrsSetRef(30.4, 34.28, -73.36)
	event.ObjsSetPos(0, 30.52, 0.2, -56.3)
	event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 23.52, 0.2, -84.52)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "立ち")
	event.SetFadeIn(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Ehi, Max!")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsReference(1, 60.0, 0.0, -100.0, 30)
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(0, "Non vi ho ancora presentato, vero?<page>Ecco Julia, la mia futura moglie.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsReference(0, 60.0, 0.0, -100.0, 30)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "...")
	helper_d1353c5b(0, -1, 2, 341, 416)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(
		0,
		"Certo, ridi pure!\nLo so che [UNI00e8] strano!<page>Chi si innamorerebbe della\nragazza di un quadro?"
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"Ma io sono un artista magico e\nposso dar vita ai miei quadri.<page>I miei soggetti esistono davvero,\nescluse le creature viventi..."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "Neanche un artista magico pu[UNI00f2]\nricreare la vita")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, 3.1415927, 0.0, 30)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "立ち")
	event.MesMake_2(0, "In realt[UNI00e0] un modo c'[UNI00e8]: un Uovo\nd'Oro in un grande albero antico.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Pare che la sua Vernice oro dia\nvita a qualunque disegno.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsRotation(1, 0.0, 0.17, 0.0, 30)
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(0, "Max, stai andando fuori\ncitt[UNI00e0], vero?<page>Mi prenderesti della Vernice oro?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.MesMake_2(
		0,
		"Non mi aspetto che lo faccia gratis.<page>Se mi dai una mano, user[UNI00f2] i miei\nnuovi poteri per aiutarti."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Un grande albero antico...\n   con un Uovo d'Oro! Dove diavolo\n   lo trovi un albero simile?!"
	)
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(19)
	end
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(20)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.ResetCamera(1, 3.14, 20.0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_3a28c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_38108(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	helper_38e0c(arg0, arg1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetQuestEtc(0, 1, 1)
end

--- Helper function.
local function helper_3a3fc()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4005e7b5(1, 4)
			helper_d1353c5b(1, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_4005e7b5(1, 4)
	event.MesMake_2(1, "Julia si [UNI00e8] unita al gruppo.\nJulia [UNI00e8] tornata al treno.")
	helper_d1353c5b(1, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_3a5b0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			if at <= 3 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			return
		end
		if at <= 7 then
			helper_b0211f82(30)
		end
		if at <= 8 then
			helper_b8950300(0, -1, var5, 0, 0)
		end
		if at <= 9 then
			helper_126faf7c(1)
		end
		if at <= 10 then
			helper_b0211f82(60)
		end
		if at <= 11 then
			helper_b0211f82(60)
		end
		if at <= 12 then
			helper_b0211f82(60)
		end
		if at <= 13 then
			helper_b0211f82(30)
		end
		if at <= 14 then
			helper_b0211f82(30)
		end
		if at <= 15 then
			helper_b0211f82(30)
		end
		if at <= 16 then
			helper_b0211f82(30)
		end
		if at <= 17 then
			helper_b8950300(0, -1, var5, 0, 0)
		end
		if at <= 18 then
			helper_126faf7c(2)
		end
		if at <= 19 then
			helper_b8950300(0, -1, 32, 0, 0)
		end
		if at <= 20 then
			helper_126faf7c(1)
		end
		if at <= 21 then
			helper_b8950300(0, -1, var5, 0, 0)
		end
		if at <= 22 then
			helper_d8d161f8(5)
		end
		if at <= 23 then
			helper_3a3fc()
		end
		if at <= 24 then
			helper_b0211f82(35)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_a45deb91(arg0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.MesMake_2(0, "Le ragazze non riescono a capire\nperch[UNI00e9] gli uomini inseguano\ni propri ideali.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Ti stavo aspettando.<page>Forza, dammi la Vernice, cos[UNI00ec]\nposso dar vita al mio quadro!")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.GotoUseItem(376)
	do
		local skipped = vm.wait()
		var3 = event.DeferredOutput() or var3
		if skipped then
			return skip(5)
		end
	end
	if var3 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var3 ~= 376 then
		event.MesMake_2(0, "Starai scherzando!<page>Mi serve la Vernice oro.\nNon sbagliare!")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.Initialize()
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(7)
	end
	event.LoadSound(2827)
	var4 = event.SndLoadSound(2827) or var4
	var5 = event.SearchCharaNo(5) or var5
	event.SetAi(0, var5)
	event.EohSyncChara(1, var5)
	event.ObjsInit(1, var5)
	event.ObjsSyncObj(1, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "chara/p01_25a.gltf", "info", 32)
	event.CharaActive(0, 32)
	event.EohSyncChara(2, 32)
	event.ObjsInit(2, 32)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e200/e255/e255_rafhikari.gltf", "info", 33)
	event.CharaActive(0, 33)
	event.EohSyncChara(3, 33)
	event.ObjsInit(3, 33)
	event.ObjsSyncObj(3, 3)
	event.CmrsInit()
	event.CmrsSetPos(-41.63, 18.05, -20.16)
	event.CmrsSetRef(30.4, 34.28, -73.36)
	event.SetCharaPos(0, 30.52, 0.2, -56.3)
	event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
	event.SetMotion(0, "立ち")
	event.ObjsSetPos(1, 23.52, 0.2, -84.52)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "立ち")
	event.SetFadeIn(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(1, "会話")
	event.MesMake_2(0, "Cos[UNI00ec] [UNI00e8] questa la Vernice oro...\nLa provo subito.")
	helper_b8950300(0, -1, var5, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsReference(1, 60.0, 0.0, -100.0, 30)
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "会話")
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(12)
	end
	event.CharaActive(1, 33)
	event.ObjsSetPos(3, 45.0, 15.0, -90.0)
	event.ObjsSetMotion(3, "ラフレシアの光", 6)
	event.SndSePlay(var4, 2)
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(13)
	end
	event.SetFadeOut(30, 250.0, 250.0, 250.0)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(14)
	end
	event.CharaActive(0, 33)
	event.CharaActive(1, 32)
	event.ObjsSetPos(2, 45.0, 15.0, -90.0)
	event.ObjsSetRot(2, 0.0, -0.7853982, 0.0)
	event.ObjsSetMotion(2, "立ち")
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(15)
	end
	event.SetFadeIn(30, 255.0, 255.0, 255.0)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(16)
	end
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(1, "会話")
	event.MesMake_2(0, "Lei, lei... [UNI00e8] vera...<page>Incredibile, [UNI00e8] perfetta!")
	helper_b8950300(0, -1, var5, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(2, "歩き")
	event.ObjsReference(2, 30.52, 0.2, -56.3, 30)
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(2, "立ち")
	event.ObjsSetMotion(2, "会話")
	event.MesMake_2(0, "Ciao, mi chiamo Julia.\nPiacere di conoscerti.")
	helper_b8950300(0, -1, 32, 0, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(2, "立ち")
	event.ObjsSetMotion(1, "歩き")
	event.ObjsReference(1, 30.52, 0.2, -56.3, 30)
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(1, "会話")
	event.MesMake_2(0, "Grazie, Max. Non ho dimenticato\nla mia promessa. Usa pure il\nmio nuovo potere quando vuoi!")
	helper_b8950300(0, -1, var5, 0, 0)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsSetMotion(1, "立ち")
	event.SetNpcStatus(5, 128)
	helper_d8d161f8(5)
	if vm.skipping() then
		return skip(23)
	end
	event.SetNpcStatus(22, 130)
	helper_3a3fc()
	if vm.skipping() then
		return skip(24)
	end
	event.SetFadeOut(30)
	helper_b0211f82(35)
	if vm.skipping() then
		return skip(25)
	end
	event.DeleteChara(32)
	event.DeleteChara(33)
	event.Finish()
	event.SetQuestEtc(1, 1, 1)
	event.SetAi(1, var5)
	event.ResetCamera(1, 3.14, 20.0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_3c084(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.MesMake_2(
				0,
				"Le ragazze non riescono a capire\nperch[UNI00e9] gli uomini inseguano\ni propri ideali."
			)
		else
			event.MesMake_2(0, "Usa pure il mio nuovo potere\nquando vuoi.")
		end
	else
		event.MesMake_2(
			0,
			"Il mondo della pittura [UNI00e8] sconfinato.\nPotrebbe volerci tutta la vita per\nconoscerlo ma ne varrebbe la pena!"
		)
	end
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_3c3e4(arg0: s32)
	local player_chara: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_37d1c(arg0, player_chara)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_3a28c(arg0, player_chara)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_3a5b0(arg0, player_chara)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_3c084(arg0, player_chara)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_11f4c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_f1049565(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMotion(arg1, "立ち")
		event.MesMake_2(0, "Mmh, questo albero... Non sembra\nstia bene. Devo fare qualcosa.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		event.MesMake_2(
			0,
			"Oh, Max! Mi hai messo paura.\nStavo levando dei fastidiosi\nparassiti da quest'albero.<page>Non tutti gli alberi crescono bene\nda soli, sai. Alcuni, come questo,\nhanno bisogno di molte cure."
		)
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_13fa4(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_11f4c(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_11f4c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_b5e70035(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_b36d7735(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_586df9ca(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_351c8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local var7: any = 0
	local var8: any = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: any = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local var14: any = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: any = 0
	local var18: s32 = 0
	local active_chr_no: s32 = 0
	local var20: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_13fa4(arg0, arg1)
			end
			if at <= 2 then
				helper_dfb95bfd(arg0, arg1)
			end
			if at <= 3 then
				var7 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 7 then
			if at <= 5 then
				helper_b0211f82(30)
			end
			return
		end
		if at <= 9 then
			if at <= 8 then
				var8 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 12 then
			if at <= 10 then
				helper_b0211f82(30)
			end
			return
		end
		if at <= 18 then
			if at <= 13 then
				helper_4413bb92(arg0, arg1)
			end
			if at <= 14 then
				helper_c17a8778(arg0, arg1)
			end
			if at <= 15 then
				helper_b370ce8a(arg0, arg1)
			end
			if at <= 16 then
				helper_9cbf7600(arg0, arg1)
			end
			if at <= 17 then
				var11 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 19 then
			return
		end
		if at <= 23 then
			if at <= 20 then
				helper_782657f7(arg0, arg1)
			end
			if at <= 21 then
				helper_97e40e9b(arg0, arg1)
			end
			if at <= 22 then
				var14 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 24 then
			return
		end
		if at <= 29 then
			if at <= 25 then
				helper_417760a7(arg0, arg1)
			end
			if at <= 26 then
				helper_6ed96194(arg0, arg1)
			end
			if at <= 27 then
				helper_c729682a(arg0, arg1)
			end
			if at <= 28 then
				var17 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 30 then
			return
		end
		if at <= 39 then
			if at <= 31 then
				helper_9817d359(arg0, arg1)
			end
			if at <= 32 then
				helper_8fec6047(arg0, arg1)
			end
			if at <= 33 then
				helper_614e6a96(arg0, arg1)
			end
			if at <= 34 then
				helper_9239d177(arg0, arg1)
			end
			if at <= 35 then
				helper_09f03e07(arg0, arg1)
			end
			if at <= 36 then
				helper_338c09af(arg0, arg1)
			end
			if at <= 37 then
				helper_ef3dadd9(arg0, arg1)
			end
			if at <= 38 then
				var20 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 40 then
			return
		end
		if at <= 41 then
			helper_f1049565(arg0, -1, 0, 0)
		end
		if at <= 42 then
			helper_f1049565(arg0, -1, 0, 0)
		end
		if at <= 43 then
			helper_f1049565(arg0, -1, 0, 0)
		end
		if at <= 44 then
			helper_f1049565(arg0, -1, 0, 0)
		end
		if at <= 45 then
			helper_f1049565(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.SetMesShippo(0, 1)
	var2 = event.GetChapter() or var2
	var3 = event.GetEventData_2(14) or var3
	event.GetNowMapNo()
	now_sub_map_no = event.GetNowSubmapNo() or now_sub_map_no
	event.CtrlcStay()
	event.SetAi(0, arg0)
	if var3 == 3 then
		helper_13fa4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 5 then
		helper_dfb95bfd(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Fammi far compere\nIndaga per uno scoop")
			var7 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(4)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_56839ab3(0)
				if vm.skipping() then
					return skip(5)
				end
				if t0 ~= 0 then
					event.SetFadeOut(25)
					helper_b0211f82(30)
					if vm.skipping() then
						return skip(6)
					end
					event.GotoMenu(6, 33)
					if vm.wait() then
						return skip(7)
					end
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_135c47c2()
				if vm.skipping() then
					return skip(8)
				end
			end
		else
			event.MesMake_2(0, "Benvenuto!\nIndaga per uno scoop")
			var8 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(9)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_56839ab3(0)
				if vm.skipping() then
					return skip(10)
				end
				if t1 ~= 0 then
					event.SetFadeOut(25)
					helper_b0211f82(30)
					if vm.skipping() then
						return skip(11)
					end
					event.GotoMenu(6, 33)
					if vm.wait() then
						return skip(12)
					end
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_36bc4ca6(arg0, arg1)
				if vm.skipping() then
					return skip(13)
				end
			end
		end
	end
	if var3 == 7 then
		helper_4413bb92(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 8 then
		helper_c17a8778(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 10 then
		helper_b370ce8a(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 11 then
		helper_9cbf7600(arg0, arg1)
		if vm.skipping() then
			return skip(17)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Salve\nBenvenuto!")
			var11 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(18)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_782657f7(arg0, arg1)
				if vm.skipping() then
					return skip(19)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_135c47c2()
			if vm.skipping() then
				return skip(20)
			end
		else
			helper_782657f7(arg0, arg1)
			if vm.skipping() then
				return skip(21)
			end
		end
	end
	if var3 == 14 then
		helper_97e40e9b(arg0, arg1)
		if vm.skipping() then
			return skip(22)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Salve\nBenvenuto!")
			var14 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(23)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_417760a7(arg0, arg1)
				if vm.skipping() then
					return skip(24)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_135c47c2()
			if vm.skipping() then
				return skip(25)
			end
		else
			helper_417760a7(arg0, arg1)
			if vm.skipping() then
				return skip(26)
			end
		end
	end
	if var3 == 16 then
		helper_6ed96194(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 17 then
		helper_c729682a(arg0, arg1)
		if vm.skipping() then
			return skip(28)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Salve\nBenvenuto!")
			var17 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(29)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_9817d359(arg0, arg1)
				if vm.skipping() then
					return skip(30)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_135c47c2()
			if vm.skipping() then
				return skip(31)
			end
		else
			helper_9817d359(arg0, arg1)
			if vm.skipping() then
				return skip(32)
			end
		end
	end
	if var3 == 19 then
		helper_8fec6047(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 20 then
		helper_614e6a96(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 21 then
		helper_9239d177(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 23 then
		helper_09f03e07(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 24 then
		helper_338c09af(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 25 then
		helper_ef3dadd9(arg0, arg1)
		if vm.skipping() then
			return skip(38)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Fammi far compere\nSalve")
			var20 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(39)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_36b4b27c(arg0, arg1)
				if vm.skipping() then
					return skip(40)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_135c47c2()
		if vm.skipping() then
			return skip(41)
		end
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Ultimamente faccio fatica\na vedere le cose piccole.<page>Mmmh... sto\ninvecchiando...")
		else
			event.MesMake_2(
				0,
				"Vedere la Ferrovia Carbonero\noperativa su tutto il continente\n[UNI00e8] il sogno mio e di Need.<page>Possiamo contare su di te, vero?"
			)
		end
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(42)
		end
	end
	if var3 == 2 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Se non tengo le mani\ncontinuamente occupate,\nvado fuori di testa!")
		else
			event.MesMake_2(
				0,
				"Se trovano la Zelmite sar[UNI00f2]\nproprio impegnato. Gi[UNI00e0]!\nScavare, scavare e solo scavare!!!"
			)
		end
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(43)
		end
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Sai, in questi giorni, ho\nle penne piene di pulci:\nprudono terribilmente!")
		else
			event.MesMake_2(0, "Va bene passare il tempo\ncercando Zelmite, ma vedi di\nnon stancarti troppo, ragazzo!")
		end
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(44)
		end
	end
	if var3 == 13 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Che profumo la polvere da sparo!\nSono nato per questo lavoro!<page>Certo, il mio capo [UNI00e8] un terribile\ncapoccione e all'antica.\nMa... pazienza!"
			)
		else
			event.MesMake_2(0, "Ti piace proprio\nl'avventura, eh?")
		end
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(45)
		end
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "A parte il fatto di essere nata\nda un quadro, non sono differente\nda chiunque altro.")
		else
			event.MesMake_2(0, "Ho un brutto presentimento sulla\nMiniera di Zelmite. Stai all'erta!")
		end
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(46)
		end
	end
	event.SetAi(1, arg0)
end

--- Helper function.
local function helper_37ba0()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_351c8(var1, player_chara)
		end
		if at <= 2 then
			helper_fe03cbd6()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_351c8(var1, player_chara)
		if vm.skipping() then
			return skip(2)
		end
	else
		helper_fe03cbd6()
		if vm.skipping() then
			return skip(3)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = helper_3c860

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 400.
script[400] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c748(0)
			helper_7d9a42e5(1)
		end
	end
	event.SetMotion(0, "立ち")
	flag = event.GetFlag(37) or flag
	if flag == 0 then
		event.SetFlag(37, 1)
		event.AddItem(243, 20)
		helper_8333218b(243, 20)
		if vm.skipping() then
			return skip(1)
		end
		helper_3c748(0)
		helper_7d9a42e5(1)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_37ba0()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 == 5 then
		var1 = event.GetEventData_2(13) or var1
		event.CtrlcStay()
		event.SetAi(0, var1)
		helper_3c3e4(var1)
		if vm.skipping() then
			return skip(1)
		end
		event.SetAi(1, var1)
	else
		helper_37ba0()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return script
