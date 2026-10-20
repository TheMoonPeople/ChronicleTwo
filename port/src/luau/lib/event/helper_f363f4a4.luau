--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_81254767 = require("@lib/event/helper_81254767")

--- Helper function.
local function helper_f363f4a4()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_81254767(2)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_81254767(2)
end

return helper_f363f4a4
