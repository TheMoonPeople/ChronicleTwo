--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_fc028319(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.MesMake_2(0, "Oh, hallo, junge Dame.\nKann ich etwas f[UNI00fc]r dich tun?")
		else
			event.MesMake_2(0, "Max, erz[UNI00e4]hl deinem Vater\nnichts von dem Weihwasser, ja?")
		end
	else
		event.MesMake_2(0, "Es muss so viele Pflanzen geben,\ndie wir noch nie gesehen haben.")
	end
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_fc028319
