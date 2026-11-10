--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_6033d0e7()
	monster.call_command(142) -- retail: command 142 is not registered
	while true do
		vm.wait()
	end
end

return helper_6033d0e7
