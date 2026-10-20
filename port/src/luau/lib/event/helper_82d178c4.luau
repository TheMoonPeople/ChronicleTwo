--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_30c30f62 = require("@lib/event/helper_30c30f62")

--- Helper function.
local function helper_82d178c4(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"...<page>Ah ! Bonjour !\nJe suis un peu dure d'oreille.<page>Je ne comprends pas ce qu'on me\ndit, sauf quand on parle lentement."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_82d178c4
