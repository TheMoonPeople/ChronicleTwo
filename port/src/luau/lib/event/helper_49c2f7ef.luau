--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_30c30f62 = require("@lib/event/helper_30c30f62")

--- Helper function.
local function helper_49c2f7ef(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Pense [UNI00e0] bien trier tes d[UNI00e9]chets et\n[UNI00e0] les jeter les bons jours, OK ?"
		)
	else
		event.MesMake_2(
			0,
			"Je voulais te dire... je sais que\nla Mine de zelmite est un endroit\ndangereux. Ne prends aucun risque."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_49c2f7ef
