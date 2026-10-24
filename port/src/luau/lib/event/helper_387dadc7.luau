--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_387dadc7()
	local argc: s32 = 0
	event.AssignStack(4)
	event.ClearStack(4)
	event.LoadChara(4, "event/opening/p1/p1_starbre.gltf", "info", 9)
	event.CharaActive(9)
	event.SetCharaPos(9, 17.27, 56.69, 102.98)
	event.SetCharaRot(9, 0.0, 2.2, 0.0)
	event.SetMotion(9, "座りL", 4)
	argc = event.GetItemHaveNum(382) or argc
	if argc >= 1 then
		event.FuncPointShow("", "item1", 0)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc >= 1 then
		event.FuncPointShow("", "item2", 0)
		event.EohSyncObj(0, "memo")
		event.EohSetShow(0, 0)
	end
end

return helper_387dadc7
