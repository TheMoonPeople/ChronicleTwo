--!strict
-- Shared monster helper used by 100 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_193f5239()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

return helper_193f5239
