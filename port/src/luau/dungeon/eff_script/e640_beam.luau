--!strict
-- dungeon/eff_script/e640_beam.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: s32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local get_now_frame_wait: f32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
		work_vect2_z = out3 or work_vect2_z
	end
	effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.ChrSetRot(work_vect2_x, work_vect2_y, work_vect2_z)
	effect.ChrSetMotion("月花ビームはじけ", -1, 6)
	effect.SptSetTexname("e640_beamhajike")
	effect.SptAssignSprite_1(1920)
	effect.SptInitSprite(0, 1920)
	effect.SptSetAlphab(0, 2, 1920)
	effect.SptSetDrawFlag(0, 1, 1920)
	effect.SptSetPutSize(0, 50.0, 50.0, 1920)
	effect.SptSetUvSize(0, 1.0, 1.0, 62.0, 62.0, 1920)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 1920)
	vm.wait()
	do
		local out1, out2, out3 = effect.ChrGetFramePos("grid1--ba")
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = effect.ChrGetFramePos("grid1_1--ba")
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.ChrGetFramePos("grid1_2--ba")
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = effect.ChrGetFramePos("grid1_3--ba")
		var15 = out1 or var15
		var16 = out2 or var16
		var17 = out3 or var17
	end
	do
		local out1, out2, out3 = effect.ChrGetFramePos("grid1_4--ba")
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	do
		local out1, out2, out3 = effect.ChrGetFramePos("grid1_6--ba")
		var21 = out1 or var21
		var22 = out2 or var22
		var23 = out3 or var23
	end
	do
		local out1, out2, out3 = effect.ChrGetFramePos("grid1_6_1--ba")
		var24 = out1 or var24
		var25 = out2 or var25
		var26 = out3 or var26
	end
	do
		local out1, out2, out3 = effect.ChrGetFramePos("grid1_6_2--ba")
		var27 = out1 or var27
		var28 = out2 or var28
		var29 = out3 or var29
	end
	effect.ChrSetFrameShow("grid1--ba", 0, 0)
	effect.ChrSetFrameShow("grid1_1--ba", 0, 0)
	effect.ChrSetFrameShow("grid1_2--ba", 0, 0)
	effect.ChrSetFrameShow("grid1_3--ba", 0, 0)
	effect.ChrSetFrameShow("grid1_4--ba", 0, 0)
	effect.ChrSetFrameShow("grid1_6--ba", 0, 0)
	effect.ChrSetFrameShow("grid1_6_1--ba", 0, 0)
	effect.ChrSetFrameShow("grid1_6_2--ba", 0, 0)
	var30 = 0
	while true do
		for var31 = 0, 7 do
			if var31 == 0 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1--ba")
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
				end
				do
					local out1, out2, out3 = effect.CopyVector(var6, var7, var8)
					var35 = out1 or var35
					var36 = out2 or var36
					var37 = out3 or var37
				end
			end
			if var31 == 1 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1_1--ba")
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
				end
				do
					local out1, out2, out3 = effect.CopyVector(var9, var10, var11)
					var35 = out1 or var35
					var36 = out2 or var36
					var37 = out3 or var37
				end
			end
			if var31 == 2 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1_2--ba")
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
				end
				do
					local out1, out2, out3 = effect.CopyVector(var12, var13, var14)
					var35 = out1 or var35
					var36 = out2 or var36
					var37 = out3 or var37
				end
			end
			if var31 == 3 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1_3--ba")
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
				end
				do
					local out1, out2, out3 = effect.CopyVector(var15, var16, var17)
					var35 = out1 or var35
					var36 = out2 or var36
					var37 = out3 or var37
				end
			end
			if var31 == 4 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1_4--ba")
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
				end
				do
					local out1, out2, out3 = effect.CopyVector(var18, var19, var20)
					var35 = out1 or var35
					var36 = out2 or var36
					var37 = out3 or var37
				end
			end
			if var31 == 5 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1_6--ba")
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
				end
				do
					local out1, out2, out3 = effect.CopyVector(var21, var22, var23)
					var35 = out1 or var35
					var36 = out2 or var36
					var37 = out3 or var37
				end
			end
			if var31 == 6 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1_6_1--ba")
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
				end
				do
					local out1, out2, out3 = effect.CopyVector(var24, var25, var26)
					var35 = out1 or var35
					var36 = out2 or var36
					var37 = out3 or var37
				end
			end
			if var31 == 7 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1_6_2--ba")
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
				end
				do
					local out1, out2, out3 = effect.CopyVector(var27, var28, var29)
					var35 = out1 or var35
					var36 = out2 or var36
					var37 = out3 or var37
				end
			end
			do
				local out1, out2, out3 = effect.SubVector(var35, var36, var37, var32, var33, var34)
				var35 = out1 or var35
				var36 = out2 or var36
				var37 = out3 or var37
			end
			do
				local out1, out2, out3 = effect.DivVector(var35, var36, var37, 8)
				var35 = out1 or var35
				var36 = out2 or var36
				var37 = out3 or var37
			end
			for var38 = 0, 7 do
				effect.SptSetPos(var30, var32, var33, var34)
				effect.SptSetColor(var30, 128.0, 128.0, 128.0, 128.0)
				effect.SptColorConv(var30, 128.0, 128.0, 128.0, 0.0, 10)
				effect.SptSetScale(var30, 1.0, 1.0)
				effect.SptScaleConv(var30, 0.2, 0.2, 20)
				var30 = vm.i32(var30 + 1)
				do
					local out1, out2, out3 = effect.AddVector(var32, var33, var34, var35, var36, var37)
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
				end
			end
			if var31 == 0 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1--ba")
					var6 = out1 or var6
					var7 = out2 or var7
					var8 = out3 or var8
				end
			end
			if var31 == 1 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1_1--ba")
					var9 = out1 or var9
					var10 = out2 or var10
					var11 = out3 or var11
				end
			end
			if var31 == 2 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1_2--ba")
					var12 = out1 or var12
					var13 = out2 or var13
					var14 = out3 or var14
				end
			end
			if var31 == 3 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1_3--ba")
					var15 = out1 or var15
					var16 = out2 or var16
					var17 = out3 or var17
				end
			end
			if var31 == 4 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1_4--ba")
					var18 = out1 or var18
					var19 = out2 or var19
					var20 = out3 or var20
				end
			end
			if var31 == 5 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1_6--ba")
					var21 = out1 or var21
					var22 = out2 or var22
					var23 = out3 or var23
				end
			end
			if var31 == 6 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1_6_1--ba")
					var24 = out1 or var24
					var25 = out2 or var25
					var26 = out3 or var26
				end
			end
			if var31 == 7 then
				do
					local out1, out2, out3 = effect.ChrGetFramePos("grid1_6_2--ba")
					var27 = out1 or var27
					var28 = out2 or var28
					var29 = out3 or var29
				end
			end
		end
		if var30 >= 1920 then
			var30 = 0
		end
		get_now_frame_wait = effect.ChrGetMotWait() or get_now_frame_wait
		if get_now_frame_wait >= 1.0 then
			break
		else
			vm.wait()
		end
	end
	var30 = 0
	while var30 < 30 do
		var30 = var30 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
