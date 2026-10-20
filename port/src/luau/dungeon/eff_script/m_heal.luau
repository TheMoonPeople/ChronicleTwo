--!strict
-- dungeon/eff_script/m_heal.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value: s32 = 0
	value = effect.GetValue(0) or value
	effect.ChrSetMotion("回復", -1, 6)
	for var6 = 0, 89 do
		do
			local out1, out2, out3 = effect.ScnGetEntryObjPos(value, 0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		effect.ChrSetPos(pos_x, pos_y, pos_z)
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
