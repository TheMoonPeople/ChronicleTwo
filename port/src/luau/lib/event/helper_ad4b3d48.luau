--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_89c1e652 = require("@lib/event/helper_89c1e652")
local helper_938567df = require("@lib/event/helper_938567df")
local helper_e5219064 = require("@lib/event/helper_e5219064")
local helper_eb560126 = require("@lib/event/helper_eb560126")
local helper_f39cfbfe = require("@lib/event/helper_f39cfbfe")

--- Helper function.
local function helper_ad4b3d48(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				var5 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 5 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			helper_938567df()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_89c1e652(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(201) or argc
	argc_2 = event.GetItemNum(202) or argc_2
	if argc <= 0 or argc_2 <= 0 then
		event.MesMake_2(
			0,
			"Quoi ? Ah, les pi[UNI00e8]ces de monnaie ?<page>Je cherche la Pi[UNI00e8]ce de sacrifice\net la Pi[UNI00e8]ce de solidit[UNI00e9].<page>Tu ne les trouveras jamais, j'ai\nd[UNI00e9]j[UNI00e0] cherch[UNI00e9] partout."
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Quoi ? Tu les as ? Incroyable !<page>Allez vite, donne-les-moi !")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Bon.\nQu'est-ce que je dois faire ?")
	var5 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "Aaah ! Si tu me casses les pieds,\nje ne t'aiderai certainement pas.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(201)
	event.SubItem(202)
	event.MesMake_2(
		0,
		"Ouaah, je les ai toutes !\nJe n'y croyais plus...<page>Bon, je n'ai plus le choix hein ?\nJe vais venir avec toi !"
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_938567df()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 2, 1)
end

return helper_ad4b3d48
