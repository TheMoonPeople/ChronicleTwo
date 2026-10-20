--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_cc7603b9 = require("@lib/event/helper_cc7603b9")

--- Helper function.
local function helper_5cb21b5c()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_cc7603b9(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "あいてむまちがい")
	helper_cc7603b9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_5cb21b5c
