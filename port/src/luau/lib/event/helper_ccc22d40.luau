--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_97c4bcbc = require("@lib/event/helper_97c4bcbc")

--- Helper function.
local function helper_ccc22d40(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_97c4bcbc(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_97c4bcbc(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

return helper_ccc22d40
