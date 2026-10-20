--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")

--- Helper function.
local function helper_b0bc344a(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6c719c99(1090310)
		end
		if at <= 2 then
			helper_8f31f334(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-245.6, 62.76, -1902.65)
	event.CmrsSetRef(-246.75, 59.85, -1937.73)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -247.36, 36.72, -1936.73)
	event.ObjsSetRot(1, 0.0, 0.04, 0.0)
	event.PlayBgm(1)
	event.ObjsSetMotion(1, "出発じゃ！", 6)
	event.ObjsNextMotion(1, "出発じゃ！L", 2)
	event.SetPakuAnim(1, "大口パク")
	helper_6c719c99(1090310)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_b0bc344a
