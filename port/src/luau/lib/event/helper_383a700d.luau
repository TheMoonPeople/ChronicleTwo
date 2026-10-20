--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")
local helper_d6d68a3a = require("@lib/event/helper_d6d68a3a")

--- Helper function.
local function helper_383a700d(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 4 then
			if at <= 2 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_d6d68a3a(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Max, soigner cet arbre est ma\ngrande priorit[UNI00e9].<page>Mais pour cela, il me\nfaudrait..."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.GotoUseItem(276)
	do
		local skipped = vm.wait()
		var3 = event.DeferredOutput() or var3
		if skipped then
			return skip(4)
		end
	end
	if var3 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var3 ~= 276 then
		event.MesMake_2(
			0,
			"Max, [UNI00e7]a ne marchera pas.<page>Ce qu'il me faut, c'est de l'Eau\nsacr[UNI00e9]e du P[UNI00e8]re Bruno."
		)
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Ouais ! Max tu as r[UNI00e9]ussi ! Je vais\npouvoir soigner cet arbre !<page>Merci, Max.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"J'ai fait tout ce que je devais\nfaire pour un bon moment.<page>Je peux donc t'accompagner dans\nton aventure !<page>Oh, et ne parle pas de cette eau\nsacr[UNI00e9]e [UNI00e0] ton p[UNI00e8]re, tu m'entends ?"
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "Gordon s'est joint [UNI00e0] ton aventure.")
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Tu peux utiliser ses talents\n   [UNI00e0] partir de la commande Statut, dans\n   Personnages (Menu principal).<page>[(!)]Si tu recrutes une autre\n   personne pour tes aventures,\n   celle-ci montera dans le train."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]Parle [UNI00e0] cette personne dans le\n   train pour en faire le 3e\n   membre de ton groupe.<page>[(!)]Pour d[UNI00e9]placer un ami du train\n   vers une maison, choisis Installer\n   quelqu'un (menu de la porte)."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"[(!)]Il est possible que d'autres personnes\n   souhaitent participer [UNI00e0] l'aventure.\n   Surtout, ne les manque pas !"
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	var4 = event.GetEventData_2(14) or var4
	event.SetNpcStatus(var4, 130)
	event.Finish()
	event.SetQuestEtc(1, 0, 1)
end

return helper_383a700d
