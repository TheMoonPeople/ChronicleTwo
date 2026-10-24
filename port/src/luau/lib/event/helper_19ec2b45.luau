--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_dba6e90d = require("@lib/event/helper_dba6e90d")

--- Helper function.
local function helper_19ec2b45(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_dba6e90d(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_dba6e90d(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

return helper_19ec2b45
