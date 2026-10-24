--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_85ac39cd(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Le magasin est ferm[UNI00e9]. Tu dois donc\naller au magasin de mon p[UNI00e8]re. Cherche<page>les citrouilles, tu ne peux pas les\nrater. C'est en haut de la colline."
	)
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_85ac39cd
