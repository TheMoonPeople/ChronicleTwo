--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_30c30f62 = require("@lib/event/helper_30c30f62")

--- Helper function.
local function helper_b25ca4bc(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.MesMake_2(0, "Oh, salve, signorina.\nPosso fare qualcosa per lei?")
		else
			event.MesMake_2(0, "Max, non fare parola a tuo padre\ndi quell'Acqua sacra, capito?")
		end
	else
		event.MesMake_2(0, "Chiss[UNI00e0] quante piante l[UNI00e0] fuori,\nche non abbiamo ancora visto!")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_b25ca4bc
