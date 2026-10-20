--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6e932de7 = require("@lib/event/helper_6e932de7")

--- Helper function.
local function helper_8df18c7f(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	while true do
		if helper_6e932de7(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(1)
			end
		end
	end
end

return helper_8df18c7f
