--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_a6b17d3b()
	local argc: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(8)
	event.SetCharaPos(8, 2260.0, 0.0, 2233.0)
	event.SetCharaRot(8, 0.0, 3.14, 0.0)
	event.EohSyncChara(31, 8)
	event.EohSetFrameShow(31, "R_yaiba", 0)
	event.EohSetFrameShow(31, "obj11", 0)
	event.EohSetFrameShow(31, "L_yaiba", 0)
	event.EohSetFrameShow(31, "obj4", 0)
	event.SetNearDist(8, 15.0)
	event.CharaActive(9)
	event.SetCharaPos(9, 1522.37, 4.0, 2978.08)
	event.SetCharaRot(9, 0.0, 1.94, 0.0)
	event.SetNearDist(9, 15.0)
	event.CharaActive(10)
	event.SetCharaPos(10, 2100.0, 0.0, 3200.0)
	event.SetCharaRot(10, 0.0, 3.14, 0.0)
	event.SetNearDist(10, 15.0)
	event.CharaActive(11)
	event.SetCharaPos(11, 2713.25, 4.0, 2224.2)
	event.SetCharaRot(11, 0.0, -0.34, 0.0)
	event.SetNearDist(11, 15.0)
	event.CharaActive(12)
	event.SetCharaPos(12, 2575.78, 4.0, 2107.88)
	event.SetCharaRot(12, 0.0, -0.34, 0.0)
	event.SetMotion(12, "ゆれて飛ぶ", 5)
	event.SetNearDist(12, 15.0)
	argc = event.GetItemHaveNum(353) or argc
	flag = event.GetFlag(2) or flag
	flag_2 = event.GetFlag(3) or flag_2
	if flag == 1 and flag_2 == 1 and argc >= 1 then
		event.EohSyncChara(31, 12)
		event.EohSetFrameShow(31, "himonet", 0)
		event.EohSetFrameShow(31, "f2--A01C0S1", 0)
	end
	event.CharaActive(13)
	event.SetCharaPos(13, 1883.89, 0.0, 3101.53)
	event.SetCharaRot(13, 0.0, -0.58, 0.0)
	event.SetMotion(13, "立ち", 4)
	event.SetNearDist(13, 15.0)
	event.CharaActive(14)
	event.SetCharaPos(14, 3067.0, 4.0, 2354.0)
	event.SetCharaRot(14, 0.0, -0.13, 0.0)
	event.SetMotion(14, "立ち", 4)
	event.SetNearDist(14, 15.0)
	event.CharaActive(15)
	event.SetCharaPos(15, 2415.5, 4.0, 2015.94)
	event.SetCharaRot(15, 0.0, -0.74, 0.0)
	event.SetMotion(15, "立ち", 4)
	event.SetNearDist(15, 15.0)
	event.CharaActive(16)
	event.SetCharaPos(16, 2297.96, 0.0, 3228.8)
	event.SetCharaRot(16, 0.0, -2.88, 0.0)
	event.SetMotion(16, "立ち", 4)
	event.SetNearDist(16, 15.0)
	event.CharaActive(17)
	event.SetCharaPos(17, 1817.39, 4.0, 2034.82)
	event.SetCharaRot(17, 0.0, 0.02, 0.0)
	event.SetMotion(17, "立ち", 4)
	event.SetNearDist(17, 15.0)
	event.CharaActive(18)
	event.SetCharaPos(18, 1527.49, 4.0, 2385.88)
	event.SetCharaRot(18, 0.0, 2.06, 0.0)
	event.SetMotion(18, "立ち", 4)
	event.SetNearDist(18, 15.0)
end

return helper_a6b17d3b
