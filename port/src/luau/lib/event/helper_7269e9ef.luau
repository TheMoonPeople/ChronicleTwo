--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")

--- Helper function.
local function helper_7269e9ef()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local value: f32 = 0
	local value_2: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local var9: s32 = 0
	local time: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local value_3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				var5 = 0
				var6 = -4
				var7 = 0
				var8 = -200
				var9 = 0
				var6 = var6 + 1
				var6 = -4
				var7 = var7 + 1
				var8 = -200
				var9 = 0
				var9 = 2
				var8 = var8 - 40
				var8 = var8 + 40
				var9 = 1
				value = vm.f32(value - 20.0)
				var0 = vm.f32(var0 + value)
				value = vm.f32(value - 50.0)
				var2 = vm.f32(var2 + value)
				var5 = var5 + 1
			end
			if at <= 2 then
				var5 = 0
				var5 = var5 + 1
				var5 = 0
				var5 = var5 + 1
				var5 = var5 + 1
				var5 = var5 + 1
				helper_efffcfbb(90)
			end
			if at <= 3 then
				helper_efffcfbb(30)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
		var5 = 0
		var5 = var5 + 1
	end
	function part2()
		event.CancelDramaScene()
		event.SetMapDraw(1)
		event.SetProjection(524.9)
		event.EohSetShow(0, 1)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.CharaActive(0)
		var5 = 0
		while var5 < 100 do
			event.DeleteChara(8 + var5)
			var5 = var5 + 1
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetProjection(300.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.ChangeDir("event/e500/e540/")
	event.EohSyncObj(0, "p03_s55")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	var5 = 0
	var6 = -4
	var7 = 0
	var8 = -200
	var9 = 0
	while var5 < 100 do
		if var5 == 0 then
			event.LoadChara(5, "e540_golem.gltf", "e33a", 8)
		else
			event.CopyChara(5, 8, 8 + var5)
		end
		event.CharaActive(8 + var5)
		event.EohSyncChara(1 + var5, 8 + var5)
		event.EohSetShadow(1 + var5, 0)
		event.ObjsInit(1 + var5)
		event.ObjsSyncObj(1 + var5, 1 + var5)
		if vm.imod(var7, 2) == 0 then
			event.SetCharaPos(
				8 + var5,
				vm.i32(vm.i32(vm.i32(80 * var6) - 80) + vm.i32(80 * var6)),
				150.0,
				vm.i32(vm.i32(vm.i32(vm.i32(-var7) * 100) + var8) + 6500)
			)
		else
			event.SetCharaPos(
				8 + var5,
				vm.i32(vm.i32(80 * var6) + vm.i32(80 * var6)),
				150.0,
				vm.i32(vm.i32(vm.i32(vm.i32(-var7) * 100) + var8) + 6500)
			)
		end
		var6 = vm.i32(var6 + 1)
		if vm.imod(var5 + 1, 10) == 0 then
			var6 = -4
			var7 = vm.i32(var7 + 1)
			var8 = -200
			var9 = 0
		end
		if var9 == 0 and var8 == 0 then
			var9 = 2
		end
		if var9 ~= 2 then
			if var9 ~= 0 then
				var8 = vm.i32(var8 - 40)
			else
				var8 = vm.i32(var8 + 40)
			end
		else
			var9 = 1
		end
		do
			local out1, out2, out3 = event.GetCharaPos(8 + var5)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		value = event.GetRand(40.0) or value
		value = vm.f32(value - 20.0)
		var0 = vm.f32(var0 + value)
		value = event.GetRand(100.0) or value
		value = vm.f32(value - 50.0)
		var2 = vm.f32(var2 + value)
		event.SetCharaPos(8 + var5, var0, var1, var2)
		value_2 = event.GetRandInt(100) or value_2
		if vm.imod(value_2, 2) == 0 then
			event.EohSetMotion(1 + var5, "走り", 4)
		else
			event.EohSetMotion(1 + var5, "走り2", 4)
		end
		event.EohNormalDrive(1 + var5)
		value = event.GetRand(10.0) or value
		event.ObjsSetMotionNowTime(1 + var5, value)
		var5 = var5 + 1
	end
	if vm.wait() then
		return skip(2)
	end
	var5 = 0
	while var5 < 100 do
		event.CharaActive(0, 8 + var5)
		var5 = var5 + 1
	end
	event.ChangeDir("")
	event.EohSetShow(0, 1)
	time = event.GetTime() or time
	event.SetTime(24.0)
	event.SetTimeStepEnable(0)
	event.SetMapDraw(0)
	event.InitDramaScene()
	event.SetFadeIn(0)
	event.CmrsSetPos(619.04, 258.8, 6128.66)
	event.CmrsSetRef(477.83, 335.0, 6237.76)
	event.CmrsMove2(619.04, 258.8, 6128.66, 516.77, 361.08, 6275.05, 60, 2, 1.0)
	var5 = 0
	while var5 < 100 do
		if
			vm.imod(var5, 10) == 3
			or vm.imod(var5, 10) == 4
			or vm.imod(var5, 10) == 5
			or vm.imod(var5, 10) == 6
			or vm.imod(var5, 10) == 7
			or vm.imod(var5, 10) == 8
			or vm.imod(var5, 10) == 9
		then
			event.CharaActive(0, 8 + var5)
			var5 = var5 + 1
			continue
		end
		if var5 == 0 then
			var5 = var5 + 1
			continue
		end
		event.CharaActive(8 + var5)
		event.EohResetDaPosition(1 + var5)
		do
			local out1, out2, out3 = event.EohGetPos(1 + var5)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		value_3 = event.GetRandInt(100) or value_3
		if vm.imod(value_3, 2) == 0 then
			event.EohSetMotion(1 + var5, "走り（坂）", 4)
		else
			event.EohSetMotion(1 + var5, "走り2（坂）", 4)
		end
		event.EohNormalDrive(1 + var5)
		value = event.GetRand(10.0) or value
		event.ObjsSetMotionNowTime(1 + var5, value)
		event.ObjsMove(1 + var5, pos_x, pos_y + 300, pos_z + 600.0, 120, 1)
		var5 = var5 + 1
	end
	event.ObjsSetPos(1, -770.0, 249.39, 6317.22)
	event.ObjsMove(1, -770.0, 270.4, 6373.33, 20)
	event.ObjsSetMotion(1, "走り（坂）", 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "振り返り", 2)
	event.ObjsNextMotion(1, "手をあげる", 6)
	event.ObjsNextMotion(1, "振り返りループ", 4)
	helper_efffcfbb(90)
	if vm.skipping() then
		return skip(3)
	end
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

return helper_7269e9ef
