--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47171f2d = require("@lib/event/helper_47171f2d")
local helper_89c1e652 = require("@lib/event/helper_89c1e652")

--- Helper function.
local function helper_0282f3fd(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_89c1e652(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(
			0,
			"Je n'y crois pas. Je n'ai jamais\nvraiment cru que tu les trouverais.<page>T'as fait tr[UNI00e8]s fort Max !"
		)
	else
		event.MesMake_2(
			0,
			"H[UNI00e9] ! Alors, cette chasse [UNI00e0] la\nzelmite ? Si je peux faire quoi\nque ce soit, appelle-moi."
		)
	end
	helper_47171f2d(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_0282f3fd
