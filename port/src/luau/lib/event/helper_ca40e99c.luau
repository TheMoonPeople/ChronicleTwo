--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_ca40e99c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f1049565(arg0, -1, 0, 0)
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
			"Ich mag eigentlich keine Frauen,\ndie mit Schwertern wedeln.<page>Die besten Frauen sind die\ndamenhaften. Adel zum Beispiel."
		)
	else
		event.MesMake_2(0, "Falls ich dir irgendwie helfen\nkann, frag mich ruhig.")
	end
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_ca40e99c
