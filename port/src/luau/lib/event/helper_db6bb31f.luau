--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_92bb416f = require("@lib/event/helper_92bb416f")

--- Helper function.
local function helper_db6bb31f()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		local _ = if helper_92bb416f() == 0 then 1 else 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	if helper_92bb416f() == 0 then
		return 0
	end
	flag = event.GetFlag(748) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

return helper_db6bb31f
