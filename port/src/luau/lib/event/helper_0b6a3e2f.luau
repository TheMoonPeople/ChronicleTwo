--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")

--- Helper function.
local function helper_0b6a3e2f()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local x_2: f32 = 0
	local y_2: f32 = 0
	local z_2: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				x = -150.0
				y = 230.0
				z = 1600.0
				x_2 = 0.0
				y_2 = -8.0
				z_2 = -10.0
				var8 = 0.0
				var9 = vm.f32(0.2)
				var10 = 0.0
				var11 = 0
				var11 = var11 + 1
			end
			if at <= 2 then
				helper_2f481f12(8)
			end
			if at <= 3 then
				helper_e8f4b85c(0)
			end
			if at <= 4 then
				helper_2f481f12(30)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.DelExtMotion(0)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(2, 1)
		event.EohSetShow(3, 1)
		event.CharaActive(1, 0)
		event.CharaActive(1, 8)
		event.SetCharaPos(8, -316.71, 71.94, 806.78)
		event.SetCharaRot(8, 0.0, 2.06, 0.0)
		event.SetMotion(8, "立ち", 4)
		event.SetCharaPos(0, -230.0, 32.1, 1200.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.SetCameraRef(-230.0, 62.1, 1200.0)
		event.SetCameraPos(-230.0, 72.1, 1300.0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetStatusbarShow(0, 1.0)
	var0 = event.SndLoadSound(3803) or var0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.AssignStack(4)
	event.ClearStack(4)
	event.LoadChara(4, "event/d03/p00_26a.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(1, 8)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	if active_chr_no == 0 then
		event.LoadMotion(5, "event/dng_inout/c01d03gkey.gltf", "info", 0)
	else
		event.LoadMotion(5, "event/dng_inout/c02d03gkey.gltf", "info", 0)
	end
	event.CharaActive(0, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(2, 0)
	event.EohSetShow(3, 0)
	event.EohSetPos(0, -230.0, 62.1, 1210.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetPos(1, -150.0, 230.0, 1600.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "飛び", 4)
	event.ObjsSePlay(1, var0, 1)
	event.ObjsSeDelay(1, 34)
	event.ObjsSePlay(1, var0, 1)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(254.65, 473.72, 1588.47)
	event.CmrsSetRef(-219.14, 62.76, 1197.82)
	event.SndSePlay(var0, 0)
	event.SetFadeIn(30)
	x = -150.0
	y = 230.0
	z = 1600.0
	x_2 = 0.0
	y_2 = -8.0
	z_2 = -10.0
	var8 = 0.0
	var9 = vm.f32(0.2)
	var10 = 0.0
	var11 = 0
	while var11 < 60 do
		do
			local out1, out2, out3 = event.AddVector(x, y, z, x_2, y_2, z_2)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = event.AddVector(x_2, y_2, z_2, var8, var9, var10)
			x_2 = out1 or x_2
			y_2 = out2 or y_2
			z_2 = out3 or z_2
		end
		event.EohSetPos(1, x, y, z)
		var11 = var11 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	event.CharaActive(0, 8)
	event.CmrsSetPos(-195.61, 36.44, 1206.2)
	event.CmrsSetRef(-227.63, 40.13, 1199.12)
	event.CharaActive(1, 0)
	event.ObjsMove(0, -230.0, 32.1, 1200.0, 10)
	event.ObjsSetMotion(0, "d03着地", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_2f481f12(8)
	if vm.skipping() then
		return skip(3)
	end
	var12 = event.GetSndId(1) or var12
	event.SndSePlay(var12, 3)
	event.SndSePlay(var12, 2)
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeOut(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

return helper_0b6a3e2f
