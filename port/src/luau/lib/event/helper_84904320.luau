--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47171f2d = require("@lib/event/helper_47171f2d")

--- Helper function.
local function helper_84904320(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Hai fatto qualche nuova scoperta?<page>Sai, mentre tu fai esperimenti\nsu macchine e strumenti,\nio faccio esperimenti di cucina.<page>Ogni giorno provo dei\npiatti deliziosi, che nessuno\nha mai assaggiato prima."
	)
	helper_47171f2d(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_84904320
