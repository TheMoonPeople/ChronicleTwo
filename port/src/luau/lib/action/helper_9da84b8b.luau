--!strict
-- Shared action helper used by 24 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_9da84b8b()
	local result: s32 = 0
	while true do
		vm.wait()
		result = vm.float_bits(action.CheckMosEnd()) or result
		if result ~= 0 then
			return
		end
	end
end

return helper_9da84b8b
