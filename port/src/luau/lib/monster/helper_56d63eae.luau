--!strict
-- Shared monster helper used by 108 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_56d63eae()
	local var0: s32 = 0
	while true do
		vm.wait()
		var0 = monster.CheckMosEnd() or var0
		if var0 ~= 0 then
			return
		end
	end
end

return helper_56d63eae
