--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_1e96cfb3(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Hmm, dieser Baum ... sieht nicht\ngut aus. Ich muss etwas tun.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(1)
		end
	else
		event.MesMake_2(
			0,
			"Oh, Max! Du hast mich erschreckt.\nIch entferne gerade Ungeziefer von\ndiesem Baum.<page>Nicht alle B[UNI00e4]ume wachsen\nvon alleine gut. Manche\nmuss man gut pflegen, so wie diesen."
		)
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_1e96cfb3
