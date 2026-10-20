--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")

--- Helper function.
local function helper_be50c541()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ed0a80b8(75)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.SetFadeIn(15)
	event.ObjsMove(0, 418.52, 0.01, 950.16, 75, 1)
	event.ObjsMove(1, 399.78, 0.0, 963.89, 75, 1)
	helper_ed0a80b8(75)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_be50c541
