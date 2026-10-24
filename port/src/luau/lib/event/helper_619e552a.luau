--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_c049c42a = require("@lib/event/helper_c049c42a")
local helper_dae2ac4c = require("@lib/event/helper_dae2ac4c")

--- Helper function.
local function helper_619e552a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_403f0e66(0, -1, arg1, arg0, 0)
			end
			return
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg1, arg0, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg1, arg0, 0)
		end
		if at <= 7 then
			helper_403f0e66(0, -1, arg1, arg0, 0)
		end
		if at <= 8 then
			helper_403f0e66(0, -1, arg1, arg0, 0)
		end
		if at <= 9 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Je ne suis pas tr[UNI00e8]s en forme.<page>Je ne peux pas partir en voyage.<page>Le Dr Dell est venu me voir, mais\nil m'a dit que tout allait bien."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Pourtant, quand je suis debout, j'ai\nl'impression que je vais tomber.<page>C'est dur [UNI00e0] expliquer. C'est un peu\ncomme si le monde avait [UNI00e9]t[UNI00e9] d[UNI00e9]form[UNI00e9]."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(
			0,
			"Mmm... Si le Dr Dell ne sait pas ce\nqui ne va pas, je ne vois pas bien\nce que je peux faire moi-m[UNI00ea]me..."
		)
		helper_403f0e66(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return
	end
	event.MesMake_2(0, "[UNI00c7]a me rappelle quelque chose.")
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[UNI00c0] l'[UNI00e9]poque o[UNI00f9] je suis n[UNI00e9], le\nmonde [UNI00e9]tait dans un [UNI00e9]tat d[UNI00e9]plorable,\navec un nombre incalculable de\ndistorsions temporelles."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Cela avait un impact sur les gens\n[UNI00e0] la sant[UNI00e9] fragile.<page>Les plus l[UNI00e9]gers avaient le tournis\net les plus lourds ne tenaient\nplus debout."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Tu es peut-[UNI00ea]tre particuli[UNI00e8]rement\nsensible [UNI00e0] ce genre de chose.<page>M[UNI00ea]me les rares distorsions qu'on\na ici suffisent [UNI00e0] t'affecter."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"Si on pouvait [UNI00e9]liminer les plus\nproches d'entre elles, tu te\nsentirais peut-[UNI00ea]tre mieux."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg1, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Comment [UNI00e9]liminer une distorsion...\n   Le Spheda ! Termine environ 10 niveaux\n   et Mena ira peut-[UNI00ea]tre mieux."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	var3 = event.GetMenuEtc_2(0) or var3
	event.SetCnt(19, var3)
	event.SetQuestEtc(0, 17, 1)
end

return helper_619e552a
