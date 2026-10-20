--!strict
-- dungeon/eff_script/e516_gun_s.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local value: s32 = 0
	local value_2: s32 = 0
	local var9: s32 = 0
	value = 0
	value_2 = effect.GetValue(1) or value_2
	effect.ChrSetMotion("連射", -1, 4)
	var9 = 0
	while var9 < 300 do
		value = effect.GetValue(0) or value
		if value ~= 0 then
			break
		else
			do
				local out1, out2, out3 = effect.ScnGetChrPos(value_2)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = effect.ScnGetChrRot_4(value_2)
				rot_x = out1 or rot_x
				rot_y = out2 or rot_y
				rot_z = out3 or rot_z
			end
			effect.ChrSetPos(pos_x, pos_y, pos_z)
			effect.ChrSetRot(rot_x, rot_y, rot_z)
			vm.wait()
			var9 = var9 + 1
		end
	end
end

--- Ends an effect.
function script.on_finish()
	effect.MonSeStop(4)
end

return script
