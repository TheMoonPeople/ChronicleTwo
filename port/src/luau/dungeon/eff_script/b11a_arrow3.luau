--!strict
-- dungeon/eff_script/b11a_arrow3.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local yaw: f32 = 0
	local var8: f32 = 0
	local dir_x: f32 = 0
	local dir_y: f32 = 0
	local dir_z: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var27: s32 = 0
	local user_id: s32 = 0
	local value_4: s32 = 0
	local value_5: s32 = 0
	local var31: s32 = 0
	local value_6: s32 = 0
	local value_7: s32 = 0
	local value_8: s32 = 0
	local var35: s32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	value_5 = 0
	value = 0.0
	value_2 = 0.0
	value_3 = 0.0
	var31 = 0
	value_6 = 0
	value_7 = 0
	value_5 = effect.GetValue(0) or value_5
	value = effect.GetValueFloat(2) or value
	value_2 = effect.GetValueFloat(3) or value_2
	value_3 = effect.GetValueFloat(4) or value_3
	value_6 = effect.GetValue(5) or value_6
	value_7 = effect.GetValue(6) or value_7
	user_id = effect.GetUserId() or user_id
	effect.ChrSetMotion("発射前", 4)
	effect.ChrSetShow(1, 1, 0.5)
	while true do
		do
			local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "arrow")
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.ScnGetChrFrmRot(user_id, "arrow")
			var6 = out1 or var6
			yaw = out2 or yaw
			var8 = out3 or var8
		end
		effect.ChrSetPos(var0, var1, var2)
		effect.ChrSetRot(var6, yaw, var8)
		value_4 = effect.GetValue(1) or value_4
		if value_4 ~= 0 then
			break
		else
			vm.wait()
		end
	end
	value_8 = 0
	value_8 = effect.GetRandInt(6) or value_8
	if value_8 == 0 then
		effect.ColprimCreate("通常攻撃")
	end
	if value_8 == 1 then
		effect.ColprimCreate("呪い攻撃")
	end
	if value_8 == 2 then
		effect.ColprimCreate("ねば攻撃")
	end
	if value_8 == 3 then
		effect.ColprimCreate("石化攻撃")
	end
	if value_8 == 4 then
		effect.ColprimCreate("毒液２")
	end
	if value_8 == 5 then
		effect.ColprimCreate("ＤＥ矢")
	end
	effect.ColprimSetDamage(value_5)
	do
		local out1, out2, out3 = effect.ChrGetPos()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	do
		local out1, out2, out3 = effect.ScnGetChrFrmRot(user_id, "arrow")
		var6 = out1 or var6
		yaw = out2 or yaw
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.GetDirVector(var6, yaw, var8)
		dir_x = out1 or dir_x
		dir_y = out2 or dir_y
		dir_z = out3 or dir_z
	end
	do
		local out1, out2, out3 = effect.CopyVector(dir_x, dir_y, dir_z)
		var21 = out1 or var21
		var22 = out2 or var22
		var23 = out3 or var23
	end
	do
		local out1, out2, out3 = effect.ScnGetChrPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_y = vm.f32(pos_y + 20.0)
	do
		local out1, out2, out3 = effect.ChrGetPos()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.CopyVector(pos_x, pos_y, pos_z)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	do
		local out1, out2, out3 = effect.SubVector(var18, var19, var20, var0, var1, var2)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	do
		local out1, out2, out3 = effect.NormalVector(var18, var19, var20)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	var27 = 0
	while var27 < 150 do
		value = vm.f32(value + value_2)
		if value_6 > 0 or var27 > value_7 then
			if value_6 > 0 then
				do
					local out1, out2, out3 = effect.CopyVector(dir_x, dir_y, dir_z)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				do
					local out1, out2, out3 = effect.ScaleVector(var3, var4, var5, value)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				value_6 = value_6 - 1
			else
				do
					local out1, out2, out3 = effect.CopyVector(var21, var22, var23)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				do
					local out1, out2, out3 = effect.ScaleVector(var3, var4, var5, value)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
			end
		else
			print("kita-----------------\n")
			do
				local out1, out2, out3 = effect.ScnGetChrPos(0)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			var18 = vm.f32(pos_x - var0)
			var19 = vm.f32(pos_y - var1)
			var20 = vm.f32(pos_z - var2)
			do
				local out1, out2, out3 = effect.NormalVector(var18, var19, var20)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			do
				local out1, out2, out3 = effect.ScaleVector(var18, var19, var20, value_3)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			do
				local out1, out2, out3 = effect.ScaleVector(var21, var22, var23, 1.0 - value_3)
				var21 = out1 or var21
				var22 = out2 or var22
				var23 = out3 or var23
			end
			do
				local out1, out2, out3 = effect.AddVector(var21, var22, var23, var18, var19, var20)
				var21 = out1 or var21
				var22 = out2 or var22
				var23 = out3 or var23
			end
			do
				local out1, out2, out3 = effect.NormalVector(var21, var22, var23)
				var21 = out1 or var21
				var22 = out2 or var22
				var23 = out3 or var23
			end
			do
				local out1, out2, out3 = effect.CopyVector(var21, var22, var23)
				var3 = out1 or var3
				var4 = out2 or var4
				var5 = out3 or var5
			end
			do
				local out1, out2, out3 = effect.ScaleVector(var3, var4, var5, value)
				var3 = out1 or var3
				var4 = out2 or var4
				var5 = out3 or var5
			end
		end
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var3, var4, var5)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(var0, var1, var2)
			var6 = out1 or var6
			yaw = out2 or yaw
			var8 = out3 or var8
		end
		var35 = effect.ColprimGetHitcnt() or var35
		if var35 > 0 then
			effect.EsCreate_1("ＤＥ矢Ｈ")
			effect.EsSetVect1(var0, var1, var2)
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.IntersectionPoint_11(4, vector_x, vector_y, vector_z, var0, var1, var2)
				var36 = out1 or var36
				var37 = out2 or var37
				var38 = out3 or var38
				var35 = out4 or var35
			end
			if var35 >= 0 then
				effect.EsCreate_1("ＤＥ矢Ｈ")
				effect.EsSetVect1(var36, var37, var38)
				effect.ChrSetPos(var36, var37, var38)
				var31 = 1
				break
			else
				effect.ChrSetPos(var0, var1, var2)
				effect.ChrSetRot(var6, yaw, var8)
				effect.ColprimSetCoord(vector_x, vector_y, vector_z, var0, var1, var2, 15.0)
				do
					local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
					vector_x = out1 or vector_x
					vector_y = out2 or vector_y
					vector_z = out3 or vector_z
				end
				vm.wait()
				var27 = var27 + 1
			end
		end
	end
	effect.ColprimDelete(-1)
	if var31 ~= 0 then
		var27 = 0
		effect.ChrSetShow(0, 1, -0.5)
		while var27 < 60 do
			vm.wait()
			var27 = var27 + 1
		end
	end
	effect.ChrSetShow(0, 0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
