--!strict
-- Shared event helper used by 77 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6e932de7 = require("@lib/event/helper_6e932de7")

--- Helper function.
local function helper_c956b4a2(arg0: s32)
	while true do
		if helper_6e932de7(arg0) ~= 0 then
			break
		else
			vm.wait(1)
		end
	end
end

return helper_c956b4a2
