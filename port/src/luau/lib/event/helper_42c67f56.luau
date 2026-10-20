--!strict
-- Shared event helper used by 45 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_eb8a25b8 = require("@lib/event/helper_eb8a25b8")

--- Helper function.
local function helper_42c67f56(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb8a25b8(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_eb8a25b8(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_42c67f56
