--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9660e7cc = require("@lib/event/helper_9660e7cc")

--- Helper function.
local function helper_93ec22ce()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_9660e7cc(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_9660e7cc(1)
end

return helper_93ec22ce
