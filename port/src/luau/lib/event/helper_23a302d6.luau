--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25fa8123 = require("@lib/event/helper_25fa8123")

--- Helper function.
local function helper_23a302d6(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_25fa8123(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_25fa8123(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

return helper_23a302d6
