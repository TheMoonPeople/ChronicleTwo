--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0010fcca = require("@lib/event/helper_0010fcca")

--- Helper function.
local function helper_6fd2ce25(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_0010fcca(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_0010fcca(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

return helper_6fd2ce25
