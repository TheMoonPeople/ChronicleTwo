--!strict
-- dungeon/eff_script/b11a_hikari_blue.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value_2: s32 = 0
	local value_3: s32 = 0
	local var7: s32 = 0
	value = 0.0
	effect.SetValueInt(2, 0)
	effect.ChrSetMotion("ループ")
	user_id = effect.GetUserId() or user_id
	while true do
		if var7 > 15 then
			effect.SetValueInt(2, 0)
		end
		value_2 = effect.GetValue(0) or value_2
		value = effect.GetValueFloat(1) or value
		value_3 = effect.GetValue(2) or value_3
		if value_2 ~= 0 then
			effect.ChrSetShow(1, 0)
		else
			effect.ChrSetShow(0, 0)
		end
		if value_3 == 0 then
			var7 = 0
		end
		if value_3 == 2 then
			effect.ChrSetShow(0, 1, 3.0)
			var7 = vm.i32(var7 + 1)
		end
		if value_3 == 1 then
			effect.ChrSetShow(0, 1, -3.0)
			var7 = vm.i32(var7 + 1)
		end
		do
			local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "tama")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		effect.ChrSetPos(pos_x, pos_y, pos_z)
		effect.ChrSetScale(value, value, value)
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
