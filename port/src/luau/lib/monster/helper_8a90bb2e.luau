--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_8a90bb2e()
	local var0: s32 = 0
	monster.call_command(127) -- retail: the handler rejects 0 arguments
	monster.set_scene_character_status(var0) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	while var0 > 0 do
		monster.set_scene_character_status(var0) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		vm.wait()
	end
end

return helper_8a90bb2e
