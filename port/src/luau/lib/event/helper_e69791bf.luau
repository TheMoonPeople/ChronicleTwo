--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7b802fd2 = require("@lib/event/helper_7b802fd2")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_e69791bf(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_7b802fd2(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.MesMake_2(0, "Pero no me lleves\na ning[UNI00fa]n sitio demasiado peligroso.")
	else
		event.MesMake_2(
			0,
			"Por fin, el Ferrocarril\nBlackstone conquista el mundo.\n[UNI00a1]Qu[UNI00e9] emoci[UNI00f3]n!"
		)
	end
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_e69791bf
