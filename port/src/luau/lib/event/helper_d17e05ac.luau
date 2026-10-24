--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")
local helper_261c70db = require("@lib/event/helper_261c70db")

--- Helper function.
local function helper_d17e05ac(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_23bda4ba(0)
		end
		if at <= 2 then
			helper_23bda4ba(1)
		end
		if at <= 3 then
			helper_261c70db()
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
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_23bda4ba(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_261c70db()
	if vm.skipping() then
		return skip(4)
	end
end

return helper_d17e05ac
