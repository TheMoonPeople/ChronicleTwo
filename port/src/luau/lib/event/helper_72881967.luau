--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_72881967()
	local flag: s32 = 0
	local var1: s32 = 0
	flag = event.GetFlag(408) or flag
	if flag == 0 then
		var1 = event.SearchCharaNo(301) or var1
		event.DeleteChara(var1)
		event.DeleteVillager(var1)
		event.AssignStack(4)
		event.ClearStack(4)
		event.LoadChara(4, "event/e400/e414/e414_osmond.gltf", "info", var1)
		event.CharaActive(var1)
		event.SetCharaPos(var1, -57.0056, 8.73, 219.919)
		event.SetCharaRot(var1, 0.0, -0.157, 0.0)
		event.SetMotion(var1, "寝る", 4)
		event.SetCharaNo(var1, 301)
	end
end

return helper_72881967
