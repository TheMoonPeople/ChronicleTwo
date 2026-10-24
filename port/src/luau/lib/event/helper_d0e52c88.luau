--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_d0e52c88()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var0 = 0
		var0 = var0 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = 0
	while var0 < 16 do
		event.DeleteChara(8 + var0)
		var0 = var0 + 1
	end
	event.DelImg(0)
	event.SphidaInit()
end

return helper_d0e52c88
