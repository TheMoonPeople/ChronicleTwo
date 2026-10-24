--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")
local helper_4896c0c7 = require("@lib/event/helper_4896c0c7")

--- Helper function.
local function helper_532bf9f4(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4896c0c7(1070010)
		end
		if at <= 2 then
			helper_23bda4ba(0)
		end
		if at <= 3 then
			helper_23bda4ba(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-355.99, 88.75, 12.43)
	event.CmrsSetRef(-376.3, 90.49, 31.84)
	event.CharaActive(1, 0)
	event.CharaActive(1, 9)
	event.ObjsSetMotion(0, "あれ？", 6, -1.0, 1)
	event.ObjsNextMotion(0, "あれ？L")
	event.ObjsSetMotion(1, "あれ？", 6)
	event.ObjsNextMotion(1, "あれ？L")
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(1070010)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_23bda4ba(1)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetPos(0, -348.51, 50.51, -12.26)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -348.51, 50.51, -12.26)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
end

return helper_532bf9f4
