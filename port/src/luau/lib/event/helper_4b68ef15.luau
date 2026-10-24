--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f15cf235 = require("@lib/event/helper_f15cf235")

--- Helper function.
local function helper_4b68ef15(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_f15cf235(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_f15cf235(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

return helper_4b68ef15
