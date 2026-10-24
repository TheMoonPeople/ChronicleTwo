--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_af3fca28 = require("@lib/event/helper_af3fca28")
local helper_d4b8f712 = require("@lib/event/helper_d4b8f712")

--- Helper function.
local function helper_c2e04add(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_af3fca28(0)
		end
		if at <= 2 then
			helper_af3fca28(1)
		end
		if at <= 3 then
			helper_d4b8f712()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -0.79, 50.09, 122.71)
	event.ObjsSetRot(0, 0.0, -3.14, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.CharaActive(1, 8)
	event.ObjsSetPos(1, 0.0, 50.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetScale(1, 1.5, 1.5, 1.5)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_af3fca28(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_d4b8f712()
	if vm.skipping() then
		return skip(4)
	end
end

return helper_c2e04add
