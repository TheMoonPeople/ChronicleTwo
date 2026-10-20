--!strict
-- dungeon/eff_script/c01tame.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var6: s32 = 0
	local user_id: s32 = 0
	effect.ChrSetMotion("発動", -1, 6)
	user_id = effect.GetUserId() or user_id
	var6 = 0
	while var6 < 48 do
		do
			local out1, out2, out3 = effect.ScnGetChrPos(user_id)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = effect.ScnGetChrRot_4(user_id)
			rot_x = out1 or rot_x
			rot_y = out2 or rot_y
			rot_z = out3 or rot_z
		end
		effect.ChrSetPos(pos_x, pos_y, pos_z)
		effect.ChrSetRot(rot_x, rot_y, rot_z)
		var6 = var6 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
