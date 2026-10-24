--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_7982ab52 = require("@lib/event/helper_7982ab52")
local helper_7b560508 = require("@lib/event/helper_7b560508")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_c24a11db = require("@lib/event/helper_c24a11db")
local helper_c44453a9 = require("@lib/event/helper_c44453a9")

--- Helper function.
local function helper_89dffb5a(arg0: s32)
	local omake_mode: s32 = 0
	local get_now_horl: s32 = 0
	local count: s32 = 0
	local get_now_horl_2: s32 = 0
	local stage_id: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local count_2: s32 = 0
	local position_x_2: f32 = 0
	local position_y_2: f32 = 0
	local position_z_2: f32 = 0
	event.SphidaSetStatusFlag(0)
	event.DeleteChara(12)
	event.EsmClear()
	event.DelExtMotion(0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.EohSyncChara(0, 2)
	event.EohSetShow(0, 1)
	event.SetCameraCtrl(1)
	event.DeleteSwordEffect()
	omake_mode = event.SphidaGetOmakeMode() or omake_mode
	get_now_horl = event.SphidaGetNowHole() or get_now_horl
	if arg0 == 1 and omake_mode == 1 then
		count = event.SphidaGetParCount() or count
		if get_now_horl ~= 8 then
			event.SphidaSetScore(-1, vm.i32(count + 3))
		end
		helper_7b560508()
		get_now_horl_2 = event.SphidaGetNowHole() or get_now_horl_2
		if get_now_horl_2 == 8 then
			helper_c44453a9()
			return
		else
			helper_7982ab52()
		end
		return
	end
	if omake_mode == 0 then
		event.SetStatusbarShow(1, 0.1)
	end
	event.SetCrossfade(15)
	if arg0 == 1 then
		if omake_mode == 0 then
			stage_id = event.DngGetStageId() or stage_id
			var6 = event.DngGetFloorId() or var6
			var7 = event.GetFloorInfo(stage_id, var6, 4) or var7
			if var7 == 1 then
				event.SetFloorInfo(stage_id, var6, 5, 128)
				event.AddYarikomiMedal(1)
				do
					local out1, out2, out3 = event.GetBeforeCameraNextPos()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				event.SetCameraPos(position_x, position_y, position_z)
				do
					local out1, out2, out3 = event.GetBeforeCameraNextRef()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				event.SetCameraRef(position_x, position_y, position_z)
				event.SetMesWindowMode(0, 4)
				helper_9e7d1511(0, 2010, 8, 0, 0)
				event.ResetCamera(0)
			end
		end
	end
	count_2 = event.SphidaGetParCount() or count_2
	if arg0 == 0 and count_2 <= 0 then
		do
			local out1, out2, out3 = event.GetBeforeCameraNextPos()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.SetCameraPos(position_x_2, position_y_2, position_z_2)
		do
			local out1, out2, out3 = event.GetBeforeCameraNextRef()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.SetCameraRef(position_x_2, position_y_2, position_z_2)
		event.SetMesWindowMode(0, 4)
		if omake_mode == 0 then
			helper_9e7d1511(0, 2003, 8, 0, 0)
		else
			if get_now_horl == 8 then
				helper_9e7d1511(0, 2003, 8, 0, 0)
				helper_c24a11db()
				helper_7b560508()
				helper_c44453a9()
				return
			else
				event.MesMake_2(0, "The Sphere has disappeared.\nProceed to the next course.")
				helper_9e7d1511(0, -1, 8, 0, 0)
			end
			event.SetFadeOut(30)
			helper_25abe6d2(30)
			helper_7b560508()
			helper_7982ab52()
			return
		end
		event.ResetCamera(0)
	end
	event.Finish()
end

return helper_89dffb5a
