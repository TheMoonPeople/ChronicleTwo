--!strict
-- Shared event helper used by 30 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c0a48915 = require("@lib/event/helper_c0a48915")

--- Helper function.
local function helper_6f70f976(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_c0a48915(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_c0a48915(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

return helper_6f70f976
