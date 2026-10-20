--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b33603c6 = require("@lib/event/helper_b33603c6")

--- Helper function.
local function helper_98e665dd(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Il libro?\nVeramente, non l'ho ancora letto.<page>Il solo averlo mi ha\ncomunque reso felice."
		)
	else
		event.MesMake_2(
			0,
			"La Miniera di Zelmite [UNI00e8] un posto\nmolto pericoloso. Non si deve\nmai abbassare la guardia."
		)
	end
	helper_b33603c6(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_98e665dd
