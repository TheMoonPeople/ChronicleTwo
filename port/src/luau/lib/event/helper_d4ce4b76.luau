--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b33603c6 = require("@lib/event/helper_b33603c6")

--- Helper function.
local function helper_d4ce4b76(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b33603c6(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Alors tu m'as vue au cirque ?\nC'[UNI00e9]tait pas mal, non ?<page>Mais ce n'est pas vraiment un\nboulot, plut[UNI00f4]t un passe-temps."
		)
	else
		event.MesMake_2(0, "Alors, t'as un scoop ? T'as\nvu des gros durs dans cette mine ?")
	end
	helper_b33603c6(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_d4ce4b76
