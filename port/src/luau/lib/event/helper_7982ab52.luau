--!strict
-- Shared event helper used by 42 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_7982ab52()
	local get_now_horl: s32 = 0
	event.SetActiveCmrid(1)
	event.SetBeforeCmrid(0)
	event.SetFcameraFollowOfs(0.0, 30.0, 0.0)
	event.SetFcameraHeight(5.0)
	event.SetFcameraDist(160.0)
	event.SetCameraSpeed(6.0)
	event.CtrlcSetRotCancel(1)
	event.CtrlcMoveRange(18.0, 10.0, 100.0, 160.0)
	event.ResetCamera(0)
	get_now_horl = event.SphidaGetNowHole() or get_now_horl
	if get_now_horl == 0 then
		event.LoadScript("d02/d02_sfida.stb", 6000)
		return
	end
	if get_now_horl == 1 then
		event.LoadScript("d03/d03_sfida.stb", 6000)
		return
	end
	if get_now_horl == 2 then
		event.LoadScript("d04/d04_sfida.stb", 6000)
		return
	end
	if get_now_horl == 3 then
		event.LoadScript("d05/d05_sfida.stb", 6000)
		return
	end
	if get_now_horl == 4 then
		event.LoadScript("d05/d05_sfida.stb", 6001)
		return
	end
	if get_now_horl == 5 then
		event.LoadScript("d06/d06_sfida.stb", 6000)
		return
	end
	if get_now_horl == 6 then
		event.LoadScript("d07/d07_sfida.stb", 6000)
		return
	end
	if get_now_horl == 7 then
		event.LoadScript("d01/d01_sfida.stb", 6001)
		return
	end
end

return helper_7982ab52
