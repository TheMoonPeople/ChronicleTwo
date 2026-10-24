--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_9c20c95c()
	local var0: s32 = 0
	var0 = event.GetQuestEtc(0, 0) or var0
	if var0 ~= 2 then
		return
	end
	var0 = event.GetQuestEtc(0, 18) or var0
	if var0 ~= 0 then
		return
	end
	event.Initialize()
	event.AssignStack(4)
	event.ClearStack(4)
	event.LoadCharaNpc(0, 4, 24, 28)
	event.SetCharaPos(28, 95.1, 96.2, 118.0)
	event.SetCharaRot(28, 0.0, -2.79, 0.0)
	event.SetMotion(28, "立ち", 4)
	event.SetCharaNo(28, 24)
	event.RegisterVillager(28, 24)
	event.CharaActive(28)
end

return helper_9c20c95c
