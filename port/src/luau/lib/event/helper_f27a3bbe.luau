--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_f27a3bbe(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Alors, tu as fait des trouvailles ?<page>Tu sais, pendant que tu d[UNI00e9]couvres\nles rouages des machines,\nmoi, je d[UNI00e9]couvre la cuisine.<page>Chaque jour, je me perfectionne\ndans l'art de faire des plats\nd[UNI00e9]licieux et totalement in[UNI00e9]dits."
	)
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_f27a3bbe
