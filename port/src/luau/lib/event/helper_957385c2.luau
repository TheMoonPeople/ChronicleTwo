--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")

--- Helper function.
local function helper_957385c2(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6c719c99(1090250)
		end
		if at <= 2 then
			helper_6c719c99(1090260)
		end
		if at <= 3 then
			helper_6c719c99(1090270)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-281.2, 51.82, -2024.16)
	event.CmrsSetRef(-258.93, 59.56, -1963.26)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -247.36, 36.72, -1936.73)
	event.ObjsSetRot(1, 0.0, -0.08, 0.0)
	event.ObjsSetMotion(1, "腰に手L", 4)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, -257.07, 36.72, -1857.99)
	event.ObjsSetRot(2, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(2, "会話", 4)
	event.CharaActive(1, 35)
	event.ObjsSetPos(3, -281.38, 36.72, -1863.87)
	event.ObjsSetRot(3, 0.0, 2.8, 0.0)
	event.ObjsSetMotion(3, "会話", 4)
	event.SetPakuAnim(1, "大口パク")
	helper_6c719c99(1090250)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "口パク")
	helper_6c719c99(1090260)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "口パク")
	helper_6c719c99(1090270)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
end

return helper_957385c2
