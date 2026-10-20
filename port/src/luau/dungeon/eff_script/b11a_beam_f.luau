--!strict
-- dungeon/eff_script/b11a_beam_f.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value: f32 = 0
	local user_id: s32 = 0
	local var5: s32 = 0
	value = 0.0
	value = effect.GetValueFloat(0) or value
	effect.ChrSetScale(value, value, value)
	effect.ChrSetMotion("攻撃２入り", 6)
	user_id = effect.GetUserId() or user_id
	while var5 < 73 do
		do
			local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "tama")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		effect.ChrSetPos(pos_x, pos_y, pos_z)
		vm.wait()
		var5 = var5 + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
