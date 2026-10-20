--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2e56adcc = require("@lib/event/helper_2e56adcc")

--- Helper function.
local function helper_748ffd54(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_2e56adcc(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_2e56adcc(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

return helper_748ffd54
