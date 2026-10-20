--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_aa50c07e = require("@lib/event/helper_aa50c07e")

--- Helper function.
local function helper_3735c566(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_aa50c07e(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_aa50c07e(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

return helper_3735c566
