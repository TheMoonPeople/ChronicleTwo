--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_5419c2ac(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f1049565(arg0, -1, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMotion(arg1, "立ち")
		event.MesMake_2(0, "Humm, cet arbre... Il ne va pas\nbien. Je dois faire quelque chose.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(1)
		end
	else
		event.MesMake_2(
			0,
			"Oh, Max ! Tu m'as fait peur.\nJ'[UNI00e9]tais en train de traiter\ncet arbre contre les insectes.<page>Certains arbres poussent mal, tu\nsais. Il y en a, comme lui, qui\nont vraiment besoin de soins."
		)
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_5419c2ac
