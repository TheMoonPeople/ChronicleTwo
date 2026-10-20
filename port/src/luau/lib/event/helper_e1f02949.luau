--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_e4c4390d = require("@lib/event/helper_e4c4390d")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_e1f02949(arg0: s32, arg1: s32)
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
			helper_e4c4390d(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(
			0,
			"I can't believe it. I never\nreally imagined you could get them.<page>That's really something, Max!"
		)
	else
		event.MesMake_2(0, "Hey! How goes the Zelmite hunt?\nIf there's anything I can do,\njust gimme a holler.")
	end
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_e1f02949
