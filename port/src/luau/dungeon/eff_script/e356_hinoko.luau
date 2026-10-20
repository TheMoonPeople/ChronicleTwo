--!strict
-- dungeon/eff_script/e356_hinoko.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f76322e3 = require("@lib/effect/helper_f76322e3")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local pos_y: f32 = 0
	local color_w: f32 = 0
	local var18: f32 = 0
	local var21: s32 = 0
	local var24: s32 = 0
	local value: s32 = 0
	local var26: s32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	var21 = effect.SptAssignSprite_2(210) or var21
	if var21 == 0 then
		return
	end
	effect.SptSetTexname("hinoko")
	effect.SptInitSprite(0, 210)
	effect.SptSetAlphab(0, 2, 210)
	effect.SptSetUvSize(0, 64.0, 0.0, 64.0, 64.0, 210)
	effect.SptSetPutSize(0, 1.0, 1.0, 210)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 128.0, 210)
	effect.SptSetDrawFlag(0, 0, 210)
	effect.SptSetPos(0, 0.0, 0.0, 0.0, 210)
	effect.SptSetAccPos(0, 0.0, -0.3, 0.0, 210)
	effect.GetUserId()
	var24 = 0
	while true do
		for var19 = 0, 209 do
			do
				local _, _, _, out4 = effect.SptGetColor(var19)
				color_w = out4 or color_w
			end
			if color_w <= 0.0 then
				effect.SptSetDrawFlag(var19, 0)
			end
			var26 = effect.SptGetDrawFlag(var19) or var26
			if var26 ~= 0 then
				do
					local _, out2, _ = effect.SptGetPos(var19)
					pos_y = out2 or pos_y
				end
				if pos_y < 2.0 then
					var26 = effect.GetValue(1) or var26
					var26 = 0
					if var26 == 0 then
						pos_y = vm.f32(pos_y * vm.f32(-0.8))
						effect.SptSetVeloPos(var19, 0.0, pos_y, 0.0)
						effect.SptSetAccPos(var19, 0.0, -0.3, 0.0)
					end
				end
			end
		end
		value = effect.GetValue(2) or value
		if value ~= 1 then
			for var22 = 0, 1 do
				var18 = 20.0
				helper_f76322e3(var24, var18, work_vect1_x, work_vect1_y, work_vect1_z)
				var24 = var24 + 1
				if var24 >= 210 then
					var24 = 0
				end
			end
		end
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
