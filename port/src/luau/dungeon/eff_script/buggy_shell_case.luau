--!strict
-- dungeon/eff_script/buggy_shell_case.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var7: s32 = 0
	local var8: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var12: f32 = 0
	local yaw: f32 = 0
	local var14: f32 = 0
	user_id = effect.GetUserId() or user_id
	effect.ChrCopyChara(2)
	effect.ChrSetPos(250, 80, -1000)
	var7 = 0
	var8 = 0
	while true do
		if vm.imod(var8, 15) == 0 then
			do
				local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "dcol00")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = effect.ScnGetChrFrmRot(user_id, "dcol00")
				var12 = out1 or var12
				yaw = out2 or yaw
				var14 = out3 or var14
			end
			print("POS = ", pos_x, ",", pos_y, ",", pos_z, "\n")
			print("ROT = ", var12, ",", yaw, ",", var14, "\n")
			effect.ChrSetPos2(var7, pos_x, pos_y + 30.0, pos_z)
			var7 = var7 + 1
			if var7 >= 2 then
				var7 = 0
			end
		end
		var8 = vm.i32(var8 + 1)
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
