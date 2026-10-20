--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_2b099cec(arg0: s32)
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.GetCnt(3)
	event.AssignStack(4)
	event.ClearStack(4)
	if arg0 ~= 0 then
		event.LoadChara(4, "event/e200/e220/e220_noam.gltf", "info", 9)
		event.SetCharaNo(9, 153)
		event.CharaActive(9)
		event.SetCharaPos(9, 2199.07, 29.83, 981.55)
		event.SetCharaRot(9, 0.0, 2.68, 0.0)
		event.SetMotion(9, "釣り")
		flag = event.GetFlag(28) or flag
		if flag == 0 then
			event.EohSyncChara(0, 9)
			event.EohSetFrameStatus(0, "wine", 0)
		end
		event.ChangeDir("event/e200/e215/")
		event.LoadChara(4, "e215_wicky.gltf", "info", 11)
		event.SetCharaNo(11, 152)
		event.CharaActive(11)
		event.SetCharaPos(11, 2022.78, 0.01, 1090.61)
		event.SetCharaRot(11, 0.0, 0.0, 0.0)
		event.SetMotion(11, "寝そべってる")
		event.LoadChara(4, "e215_mogri.gltf", "info", 12)
		event.SetCharaNo(12, 150)
		event.CharaActive(12)
		event.SetCharaPos(12, 1895.53, -3.91, 1206.14)
		event.SetCharaRot(12, 0.0, 0.0, 0.0)
		event.SetMotion(12, "座り")
		event.ChangeDir("")
		event.LoadChara(4, "event/nanahige/p02_07a.gltf", "info", 10)
		event.SetCharaNo(10, 155)
		event.CharaActive(10)
		event.SetCharaPos(10, 1824.39, 0.01, 1158.94)
		event.SetCharaRot(10, 0.0, 0.04, 0.0)
		event.SetMotion(10, "立ち")
		event.SetNearDist(10, 15.0)
		event.LoadChara(4, "event/e200/e230/e230_dokuring.gltf", "info", 13)
		event.CharaActive(0, 13)
		event.SetCharaPos(13, -1892.15, 3.14, 941.97)
		event.SetCharaRot(13, 3.1415927, 0.0, 0.0)
		event.SetScale(13, 2.0, 2.0, 2.0)
		event.CopyChara(4, 13, 15)
		event.CharaActive(0, 15)
		event.SetCharaPos(15, -1883.07, 3.14, 938.36)
		event.SetCharaRot(15, 3.1415927, 0.0, 0.0)
		event.SetScale(15, 2.0, 2.0, 2.0)
		event.CopyChara(4, 13, 16)
		event.CharaActive(0, 16)
		event.SetCharaPos(16, -1885.02, 3.14, 931.43)
		event.SetCharaRot(16, 3.1415927, 0.0, 0.0)
		event.SetScale(16, 2.0, 2.0, 2.0)
		event.CopyChara(4, 13, 17)
		event.CharaActive(0, 17)
		event.SetCharaPos(17, -1896.36, 3.14, 935.12)
		event.SetCharaRot(17, 3.1415927, 0.0, 0.0)
		event.SetScale(17, 2.0, 2.0, 2.0)
	end
	event.LoadChara(4, "event/e200/e230/e230_utan.gltf", "info", 8)
	event.CharaActive(1, 8)
	flag_2 = event.GetFlag(253) or flag_2
	if flag_2 == 0 then
		event.SetCharaPos(8, -1938.91, 0.4, 1036.52)
		event.SetCharaRot(8, 0.0, 2.44, 0.0)
		event.FuncPointShow("p01_s0501", "invent_2005-0", 1)
		event.FuncPointShow("p01_s0501", "invent_2005-1", 0)
		event.FuncPointShow("p01_s0501", "kaiwa01-0", 1)
		event.FuncPointShow("p01_s0501", "kaiwa03-0", 0)
		event.EohSyncObj(0, "p09_s0501", "s050119-c")
		event.EohSetShow(0, 1)
		event.EohSyncObj(0, "p09_s0501", "s050120-c")
		event.EohSetShow(0, 0)
	else
		event.SetCharaPos(8, -2202.71, 0.4, 759.61)
		event.SetCharaRot(8, 0.0, 2.16, 0.0)
		event.FuncPointShow("p01_s0501", "invent_2005-0", 0)
		event.FuncPointShow("p01_s0501", "invent_2005-1", 1)
		event.FuncPointShow("p01_s0501", "kaiwa01-0", 0)
		event.FuncPointShow("p01_s0501", "kaiwa03-0", 1)
		event.EohSyncObj(0, "p09_s0501", "s050119-c")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, "p09_s0501", "s050120-c")
		event.EohSetShow(0, 1)
	end
	flag_3 = event.GetFlag(240) or flag_3
	flag_4 = event.GetFlag(245) or flag_4
	event.EohSyncObj(0, "p08_s0501")
	if flag_3 ~= 0 and flag_4 == 0 then
		event.LoadChara(4, "chara/b04a.gltf", "b04a", 14)
		event.CharaActive(1, 14)
		event.SetCharaPos(14, -127.39, 0.0, -701.37)
		event.SetCharaRot(14, 0.0, -1.68, 0.0)
		event.SetStatus(1, 14, 256, 0)
		event.SetCharaFarDist(14, 2400.0)
		event.FuncPointShow("p01_s0501", "invent_2008-0", 1)
		event.FuncPointShow("p01_s0501", "kaiwa02-0", 1)
		event.EohSetShow(0, 1)
	else
		event.FuncPointShow("p01_s0501", "invent_2008-0", 0)
		event.FuncPointShow("p01_s0501", "kaiwa02-0", 0)
		event.EohSetShow(0, 0)
	end
end

return helper_2b099cec
