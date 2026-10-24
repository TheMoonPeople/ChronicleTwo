--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7f75e08e = require("@lib/event/helper_7f75e08e")
local helper_9e2fef46 = require("@lib/event/helper_9e2fef46")

--- Helper function.
local function helper_6ced5d9e(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f75e08e(30)
		end
		if at <= 2 then
			helper_9e2fef46()
		end
		if at <= 3 then
			helper_7f75e08e(20)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(30)
	helper_7f75e08e(30)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "上見立ち", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(1, "腰に手", 4)
	event.ObjsSetMotion(2, "斜め向き立ち", 4)
	event.ObjsSetMotion(3, "石炭", 4)
	event.CmrsMove2(41.03, 65.52, -72.49, 1.22, 60.93, 25.12, 60, 0, 1.0)
	helper_9e2fef46()
	if vm.skipping() then
		return skip(3)
	end
	helper_7f75e08e(20)
	if vm.skipping() then
		return skip(4)
	end
end

return helper_6ced5d9e
