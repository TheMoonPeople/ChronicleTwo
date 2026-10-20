--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_56b874f1()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local now_party_chara_id: s32 = 0
	flag = event.GetFlag(304) or flag
	flag_2 = event.GetFlag(306) or flag_2
	flag_3 = event.GetFlag(324) or flag_3
	flag_4 = event.GetFlag(330) or flag_4
	event.FuncPointShow("", "syumai", 0)
	event.FuncPointShow("", "event_550", 0)
	event.AssignStack(4)
	event.ClearStack(4)
	if flag_4 == 1 then
		event.LoadChara(4, "chara/p00_25a.gltf", "info", 24)
		event.CharaActive(24)
		event.SetCharaPos(24, -16.0, 22.0, -139.0)
		event.SetCharaRot(24, 0.0, 0.0, 0.0)
		event.SetMotion(24, "立ち", 4)
		event.SetCharaNo(24, 250)
		event.RegisterVillager2(24, 250, 4)
	else
		if flag_3 == 1 and flag_4 == 0 then
			event.FuncPointShow("", "syumai", 1)
			event.LoadChara(4, "chara/p00_25a.gltf", "info", 24)
			event.SetCharaNo(24, 250)
			event.ChangeDir("event/e300/e330/")
			event.LoadChara(4, "e330_lin.gltf", "info", 25)
			event.LoadChara(4, "e330_bed.gltf", "info", 26)
			event.ChangeDir("")
		else
			now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
			if flag == 1 and flag_2 == 0 and now_party_chara_id == 6 then
			else
				event.LoadChara(4, "chara/p00_25a.gltf", "info", 24)
				event.SetCharaNo(24, 250)
				event.ChangeDir("event/e300/e304/")
				event.LoadChara(4, "e304_lin.gltf", "info", 25)
				event.LoadChara(4, "e304_bed.gltf", "info", 26)
				event.ChangeDir("")
				event.FuncPointShow("", "event_550", 1)
			end
		end
		event.CharaActive(24)
		event.SetCharaPos(24, -16.0, 22.0, -139.0)
		event.SetCharaRot(24, 0.0, 0.0, 0.0)
		event.SetMotion(24, "立ち", 4)
		event.RegisterVillager2(24, 250, 4)
		event.SetAi(1, 24)
		event.CharaActive(25)
		event.SetCharaPos(25, 35.0, 16.0, -125.0)
		event.SetCharaRot(25, -1.57, 1.57, 0.0)
		event.SetMotion(25, "寝てる", 4)
		event.EohSyncChara(0, 25)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "苦しい顔")
		event.CharaActive(26)
		event.SetCharaPos(26, 28.0, 0.0, -125.0)
		event.SetCharaRot(26, 0.0, 0.0, 0.0)
		event.SetMotion(26, "寝てる", 4)
		event.EohSyncObj(0, "p01_g02i02", "g02i02_02-m0")
		event.EohSetShow(0, 0)
	end
end

return helper_56b874f1
