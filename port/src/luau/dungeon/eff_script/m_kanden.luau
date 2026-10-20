--!strict
-- dungeon/eff_script/m_kanden.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: s32 = 0
	local user_id: s32 = 0
	user_id = effect.GetUserId() or user_id
	effect.ChrSetMotion("ループ", -1, 6)
	effect.ChrSetShow(1, 1)
	effect.ChrSetScale(2.0, 2.0, 2.0)
	var6 = 0
	while var6 < 30 do
		do
			local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "marioa_null")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		effect.ChrSetPos(pos_x, pos_y - 15.0, pos_z)
		vm.wait()
		var6 = var6 + 1
	end
	effect.ChrSetShow(0, 1, -0.2)
	while var6 < 30 do
		do
			local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "marioa_null")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		effect.ChrSetPos(pos_x, pos_y - 15.0, pos_z)
		vm.wait()
		var6 = vm.i32(var6 + 1)
	end
	effect.ChrSetShow(0, 0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
