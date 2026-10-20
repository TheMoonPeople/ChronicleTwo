--!strict
-- Shared monster helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_f683d690()
	local var0: s32 = 0
	var0 = monster.GetMosStatus() or var0
	while var0 ~= 4 do
		vm.wait()
		var0 = monster.GetMosStatus() or var0
	end
end

return helper_f683d690
