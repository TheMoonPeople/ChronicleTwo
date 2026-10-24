--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_94e331d8()
	local var0: s32 = 0
	var0 = 8
	while var0 < 20 do
		event.DeleteChara(var0)
		event.DeleteVillager(var0)
		var0 = var0 + 1
		vm.wait(1)
	end
end

return helper_94e331d8
