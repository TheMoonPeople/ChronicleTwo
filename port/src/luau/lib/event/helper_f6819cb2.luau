--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2b963b7e = require("@lib/event/helper_2b963b7e")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")

--- Helper function.
local function helper_f6819cb2(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				var3 = helper_2b963b7e(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 6 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 9 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_ed0a80b8(30)
		end
		if at <= 13 then
			helper_ed0a80b8(30)
		end
		if at <= 14 then
			helper_ed0a80b8(60)
		end
		if at <= 15 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "Ooh, Max! Ich hab geh[UNI00f6]rt, du\nhast die Stadt letztens verlassen.")
	else
		event.MesMake_2(0, "Ooh, Monica! Ich hab geh[UNI00f6]rt, du\nhast die Stadt letztens verlassen.")
	end
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Das ist toll! Warum nimmst\ndu mich nicht mit?")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Du denkst bestimmt, ich bin nutzlos,\nweil ich ein M[UNI00e4]dchen bin.<page>Aber ich bringe den Leuten\nimmer viel Gl[UNI00fc]ck."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Wenn ich unterwegs bin, regnet\nes nie, und eine Los-Niete hab\nich noch nie gesehen.<page>Was meinst du?"
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Na gut.\nNein, tut mir Leid.")
	var3 = helper_2b963b7e(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "会話")
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var3 ~= 0 then
		event.MesMake_2(0, "Was? Sei nicht gemein!\nDu bist so fies!")
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "Du bist bl[UNI00f6]d!<page>Du Dummkopf!<page>Du Idiot!")
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Du nimmst mich mit?<page>Das h[UNI00e4]tte ich nicht gedacht!")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"Aber warum muss ich als Einzige\nfragen, wenn du all die anderen\nselbst um Hilfe bittest?<page>Wenn du einfach gefragt h[UNI00e4]ttest,\nh[UNI00e4]tte ich nat[UNI00fc]rlich geholfen."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "Ich wei[UNI00df] - wenn du mich findest,\nhelf ich dir. Abgemacht?")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "Mit anderen Worten, wir\nspielen  Verstecken!<page>Gut, los geht's!")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMotion(arg0, "立ち")
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(13)
	end
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.SetFadeIn(30)
	helper_ed0a80b8(60)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Na ja ... Du versuchst wohl besser,\n   Corinne zu finden. Sie hat sich\n   bestimmt in Palm Brinks versteckt."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 18, 1)
	event.SetCnt(11, 0)
end

return helper_f6819cb2
