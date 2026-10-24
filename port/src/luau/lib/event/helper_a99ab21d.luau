--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_67db741d = require("@lib/event/helper_67db741d")

--- Helper function.
local function helper_a99ab21d()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		local _ = if helper_67db741d() == 0 then 1 else 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	if helper_67db741d() == 0 then
		return 0
	end
	flag = event.GetFlag(744) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

return helper_a99ab21d
