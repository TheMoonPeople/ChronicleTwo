--!strict
-- map/i/i04/h03/i04h03_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0bd3c03c = require("@lib/event/helper_0bd3c03c")
local helper_0f1a8d4c = require("@lib/event/helper_0f1a8d4c")
local helper_126faf7c = require("@lib/event/helper_126faf7c")
local helper_39ba0aea = require("@lib/event/helper_39ba0aea")
local helper_4005e7b5 = require("@lib/event/helper_4005e7b5")
local helper_4aab852b = require("@lib/event/helper_4aab852b")
local helper_5e2967c9 = require("@lib/event/helper_5e2967c9")
local helper_5ea3294d = require("@lib/event/helper_5ea3294d")
local helper_641f9f31 = require("@lib/event/helper_641f9f31")
local helper_739ca91d = require("@lib/event/helper_739ca91d")
local helper_7b7fe6bb = require("@lib/event/helper_7b7fe6bb")
local helper_7d9a42e5 = require("@lib/event/helper_7d9a42e5")
local helper_82dc4325 = require("@lib/event/helper_82dc4325")
local helper_8d3cdccb = require("@lib/event/helper_8d3cdccb")
local helper_9594a5b1 = require("@lib/event/helper_9594a5b1")
local helper_962f3c56 = require("@lib/event/helper_962f3c56")
local helper_992dd0e6 = require("@lib/event/helper_992dd0e6")
local helper_9c262623 = require("@lib/event/helper_9c262623")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_aa921c33 = require("@lib/event/helper_aa921c33")
local helper_ac846ee4 = require("@lib/event/helper_ac846ee4")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_b1182e01 = require("@lib/event/helper_b1182e01")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_bafdd0ef = require("@lib/event/helper_bafdd0ef")
local helper_bb8f5e71 = require("@lib/event/helper_bb8f5e71")
local helper_bd9165c4 = require("@lib/event/helper_bd9165c4")
local helper_cd830e03 = require("@lib/event/helper_cd830e03")
local helper_cee58859 = require("@lib/event/helper_cee58859")
local helper_d0ac0f9c = require("@lib/event/helper_d0ac0f9c")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")
local helper_d8d161f8 = require("@lib/event/helper_d8d161f8")
local helper_db875567 = require("@lib/event/helper_db875567")
local helper_ee2fed44 = require("@lib/event/helper_ee2fed44")
local helper_f016ef9c = require("@lib/event/helper_f016ef9c")
local helper_f1049565 = require("@lib/event/helper_f1049565")
local helper_f28d0616 = require("@lib/event/helper_f28d0616")

--- Helper function.
local function helper_3dff8(arg0: s32)
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
local function helper_3e110()
	local flag: s32 = 0
	flag = event.GetFlag(37) or flag
	helper_3dff8(if flag == 0 then 1 else 0)
end

--- Helper function.
local function helper_3949c(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Hola.\n[UNI00bf]M[UNI00f3]nica, no?")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Soy Parn.\nSoy un artista m[UNI00e1]gico.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Oye, Max.<page>[UNI00bf]C[UNI00f3]mo es que siempre tienes buen aspecto?")
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_39898(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Hola.\n[UNI00bf]M[UNI00f3]nica, no?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Soy Parn.\nSoy un artista m[UNI00e1]gico.")
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
	event.MesMake_2(0, "No os he presentado todav[UNI00ed]a, [UNI00bf]no?<page>Esta es Julia, mi futura mujer.")
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
		"[(!)]A M[UNI00f3]nica no se le dan muy bien\nestas situaciones. Podr[UNI00ed]a lograr algo,\npero es probable que no lo haga. Prueba m[UNI00e1]s tarde con Max."
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
local function helper_3a5cc(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Hola, Max.")
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
	event.MesMake_2(0, "No os he presentado todav[UNI00ed]a, [UNI00bf]no?<page>Esta es Julia, mi futura mujer.")
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
		"Puedes re[UNI00ed]rte lo que quieras.\nYa s[UNI00e9] que es raro.<page>[UNI00bf]Qui[UNI00e9]n se enamorar[UNI00ed]a de\nun retrato?"
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"Pero soy un artista m[UNI00e1]gico.\nTengo el poder de convertir en realidad las cosas que pinto.<page>Todo lo que pinto existe en el cuadro verdaderamente.\nA menos que se trate de un ser vivo..."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "Ni siquiera un artista m[UNI00e1]gico puede pintar vida.")
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
	event.MesMake_2(
		0,
		"Aunque he o[UNI00ed]do que existe una forma.\nHay un Huevo dorado en un [UNI00e1]rbol grande y viejo."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Se cuenta que con el color dorado\nse puede dar vida a cualquier cosa que pintes.")
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
		"Max, tengo entendido que\nte marchas de la ciudad, [UNI00bf]no?<page>[UNI00bf]Podr[UNI00ed]as traerme algo de Pintura dorada?"
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.MesMake_2(
		0,
		"Por supuesto que no espero que lo hagas a cambio de nada.<page>Si me ayudas, usar[UNI00e9]\nmi nuevo poder para devolverte el favor."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Un [UNI00e1]rbol grande y viejo...\n [UNI00a1]Con un Huevo dorado! [UNI00bf]Y d[UNI00f3]nde se supone\nque hay algo as[UNI00ed]?"
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
local function helper_3bb3c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_39898(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	helper_3a5cc(arg0, arg1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetQuestEtc(0, 1, 1)
end

--- Helper function.
local function helper_3bcac()
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
	event.MesMake_2(1, "Julia se ha unido a tu grupo.\nJulia ha subido al tren.")
	helper_d1353c5b(1, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_3be50(arg0: s32, arg1: s32)
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
			helper_3bcac()
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
			"Las chicas no deben de entender\npor qu[UNI00e9] los hombres necesitan\nperseguir sus ideales."
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
	event.MesMake_2(0, "Te he estado esperando.<page>R[UNI00e1]pido, dame la Pintura para\ndar vida a mi cuadro.")
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
			"[UNI00a1]Est[UNI00e1]s de broma!<page>Lo que necesito es Pintura dorada.\n[UNI00a1]No te equivoques!"
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
	event.MesMake_2(0, "O sea que esta es la Pintura dorada...\nLa probar[UNI00e9] ahora mismo.")
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
	event.MesMake_2(0, "Es... Es real...<page>[UNI00a1]Incre[UNI00ed]ble, es perfecta!")
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
	event.MesMake_2(0, "Hola, soy Julia.\nEs un placer conoceros.")
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
	event.MesMake_2(0, "Gracias, Max.\nNo he olvidado mi promesa. Usa mi\nnuevo poder cuando quieras.")
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
	helper_3bcac()
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
local function helper_3d934(arg0: s32, arg1: any)
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
				"Las chicas no deben de entender\npor qu[UNI00e9] los hombres necesitan\nperseguir sus ideales."
			)
		else
			event.MesMake_2(0, "Usa mi nuevo poder\ncuando quieras.")
		end
	else
		event.MesMake_2(
			0,
			"El mundo de la pintura es muy profundo.\nPuede que me lleve toda una vida dominarlo,\npero el trayecto bien vale la pena."
		)
	end
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_3dc94(arg0: s32)
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
		helper_3949c(arg0, player_chara)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_3bb3c(arg0, player_chara)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_3be50(arg0, player_chara)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_3d934(arg0, player_chara)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_1221c(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Umm. Este [UNI00e1]rbol... Le pasa\nalgo. Tengo que hacer algo.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		event.MesMake_2(
			0,
			"[UNI00a1]Max! Qu[UNI00e9] susto.\nEstaba quit[UNI00e1]ndole los bichos\na este [UNI00e1]rbol.<page>No todos los [UNI00e1]rboles crecen bien\nsolos. A algunos, como\neste, hay que vigilarlos."
		)
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_14324(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1221c(arg0, arg1)
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
		helper_1221c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_d0ac0f9c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_bafdd0ef(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_739ca91d(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_36858(arg0: s32, arg1: s32)
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
				helper_14324(arg0, arg1)
			end
			if at <= 2 then
				helper_5ea3294d(arg0, arg1)
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
				helper_9c262623(arg0, arg1)
			end
			if at <= 14 then
				helper_f28d0616(arg0, arg1)
			end
			if at <= 15 then
				helper_4aab852b(arg0, arg1)
			end
			if at <= 16 then
				helper_b1182e01(arg0, arg1)
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
				helper_bd9165c4(arg0, arg1)
			end
			if at <= 21 then
				helper_aa921c33(arg0, arg1)
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
				helper_39ba0aea(arg0, arg1)
			end
			if at <= 26 then
				helper_641f9f31(arg0, arg1)
			end
			if at <= 27 then
				helper_992dd0e6(arg0, arg1)
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
				helper_9594a5b1(arg0, arg1)
			end
			if at <= 32 then
				helper_cd830e03(arg0, arg1)
			end
			if at <= 33 then
				helper_962f3c56(arg0, arg1)
			end
			if at <= 34 then
				helper_ac846ee4(arg0, arg1)
			end
			if at <= 35 then
				helper_bb8f5e71(arg0, arg1)
			end
			if at <= 36 then
				helper_0bd3c03c(arg0, arg1)
			end
			if at <= 37 then
				helper_f016ef9c(arg0, arg1)
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
		helper_14324(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 5 then
		helper_5ea3294d(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "D[UNI00e9]jame comprar\nCavar buscando logros")
			var7 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(4)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_7b7fe6bb(0)
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
				helper_db875567()
				if vm.skipping() then
					return skip(8)
				end
			end
		else
			event.MesMake_2(0, "Hazte amigo m[UNI00ed]o\nCavar buscando logros")
			var8 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(9)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_7b7fe6bb(0)
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
				helper_8d3cdccb(arg0, arg1)
				if vm.skipping() then
					return skip(13)
				end
			end
		end
	end
	if var3 == 7 then
		helper_9c262623(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 8 then
		helper_f28d0616(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 10 then
		helper_4aab852b(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 11 then
		helper_b1182e01(arg0, arg1)
		if vm.skipping() then
			return skip(17)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var11 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(18)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_bd9165c4(arg0, arg1)
				if vm.skipping() then
					return skip(19)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_db875567()
			if vm.skipping() then
				return skip(20)
			end
		else
			helper_bd9165c4(arg0, arg1)
			if vm.skipping() then
				return skip(21)
			end
		end
	end
	if var3 == 14 then
		helper_aa921c33(arg0, arg1)
		if vm.skipping() then
			return skip(22)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var14 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(23)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_39ba0aea(arg0, arg1)
				if vm.skipping() then
					return skip(24)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_db875567()
			if vm.skipping() then
				return skip(25)
			end
		else
			helper_39ba0aea(arg0, arg1)
			if vm.skipping() then
				return skip(26)
			end
		end
	end
	if var3 == 16 then
		helper_641f9f31(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 17 then
		helper_992dd0e6(arg0, arg1)
		if vm.skipping() then
			return skip(28)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var17 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(29)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_9594a5b1(arg0, arg1)
				if vm.skipping() then
					return skip(30)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_db875567()
			if vm.skipping() then
				return skip(31)
			end
		else
			helper_9594a5b1(arg0, arg1)
			if vm.skipping() then
				return skip(32)
			end
		end
	end
	if var3 == 19 then
		helper_cd830e03(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 20 then
		helper_962f3c56(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 21 then
		helper_ac846ee4(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 23 then
		helper_bb8f5e71(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 24 then
		helper_0bd3c03c(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 25 then
		helper_f016ef9c(arg0, arg1)
		if vm.skipping() then
			return skip(38)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "D[UNI00e9]jame comprar\nHola")
			var20 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(39)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_82dc4325(arg0, arg1)
				if vm.skipping() then
					return skip(40)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_db875567()
		if vm.skipping() then
			return skip(41)
		end
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"[UNI00da]ltimamente lo he pasado\nmal viendo todas las peque[UNI00f1]as piezas.<page>Supongo que\nme estoy haciendo viejo..."
			)
		else
			event.MesMake_2(
				0,
				"Ver en funcionamiento el\nFerrocarril Blackstone por todo el continente es un\nsue[UNI00f1]o com[UNI00fa]n de Need y m[UNI00ed]o.<page>Podemos contar con tu ayuda, [UNI00bf]no?"
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
			event.MesMake_2(0, "Si no estoy ocupado\nen algo,\nme pongo de mal humor.")
		else
			event.MesMake_2(
				0,
				"Si descubren Zelmite me\nllegar[UNI00e1] el agua al cuello. S[UNI00ed].\n[UNI00a1][UNI00a1]Tendr[UNI00e9] que excavar y excavar sin parar!!"
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
				"No s[UNI00e9] por qu[UNI00e9], tengo tantos\nbichos en las plumas [UNI00fa]ltimamente\nque me pica todo."
			)
		else
			event.MesMake_2(
				0,
				"Est[UNI00e1] bien que pases el tiempo\nintentando encontrar Zelmite, pero\ntampoco exageres."
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
				"[UNI00a1]Me encanta el olor de la p[UNI00f3]lvora!\nEste trabajo est[UNI00e1] hecho para m[UNI00ed].<page>Aunque mi jefe\nes un cabez[UNI00f3]n anticuado.\nEn fin..."
			)
		else
			event.MesMake_2(0, "Te encanta toda esta\naventura, [UNI00bf]verdad?")
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
				"Aparte del hecho de que\nmi vida empez[UNI00f3] como cuadro, no soy diferente\na cualquier otra persona."
			)
		else
			event.MesMake_2(0, "La Mina de Zelmite me da mala espina.\nTen cuidado, [UNI00bf]vale?")
		end
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(46)
		end
	end
	event.SetAi(1, arg0)
end

--- Helper function.
local function helper_39320()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_36858(var1, player_chara)
		end
		if at <= 2 then
			helper_5e2967c9()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_36858(var1, player_chara)
		if vm.skipping() then
			return skip(2)
		end
	else
		helper_5e2967c9()
		if vm.skipping() then
			return skip(3)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = helper_3e110

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 400.
script[400] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dff8(0)
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
		helper_3dff8(0)
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
			helper_39320()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 == 5 then
		var1 = event.GetEventData_2(13) or var1
		event.CtrlcStay()
		event.SetAi(0, var1)
		helper_3dc94(var1)
		if vm.skipping() then
			return skip(1)
		end
		event.SetAi(1, var1)
	else
		helper_39320()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return script
