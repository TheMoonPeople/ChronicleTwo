--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c43045c = require("@lib/event/helper_1c43045c")
local helper_96c5d43c = require("@lib/event/helper_96c5d43c")

--- Helper function.
local function helper_a3ef4d83()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_96c5d43c(1, 7)
		helper_1c43045c(1, -1, 15, 0, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_96c5d43c(1, 7)
	event.SetMesPreset(1, 2)
	event.MesMake_2(1, "Si ferma con il pulsante (O).")
	helper_1c43045c(1, -1, 15, 0, 0)
end

return helper_a3ef4d83
