--!strict
-- map/i/i04/h03/i04h03_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0f1a8d4c = require("@lib/event/helper_0f1a8d4c")
local helper_10262c1a = require("@lib/event/helper_10262c1a")
local helper_11dbc26a = require("@lib/event/helper_11dbc26a")
local helper_126faf7c = require("@lib/event/helper_126faf7c")
local helper_28d822c1 = require("@lib/event/helper_28d822c1")
local helper_30377d3f = require("@lib/event/helper_30377d3f")
local helper_303fddce = require("@lib/event/helper_303fddce")
local helper_315f4039 = require("@lib/event/helper_315f4039")
local helper_3c72acc5 = require("@lib/event/helper_3c72acc5")
local helper_3ca59f4a = require("@lib/event/helper_3ca59f4a")
local helper_4005e7b5 = require("@lib/event/helper_4005e7b5")
local helper_45d8a369 = require("@lib/event/helper_45d8a369")
local helper_5676a4a9 = require("@lib/event/helper_5676a4a9")
local helper_63e5aa4a = require("@lib/event/helper_63e5aa4a")
local helper_67b76682 = require("@lib/event/helper_67b76682")
local helper_739136b8 = require("@lib/event/helper_739136b8")
local helper_7b1ef108 = require("@lib/event/helper_7b1ef108")
local helper_7d9a42e5 = require("@lib/event/helper_7d9a42e5")
local helper_7f145e10 = require("@lib/event/helper_7f145e10")
local helper_8e16dcbe = require("@lib/event/helper_8e16dcbe")
local helper_8ecb6320 = require("@lib/event/helper_8ecb6320")
local helper_8fa5bfff = require("@lib/event/helper_8fa5bfff")
local helper_9901a709 = require("@lib/event/helper_9901a709")
local helper_992b27d9 = require("@lib/event/helper_992b27d9")
local helper_a20cf492 = require("@lib/event/helper_a20cf492")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_a7d6a00a = require("@lib/event/helper_a7d6a00a")
local helper_ac3d3596 = require("@lib/event/helper_ac3d3596")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_c9cddfe6 = require("@lib/event/helper_c9cddfe6")
local helper_cee58859 = require("@lib/event/helper_cee58859")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")
local helper_d8d161f8 = require("@lib/event/helper_d8d161f8")
local helper_ee2fed44 = require("@lib/event/helper_ee2fed44")
local helper_f1049565 = require("@lib/event/helper_f1049565")
local helper_fc3f289b = require("@lib/event/helper_fc3f289b")

--- Helper function.
local function helper_3e5d8(arg0: s32)
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
local function helper_3e6f0()
	local flag: s32 = 0
	flag = event.GetFlag(37) or flag
	helper_3e5d8(if flag == 0 then 1 else 0)
end

--- Helper function.
local function helper_39a2c(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Salut.\nC'est Monica, c'est [UNI00e7]a ?")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Moi, c'est Parn.\nJe suis artiste magique.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "H[UNI00e9], Max.<page>Comment tu fais pour toujours\navoir l'air en forme ?!")
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_39e38(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Salut.\nC'est Monica, c'est [UNI00e7]a ?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Moi, c'est Parn.\nJe suis artiste magique.")
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
	event.MesMake_2(0, "Je n'ai pas fait les pr[UNI00e9]sentations.<page>Voici Julia, ma future [UNI00e9]pouse.")
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
		"[(!)]Monica n'aime pas trop ce genre de \n   situation. Elle n'est pas s[UNI00fb]re d'arriver\n   [UNI00e0] ses fins. Essaie plut[UNI00f4]t avec Max."
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
local function helper_3ab6c(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "H[UNI00e9] Max.")
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
	event.MesMake_2(0, "Je n'ai pas fait les pr[UNI00e9]sentations.<page>Voici Julia, ma future [UNI00e9]pouse.")
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
		"Ouais, [UNI00e7]a te fait rire, hein ?\nJe sais que c'est bizarre !<page>Qui irait tomber amoureux d'une\nfille en gouache ?"
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"Mais je suis un artiste magique. Je\npeux donner l'existence [UNI00e0] ce que je<page>dessine. L'existence, mais pas la\nvie, c'est vrai..."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "Personne ne peut dessiner la vie.")
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
	event.MesMake_2(0, "Mais j'ai entendu parler d'un [UNI0153]uf\ndor[UNI00e9] dans un grand arbre ancien.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Il para[UNI00ee]t qu'avec sa couleur dor[UNI00e9]e,\non peut donner vie aux dessins.")
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
	event.MesMake_2(
		0,
		"Max, tu quittes la ville, non ?\nTu crois que tu pourrais m'avoir<page>de la peinture dor[UNI00e9]e ?"
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.MesMake_2(
		0,
		"Je te le revaudrai bien entendu.<page>Si tu m'aides, j'utiliserai mes\nnouveaux pouvoirs pour t'assister."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Un vieil arbre, immense...\n   Avec un [UNI0153]uf dor[UNI00e9] ! Mais o[UNI00f9] trouver\n   un arbre comme celui-ci ?!"
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
local function helper_3c03c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_39e38(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	helper_3ab6c(arg0, arg1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetQuestEtc(0, 1, 1)
end

--- Helper function.
local function helper_3c1ac()
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
	event.MesMake_2(1, "Julia t'accompagne dans ton aventure.\nElle est mont[UNI00e9]e dans le train.")
	helper_d1353c5b(1, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_3c360(arg0: s32, arg1: s32)
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
			helper_3c1ac()
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
		event.MesMake_2(
			0,
			"Je suppose qu'une fille ne pourrait\ncomprendre les raisons qui poussent\nun homme [UNI00e0] poursuivre ses id[UNI00e9]aux."
		)
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
	event.MesMake_2(
		0,
		"Je t'attendais. Vite, donne-moi<page>la peinture, que je puisse enfin\ndonner vie [UNI00e0] mon portrait."
	)
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
		event.MesMake_2(
			0,
			"C'est une blague !?<page>Ce qu'il me faut, c'est de la\npeinture dor[UNI00e9]e. Et rien d'autre !"
		)
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
	event.MesMake_2(0, "Ah, la fameuse peinture dor[UNI00e9]e...\nJe vais l'essayer imm[UNI00e9]diatement.")
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
	event.MesMake_2(0, "E-elle... Elle est r[UNI00e9]elle...<page>[UNI00c9]tonnant, elle est parfaite !")
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
	event.MesMake_2(0, "Salut, moi c'est Julia. \nJe suis ravie de te rencontrer.")
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
	event.MesMake_2(
		0,
		"Merci, Max. Je n'ai pas oubli[UNI00e9] ma\npromesse. Tu pourras utiliser mes\nnouveaux pouvoirs quand tu veux."
	)
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
	helper_3c1ac()
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
local function helper_3dec4(arg0: s32, arg1: any)
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
				"Je suppose qu'une fille ne pourrait\ncomprendre les raisons qui poussent\nun homme [UNI00e0] poursuivre ses id[UNI00e9]aux."
			)
		else
			event.MesMake_2(0, "N'h[UNI00e9]site pas [UNI00e0] utiliser mes\nnouveaux pouvoirs quand tu le\nvoudras.")
		end
	else
		event.MesMake_2(
			0,
			"Peindre des portraits est un art\ncomplexe. Le ma[UNI00ee]triser prend toute\nune vie, mais [UNI00e7]a en vaut la peine."
		)
	end
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_3e274(arg0: s32)
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
		helper_39a2c(arg0, player_chara)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_3c03c(arg0, player_chara)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_3c360(arg0, player_chara)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_3dec4(arg0, player_chara)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_121bc(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Humm, cet arbre... Il ne va pas\nbien. Je dois faire quelque chose.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		event.MesMake_2(
			0,
			"Oh, Max ! Tu m'as fait peur.\nJ'[UNI00e9]tais en train de traiter\ncet arbre contre les insectes.<page>Certains arbres poussent mal, tu\nsais. Il y en a, comme lui, qui\nont vraiment besoin de soins."
		)
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_14354(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_121bc(arg0, arg1)
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
		helper_121bc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_8ecb6320(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_a7d6a00a(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_45d8a369(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_36d78(arg0: s32, arg1: s32)
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
				helper_14354(arg0, arg1)
			end
			if at <= 2 then
				helper_a20cf492(arg0, arg1)
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
				helper_3ca59f4a(arg0, arg1)
			end
			if at <= 14 then
				helper_739136b8(arg0, arg1)
			end
			if at <= 15 then
				helper_63e5aa4a(arg0, arg1)
			end
			if at <= 16 then
				helper_fc3f289b(arg0, arg1)
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
				helper_315f4039(arg0, arg1)
			end
			if at <= 21 then
				helper_28d822c1(arg0, arg1)
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
				helper_303fddce(arg0, arg1)
			end
			if at <= 26 then
				helper_8e16dcbe(arg0, arg1)
			end
			if at <= 27 then
				helper_992b27d9(arg0, arg1)
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
				helper_c9cddfe6(arg0, arg1)
			end
			if at <= 32 then
				helper_7b1ef108(arg0, arg1)
			end
			if at <= 33 then
				helper_5676a4a9(arg0, arg1)
			end
			if at <= 34 then
				helper_9901a709(arg0, arg1)
			end
			if at <= 35 then
				helper_ac3d3596(arg0, arg1)
			end
			if at <= 36 then
				helper_11dbc26a(arg0, arg1)
			end
			if at <= 37 then
				helper_3c72acc5(arg0, arg1)
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
		helper_14354(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 5 then
		helper_a20cf492(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Je veux faire des achats\nC'est parti pour un scoop")
			var7 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(4)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_10262c1a(0)
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
				helper_8fa5bfff()
				if vm.skipping() then
					return skip(8)
				end
			end
		else
			event.MesMake_2(0, "En route pour l'aventure ?\nC'est parti pour un scoop")
			var8 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(9)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_10262c1a(0)
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
				helper_7f145e10(arg0, arg1)
				if vm.skipping() then
					return skip(13)
				end
			end
		end
	end
	if var3 == 7 then
		helper_3ca59f4a(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 8 then
		helper_739136b8(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 10 then
		helper_63e5aa4a(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 11 then
		helper_fc3f289b(arg0, arg1)
		if vm.skipping() then
			return skip(17)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var11 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(18)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_315f4039(arg0, arg1)
				if vm.skipping() then
					return skip(19)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_8fa5bfff()
			if vm.skipping() then
				return skip(20)
			end
		else
			helper_315f4039(arg0, arg1)
			if vm.skipping() then
				return skip(21)
			end
		end
	end
	if var3 == 14 then
		helper_28d822c1(arg0, arg1)
		if vm.skipping() then
			return skip(22)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var14 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(23)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_303fddce(arg0, arg1)
				if vm.skipping() then
					return skip(24)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_8fa5bfff()
			if vm.skipping() then
				return skip(25)
			end
		else
			helper_303fddce(arg0, arg1)
			if vm.skipping() then
				return skip(26)
			end
		end
	end
	if var3 == 16 then
		helper_8e16dcbe(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 17 then
		helper_992b27d9(arg0, arg1)
		if vm.skipping() then
			return skip(28)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var17 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(29)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_c9cddfe6(arg0, arg1)
				if vm.skipping() then
					return skip(30)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_8fa5bfff()
			if vm.skipping() then
				return skip(31)
			end
		else
			helper_c9cddfe6(arg0, arg1)
			if vm.skipping() then
				return skip(32)
			end
		end
	end
	if var3 == 19 then
		helper_7b1ef108(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 20 then
		helper_5676a4a9(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 21 then
		helper_9901a709(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 23 then
		helper_ac3d3596(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 24 then
		helper_11dbc26a(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 25 then
		helper_3c72acc5(arg0, arg1)
		if vm.skipping() then
			return skip(38)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Je veux faire des achats\nBonjour")
			var20 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(39)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_30377d3f(arg0, arg1)
				if vm.skipping() then
					return skip(40)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_8fa5bfff()
		if vm.skipping() then
			return skip(41)
		end
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"J'ai du mal depuis quelque temps [UNI00e0]\nvoir les toutes petites pi[UNI00e8]ces.<page>Je dois commencer [UNI00e0] me\nfaire un peu vieux..."
			)
		else
			event.MesMake_2(
				0,
				"Revoir le chemin de fer Noirpierre\ntraverser tout le continent est un\nr[UNI00ea]ve que Need et moi partageons.<page>On peut compter sur ton aide, hein ?"
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
			event.MesMake_2(0, "Quand je n'ai rien\n[UNI00e0] faire, je deviens de\nmauvaise humeur.")
		else
			event.MesMake_2(
				0,
				"S'ils d[UNI00e9]couvrent de la zelmite, je\nserai tr[UNI00e8]s occup[UNI00e9] moi aussi. Ouais,\nje vais creuser jour et nuit !!!"
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
			event.MesMake_2(
				0,
				"Tu sais, j'ai plein de bestioles\ndans les plumes en ce moment,\net [UNI00e7]a me gratte terriblement."
			)
		else
			event.MesMake_2(
				0,
				"Tu peux passer ton temps [UNI00e0] chercher\nde la zelmite si tu veux. Mais fais\nattention [UNI00e0] toi, gamin."
			)
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
				"J'adore l'odeur de la poudre [UNI00e0]\ncanon ! C'est un boulot id[UNI00e9]al.<page>Malheureusement, j'ai un patron\ntr[UNI00e8]s ent[UNI00ea]t[UNI00e9] et vieille [UNI00e9]cole.\nM'enfin."
			)
		else
			event.MesMake_2(0, "[UNI00c7]a t'emballe vraiment cette\naventure, hein ?")
		end
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(45)
		end
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"[UNI00c0] part le fait que j'ai d[UNI00e9]but[UNI00e9]\nma vie sur une toile, je ne\nsuis pas diff[UNI00e9]rente des autres."
			)
		else
			event.MesMake_2(0, "Cette Mine de zelmite ne m'inspire\npas confiance. Sois prudent, OK ?")
		end
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(46)
		end
	end
	event.SetAi(1, arg0)
end

--- Helper function.
local function helper_398b0()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_36d78(var1, player_chara)
		end
		if at <= 2 then
			helper_67b76682()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_36d78(var1, player_chara)
		if vm.skipping() then
			return skip(2)
		end
	else
		helper_67b76682()
		if vm.skipping() then
			return skip(3)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = helper_3e6f0

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 400.
script[400] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3e5d8(0)
			helper_7d9a42e5(1)
		end
	end
	event.SetMotion(0, "立ち")
	flag = event.GetFlag(37) or flag
	if flag == 0 then
		event.SetFlag(37, 1)
		event.AddItem(243, 20)
		helper_cee58859(243, 20)
		if vm.skipping() then
			return skip(1)
		end
		helper_3e5d8(0)
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
			helper_398b0()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 == 5 then
		var1 = event.GetEventData_2(13) or var1
		event.CtrlcStay()
		event.SetAi(0, var1)
		helper_3e274(var1)
		if vm.skipping() then
			return skip(1)
		end
		event.SetAi(1, var1)
	else
		helper_398b0()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return script
