--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_2a6dae0f()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(5, "立ち", 4)
	event.ObjsSetMotion(6, "立ち", 4)
	event.ObjsSetMotion(7, "歩き", 4)
	event.ObjsSetMotion(8, "走り", 4)
	event.ObjsSetMotion(9, "座り", 4)
	event.ObjsSetMotion(10, "歩き", 4)
end

return helper_2a6dae0f
