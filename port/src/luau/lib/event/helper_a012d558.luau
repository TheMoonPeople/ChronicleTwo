--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")

--- Helper function.
local function helper_a012d558(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"L'[UNI00e9]clat d'une [UNI00e9]p[UNI00e9]e forg[UNI00e9]e\npar un ma[UNI00ee]tre est magnifique.<page>[UNI00c0] couper le souffle."
		)
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Je n'arrive pas [UNI00e0] comprendre\ncomment on peut [UNI00ea]tre heureux [UNI00e0]\npolir des cailloux."
		)
	else
		event.MesMake_2(0, "Alors, t'as un scoop ? T'as\nvu des gros durs dans cette mine ?")
	end
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

return helper_a012d558
