--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_31bb617a()
	local flag: s32 = 0
	local var1: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	flag = event.GetFlag(500) or flag
	if flag ~= 0 then
		var1 = event.GetQuestEtc(0, 5) or var1
		if var1 ~= 2 then
			event.AssignStack(4)
			event.ClearStack(4)
			event.LoadChara(4, "event/e400/e438/e438_paw.gltf", "info", 8)
			event.CharaActive(1, 8)
			event.SetCharaPos(8, -37.0, 0.0, 111.25)
			event.SetCharaRot(8, 0.0, -0.97, 0.0)
			event.SetMotion(8, "立ち", 4)
			event.SetCharaNo(8, 9)
		end
		event.FuncPointShow("", "event_400", 0)
		event.EohSyncObj(0, "p01_s2701", "s2701_03-a0")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, "p01_s2701", "s2701_02-c0")
		event.EohSetShow(0, 0)
		return
	end
	flag_2 = event.GetFlag(408) or flag_2
	flag_3 = event.GetFlag(420) or flag_3
	flag_4 = event.GetFlag(438) or flag_4
	flag_5 = event.GetFlag(444) or flag_5
	event.FuncPointShow("", "event_400", 0)
	event.EohSyncObj(0, "p01_s2701", "s2701_03-a0")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_s2701", "s2701_02-c0")
	event.EohSetShow(0, 0)
	if flag_2 == 1 then
		event.AssignStack(4)
		event.ClearStack(4)
		event.LoadChara(4, "event/e400/e438/e438_paw.gltf", "info", 8)
		event.CharaActive(1, 8)
		event.SetCharaPos(8, -37.0, 0.0, 111.25)
		event.SetCharaRot(8, 0.0, -0.97, 0.0)
		event.SetMotion(8, "立ち", 4)
		event.SetCharaNo(8, 9)
		if flag_3 == 1 and flag_5 == 0 then
			event.LoadChara(4, "event/e400/e438/e438_shigu.gltf", "info", 9)
			event.CharaActive(1, 9)
			event.SetCharaPos(9, -86.0, 0.0, 34.0)
			event.SetCharaRot(9, 0.0, 2.52, 0.0)
			event.SetMotion(9, "座り", 4)
			event.SetTexAnim(9, 0)
			if flag_4 == 0 then
				event.SetTexAnim(9, 1, "目とじ")
			else
				event.EohSyncChara(0, 9)
				event.EohSetFrameShow(0, "grid1", 0)
				event.SetTexAnim(9, 1, "通常目パチ")
			end
			event.EohSyncObj(0, "p01_s2701", "s2701_03-a0")
			event.EohSetPos(0, -86.0, 0.0, 34.0)
			event.EohSetRot(0, 0.0, 2.52, 0.0)
			event.EohSetShow(0, 1)
			event.EohSyncObj(0, "p01_s2701", "s2701_02-c0")
			event.EohSetPos(0, -86.0, 0.0, 34.0)
			event.EohSetRot(0, 0.0, 2.52, 0.0)
			event.EohSetShow(0, 1)
			event.FuncPointShow("", "event_400", 1)
		end
	end
end

return helper_31bb617a
