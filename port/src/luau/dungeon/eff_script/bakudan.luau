--!strict
-- dungeon/eff_script/bakudan.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local user_id: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	user_id = effect.GetUserId() or user_id
	while true do
		do
			local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "item")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		effect.ChrSetPos(pos_x, pos_y, pos_z)
		vm.wait()
	end
end

--- Ends an effect.
function script.on_finish()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local user_id: s32 = 0
	local value_2: s32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: s32 = 0
	local value_3: s32 = 0
	local value_4: s32 = 0
	local value_5: s32 = 0
	local var21: s32 = 0
	local var22: s32 = 0
	local area_kind: s32 = 0
	local foot_sound: s32 = 0
	local var25: s32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	user_id = effect.GetUserId() or user_id
	effect.GetValue(0)
	value_2 = effect.GetValue(1) or value_2
	do
		local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "item")
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.CopyVector(work_vect1_x, work_vect1_y, work_vect1_z)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.SubVector(var9, var10, var11, var0, var1, var2)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.NormalVector(var9, var10, var11)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, 6.0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	var16 = effect.DistVector2(var0, var1, var2, work_vect1_x, work_vect1_y, work_vect1_z) or var16
	var15 = vm.f32(-0.25 + vm.f32(var16 * vm.f32(0.0004)))
	var16 = vm.f32(vm.f32(var16 / 6.0) + 1.0)
	var10 = vm.f32(
		vm.fdiv(
			vm.f32(vm.f32(vm.f32(work_vect1_y - var1) * 2.0) - vm.f32(vm.f32(var15 * var16) * var16)),
			vm.f32(var16 * 2.0)
		)
	)
	var17 = 0
	if value_2 == 304 then
		effect.ColprimCreate("ギフト")
		value_3 = effect.GetValue(2) or value_3
		value_4 = effect.GetValue(3) or value_4
		value_5 = effect.GetValue(4) or value_5
		effect.ColprimGetGift(value_3, value_4, value_5)
		var17 = 1
	end
	if value_2 == 287 then
		effect.ColprimCreate("ときめきチェリ")
		var17 = 1
	end
	if value_2 == 288 then
		effect.ColprimCreate("ストーンベリー")
		var17 = 1
	end
	if value_2 == 289 then
		effect.ColprimCreate("ネバピーチ")
		var17 = 1
	end
	if value_2 == 291 then
		effect.ColprimCreate("毒りんご")
		var17 = 1
	end
	if value_2 == 281 then
		effect.ColprimCreate("石コロ")
		var17 = 1
	end
	if var17 == 0 then
		effect.ColprimCreate("円形チェック用")
	end
	var25 = 0
	var21 = 0
	while var21 < 60 do
		do
			local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var9, var10, var11)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var10 = vm.f32(var10 + var15)
		var35 = effect.DistVector(var9, var10, var11) or var35
		var36 = var35
		do
			local out1, out2, out3 = effect.CopyVector(var9, var10, var11)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
		end
		do
			local out1, out2, out3 = effect.NormalVector(var32, var33, var34)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var32, var33, var34, 2.0)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8, out9 = effect.IntersectionPoint_16(
				0,
				vector_x,
				vector_y,
				vector_z,
				vm.f32(var0 + var32) + var9,
				vm.f32(var1 + var33) + var10,
				vm.f32(var2 + var34) + var11
			)
			var26 = out1 or var26
			var27 = out2 or var27
			var28 = out3 or var28
			var29 = out4 or var29
			var30 = out5 or var30
			var31 = out6 or var31
			var22 = out7 or var22
			area_kind = out8 or area_kind
			foot_sound = out9 or foot_sound
		end
		if
			var25 <= 0
			and var22 >= 0
			and (var10 < 0.0 and var30 > 0.0)
			and (var9 > 0.0 and var29 > 0.0 or var9 < 0.0 and var29 < 0.0)
			and (var11 > 0.0 and var31 > 0.0 or var11 < 0.0 and var31 < 0.0)
		then
			if foot_sound == 1 or foot_sound == 13 then
				effect.EsCreate_1("足芝生")
				effect.EsSetVect1(var26, var27, var28)
				effect.EsCreate_1("足砂煙")
				effect.EsSetVect1(var26, var27, var28)
			end
			if foot_sound == 7 or foot_sound == 14 or foot_sound == 16 then
				effect.EsCreate_1("足砂煙")
				effect.EsSetVect1(var26, var27, var28)
			end
			if foot_sound == 11 or foot_sound == 18 or (area_kind == 1 or area_kind == 7) then
				effect.EsCreate_1("足水パシャ")
				effect.EsSetVect1(var26, var27, var28)
			end
			var25 = 10
		end
		if var25 > 0 then
			var25 = var25 - 1
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				effect.IntersectionPoint_14(4, vector_x, vector_y, vector_z, var0 + var32, var1 + var33, var2 + var34)
			var26 = out1 or var26
			var27 = out2 or var27
			var28 = out3 or var28
			var29 = out4 or var29
			var30 = out5 or var30
			var31 = out6 or var31
			var22 = out7 or var22
		end
		if var22 >= 0 then
			var35 = vm.f32(var35 * vm.f32(0.6))
		end
		while var22 >= 0 do
			do
				local out1, out2, out3 = effect.CopyVector(-var32, -var33, -var34)
				var32 = out1 or var32
				var33 = out2 or var33
				var34 = out3 or var34
			end
			do
				local out1, out2, out3 = effect.AddVector(var26, var27, var28, var32, var33, var34)
				var26 = out1 or var26
				var27 = out2 or var27
				var28 = out3 or var28
			end
			do
				local out1, out2, out3 = effect.CopyVector(var26, var27, var28)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			var37 = effect.DistVector2(vector_x, vector_y, vector_z, var0, var1, var2) or var37
			do
				local out1, out2, out3 = effect.CopyVector(var29, var30, var31)
				var9 = out1 or var9
				var10 = out2 or var10
				var11 = out3 or var11
			end
			do
				local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, var35)
				var9 = out1 or var9
				var10 = out2 or var10
				var11 = out3 or var11
			end
			var36 = vm.f32(var36 - var37)
			if var36 <= 0.0 then
				break
			else
				do
					local out1, out2, out3 = effect.ScaleVector(var29, var30, var31, var36)
					var29 = out1 or var29
					var30 = out2 or var30
					var31 = out3 or var31
				end
				do
					local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
					vector_x = out1 or vector_x
					vector_y = out2 or vector_y
					vector_z = out3 or vector_z
				end
				do
					local out1, out2, out3 = effect.AddVector(var0, var1, var2, var29, var30, var31)
					var0 = out1 or var0
					var1 = out2 or var1
					var2 = out3 or var2
				end
				do
					local out1, out2, out3 = effect.CopyVector(var29, var30, var31)
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
				end
				do
					local out1, out2, out3 = effect.NormalVector(var32, var33, var34)
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
				end
				do
					local out1, out2, out3 = effect.ScaleVector(var32, var33, var34, 2.0)
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
				end
				do
					local out1, out2, out3, out4, out5, out6, out7 = effect.IntersectionPoint_14(
						4,
						vector_x,
						vector_y,
						vector_z,
						var0 + var32,
						var1 + var33,
						var2 + var34
					)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
					var29 = out4 or var29
					var30 = out5 or var30
					var31 = out6 or var31
					var22 = out7 or var22
				end
			end
		end
		do
			local out1, out2, out3, out4 =
				effect.IntersectionPoint_11(4, var0, var1, var2, var0, var1 - vm.f32(1.9), var2)
			var26 = out1 or var26
			var27 = out2 or var27
			var28 = out3 or var28
			var22 = out4 or var22
		end
		if var22 >= 0 then
			var9 = vm.f32(var9 * vm.f32(0.6))
			var10 = -vm.f32(var10 * vm.f32(0.6))
			var11 = vm.f32(var11 * vm.f32(0.6))
			do
				local out1, out2, out3 = effect.CopyVector(var26, var27 + 2.0, var28)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
		end
		effect.ColprimSetCoord(var0, var1, var2, 5.0)
		var22 = effect.ColprimGetHitcnt() or var22
		if var22 > 0 then
			break
		else
			effect.ChrSetPos(var0, var1, var2)
			var21 = var21 + 1
			vm.wait()
		end
	end
	effect.ColprimDelete(-1)
	if value_2 == 276 then
		effect.EsCreate_1("魔石聖")
		effect.EsSetVect1(var0, var1, var2)
		effect.EsSetValue(0, 2)
	end
	if value_2 == 290 then
		effect.EsCreate_1("爆発")
		effect.EsSetVect1(var0, var1, var2)
		effect.EsSetValue(0, 4)
	end
	if value_2 == 280 then
		effect.EsCreate_1("爆発")
		effect.EsSetVect1(var0, var1, var2)
		effect.EsSetValue(0, 1)
	end
	if value_2 == 390 then
		effect.EsCreate_1("爆発")
		effect.EsSetVect1(var0, var1, var2)
		effect.EsSetValue(0, 2)
	end
	if value_2 == 391 then
		effect.EsCreate_1("ＦボムＨ")
		effect.EsSetVect1(var0, var1, var2)
		effect.EsSetValue(0, 3)
	end
	if value_2 == 307 then
		effect.EsCreate_1("電光石火")
		effect.EsSetVect1(var0, var1, var2)
		effect.EsSetValue(0, 3)
	end
	if value_2 == 282 then
		effect.EsCreate_1("魔石炎")
		effect.EsSetVect1(var0, var1, var2)
	end
	if value_2 == 283 then
		effect.EsCreate_1("魔石冷")
		effect.EsSetVect1(var0, var1, var2)
	end
	if value_2 == 284 then
		effect.EsCreate_1("魔石雷")
		effect.EsSetVect1(var0, var1, var2)
	end
	if value_2 == 285 then
		effect.EsCreate_1("魔石風")
		effect.EsSetVect1(var0, var1, var2)
	end
	if value_2 == 286 then
		effect.EsCreate_1("魔石聖")
		effect.EsSetVect1(var0, var1, var2)
		effect.EsSetValue(0, 1)
	end
end

return script
