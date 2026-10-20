--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0f1a8d4c = require("@lib/event/helper_0f1a8d4c")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")

--- Helper function.
local function helper_976c81cd(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				var3 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 6 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			return
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
			helper_b0211f82(30)
		end
		if at <= 13 then
			helper_b0211f82(30)
		end
		if at <= 14 then
			helper_b0211f82(60)
		end
		if at <= 15 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "[UNI00a1]Max! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	else
		event.MesMake_2(0, "[UNI00a1]M[UNI00f3]nica! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	end
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "[UNI00a1]Qu[UNI00e9] bien! [UNI00bf]Por qu[UNI00e9] no\nme llevas contigo?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Seguro que piensas que\nno valdr[UNI00e9] para nada porque soy una chica.<page>Pues la verdad es que\ntraigo suerte a la gente."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Nunca llueve cuando salgo\ny nunca he visto ning[UNI00fa]n\nbillete de loter[UNI00ed]a perdedor.<page>[UNI00bf]Qu[UNI00e9] me dices?"
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Est[UNI00e1] bien.\nNo, lo siento.")
	var3 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "会話")
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var3 ~= 0 then
		event.MesMake_2(0, "[UNI00a1][UNI00bf]Por qu[UNI00e9]?! No seas as[UNI00ed].\nEres muy mala.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "[UNI00a1]Eres una in[UNI00fa]til!<page>[UNI00a1]Est[UNI00fa]pida!<page>[UNI00a1]Idiota!")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "[UNI00bf]Me vas a llevar contigo?<page>[UNI00a1]Cre[UNI00ed]a que no lo har[UNI00ed]as!")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Por qu[UNI00e9] soy yo la [UNI00fa]nica\nque tiene que ped[UNI00ed]rtelo, cuando t[UNI00fa] has ido\npor ah[UNI00ed] preguntando a los dem[UNI00e1]s?<page>Si me lo hubieras pedido, te\nhabr[UNI00ed]a ayudado."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "Ya lo s[UNI00e9]: si me encuentras,\nte ayudar[UNI00e9]. [UNI00bf]Qu[UNI00e9] te parece?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "En otras palabras: [UNI00a1]vamos a jugar al escondite!<page>[UNI00a1]Venga, vamos!")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMotion(arg0, "立ち")
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(13)
	end
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.SetFadeIn(30)
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Vaya... Ser[UNI00e1] mejor que te pongas\na buscar a Corinne. Seguramente estar[UNI00e1] escondida\nen alg[UNI00fa]n lugar de Palm Brinks."
	)
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 18, 1)
	event.SetCnt(11, 0)
end

return helper_976c81cd
