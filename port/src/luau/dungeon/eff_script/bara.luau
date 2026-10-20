--!strict
-- dungeon/eff_script/bara.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local value: f32 = 0
	local var13: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local var17: s32 = 0
	local value_4: s32 = 0
	local value_5: s32 = 0
	local value_6: s32 = 0
	local user_id: s32 = 0
	local var22: f32 = 0
	local value_7: f32 = 0
	local var24: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: s32 = 0
	value_4 = 0
	value_5 = 0
	value = 0.0
	value_2 = 0.0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	user_id = effect.GetUserId() or user_id
	value_4 = effect.GetValue(0) or value_4
	value = effect.GetValueFloat(1) or value
	value_5 = effect.GetValue(2) or value_5
	value_6 = effect.GetValue(7) or value_6
	effect.ChrSetPos(var0, var1, var2)
	var13 = effect.DistVector2(var6, var7, var8, var0, var1, var2) or var13
	value = vm.f32(vm.fdiv(var13, value_5))
	do
		local out1, out2, out3 = effect.SubVector(var6, var7, var8, var0, var1, var2)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.NormalVector(var6, var7, var8)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var6, var7, var8, value)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	var17 = 0
	while var17 < value_5 do
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var6, var7, var8)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
			pitch = out1 or pitch
			yaw = out2 or yaw
			var5 = out3 or var5
		end
		effect.ChrSetPos(var0, var1, var2)
		effect.ChrSetRot(pitch, yaw, var5)
		do
			local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		vm.wait()
		var17 = var17 + 1
	end
	while true do
		value_6 = effect.GetValue(7) or value_6
		if value_6 == 1 then
			effect.SetValueInt(7, 0)
			break
		else
			vm.wait()
		end
	end
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.ChrGetPos()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	value = effect.GetValueFloat(1) or value
	value_2 = effect.GetValueFloat(3) or value_2
	value_3 = effect.GetValueFloat(4) or value_3
	var22 = 0.0
	value_7 = 0.0
	value_7 = effect.GetValueFloat(5) or value_7
	var17 = 0
	while true do
		var24 = vm.f32(vm.sin(var22) * 30.0)
		var26 = vm.f32(vm.sin(value_7) * 30.0)
		var27 = vm.f32(vm.cos(value_7) * 30.0)
		var6 = vm.f32(var9 + var26)
		var7 = vm.f32(var10 + var24)
		var8 = vm.f32(var11 + var27)
		do
			local out1, out2, out3 = effect.ChrGetRefRot(var6, var7, var8)
			pitch = out1 or pitch
			yaw = out2 or yaw
			var5 = out3 or var5
		end
		effect.ChrSetPos(var6, var7, var8)
		effect.ChrSetRot(pitch, yaw, var5)
		var22 = vm.f32(var22 + value_3)
		value_7 = vm.f32(value_7 + value_2)
		vm.wait()
		value_6 = effect.GetValue(7) or value_6
		if value_6 == 1 then
			effect.SetValueInt(7, 0)
			break
		else
			var17 = vm.i32(var17 + 1)
		end
	end
	do
		local out1, out2, out3 = effect.ChrGetPos()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	value_4 = effect.GetValue(0) or value_4
	value = effect.GetValueFloat(1) or value
	value_5 = effect.GetValue(2) or value_5
	do
		local out1, out2, out3 = effect.SubVector(var6, var7, var8, var0, var1, var2)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.NormalVector(var6, var7, var8)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var6, var7, var8, value)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	effect.ColprimCreate("サン薔薇")
	effect.ColprimSetDamage(value_4)
	var17 = 0
	while var17 < value_5 do
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var6, var7, var8)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
			pitch = out1 or pitch
			yaw = out2 or yaw
			var5 = out3 or var5
		end
		effect.ChrSetPos(var0, var1, var2)
		effect.ChrSetRot(pitch - vm.f32(1.5707964), yaw, var5)
		effect.ColprimSetCoord(var0, var1, var2, 10.0)
		var28 = effect.IntersectionPoint_8(4, var9, var10, var11, var0, var1, var2) or var28
		if var28 >= 0 then
			break
		else
			var28 = effect.ColprimGetHitcnt() or var28
			if var28 > 0 then
				do
					local out1, out2, out3 = effect.ColprimGetHitPos()
					var9 = out1 or var9
					var10 = out2 or var10
					var11 = out3 or var11
				end
				break
			else
				do
					local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
					var9 = out1 or var9
					var10 = out2 or var10
					var11 = out3 or var11
				end
				vm.wait()
				var17 = var17 + 1
			end
		end
	end
	effect.ColprimDelete(-1)
	effect.EsCreate_1("バラヒット")
	effect.EsSetVect1(var9, var10, var11)
	effect.EsSetValue(0, value_4)
	effect.EsSetValue(1, user_id)
end

--- Ends an effect.
function script.on_finish()
	local var0: f32 = 0
	local var1: f32 = 0
	effect.ColprimDelete(-1)
	var0 = 1.0
	var1 = vm.f32(0.11111111)
	for var2 = 0, 8 do
		effect.ChrSetScale(var0, var0, var0)
		var0 = vm.f32(var0 - var1)
		vm.wait()
	end
end

return script
