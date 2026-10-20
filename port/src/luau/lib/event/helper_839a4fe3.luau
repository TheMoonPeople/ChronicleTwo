--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47171f2d = require("@lib/event/helper_47171f2d")

--- Helper function.
local function helper_839a4fe3(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Differenzia sempre i rifiuti e\nportali fuori nei giorni giusti!")
	else
		event.MesMake_2(
			0,
			"Detto tra noi, [UNI00e8] bene che tu\nsappia che la Miniera di Zelmite [UNI00e8]\npericolosa. Non fare sciocchezze."
		)
	end
	helper_47171f2d(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_839a4fe3
