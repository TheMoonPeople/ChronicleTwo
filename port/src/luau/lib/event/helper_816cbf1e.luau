--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9ee707cc = require("@lib/event/helper_9ee707cc")

--- Helper function.
local function helper_816cbf1e(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_9ee707cc(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_9ee707cc(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

return helper_816cbf1e
