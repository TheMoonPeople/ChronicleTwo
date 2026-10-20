--!strict
-- dungeon/eff_script/e808_mp_jet.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var3: f32 = 0
	local yaw: f32 = 0
	local var5: f32 = 0
	local value: s32 = 0
	local user_id: s32 = 0
	local value_2: s32 = 0
	value = 0
	user_id = 0
	value_2 = 0
	user_id = effect.GetUserId() or user_id
	value = effect.GetValue(0) or value
	value_2 = effect.GetValue(1) or value_2
	effect.ChrSetShow(1, 1)
	print("id=", user_id, "--------\n")
	effect.ChrSetMotion("MPジェット", -1, 4)
	while true do
		if value_2 ~= 0 then
			do
				local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "jet_r")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = effect.ScnGetChrFrmRot(user_id, "jet_r")
				var3 = out1 or var3
				yaw = out2 or yaw
				var5 = out3 or var5
			end
		else
			do
				local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "jet_l")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = effect.ScnGetChrFrmRot(user_id, "jet_l")
				var3 = out1 or var3
				yaw = out2 or yaw
				var5 = out3 or var5
			end
		end
		effect.ChrSetPos(pos_x, pos_y, pos_z)
		effect.ChrSetRot(var3, yaw, var5)
		vm.wait()
		value = effect.GetValue(0) or value
		if value ~= 0 then
			break
		end
	end
	effect.ChrSetShow(0, 1, -3.0)
	for var9 = 0, 29 do
		if value_2 ~= 0 then
			do
				local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "jet_r")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = effect.ScnGetChrFrmRot(user_id, "jet_r")
				var3 = out1 or var3
				yaw = out2 or yaw
				var5 = out3 or var5
			end
		else
			do
				local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "jet_l")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = effect.ScnGetChrFrmRot(user_id, "jet_l")
				var3 = out1 or var3
				yaw = out2 or yaw
				var5 = out3 or var5
			end
		end
		effect.ChrSetPos(pos_x, pos_y, pos_z)
		effect.ChrSetRot(var3, yaw, var5)
		vm.wait()
	end
	effect.ChrSetShow(0, 0)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
