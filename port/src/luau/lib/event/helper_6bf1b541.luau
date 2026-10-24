--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_6bf1b541(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(30)
		end
		if at <= 2 then
			helper_184013af()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(57.23, 251.57, 242.48)
	event.CmrsSetRef(21.23, 241.82, 43.83)
	event.CharaActive(1, 36)
	event.SetCharaPos(36, 266.91, 197.74, 696.65)
	event.SetCharaRot(36, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(4, "前を見るL", 4)
	event.ObjsMove(10, -120.0, 0.0, -6000.0, 120)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsMoveAhd2(-2.57, 9.27, 80.0, 120, 0, 0.4)
	helper_184013af()
	if vm.skipping() then
		return skip(3)
	end
	event.SndSeStop(arg0, 9)
end

return helper_6bf1b541
