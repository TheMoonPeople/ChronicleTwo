--!strict
-- dungeon/act_script/f216a.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1512c7e0 = require("@lib/action/helper_1512c7e0")
local helper_37f14ce7 = require("@lib/action/helper_37f14ce7")
local helper_42e38fa0 = require("@lib/action/helper_42e38fa0")
local helper_9559fe61 = require("@lib/action/helper_9559fe61")
local helper_9da84b8b = require("@lib/action/helper_9da84b8b")

--- Helper function.
local function helper_e38()
	local var1: s32 = 0
	local prog: s32 = 0
	local var4: s32 = 0
	prog = action.get_program_value() or prog
	if prog == 100 then
		action.play_motion("攻撃１in", -1, 6)
		vm.wait()
		var1 = action.get_motion_status() or var1
		if var1 == 4 then
			var4 = action.get_weapon_attack(0) or var4
			action.create_effect_1("ヒマーラ回転攻撃")
			action.set_effect_value(-1, 0, var4)
			action.set_program_value(prog + 1)
		end
		return
	end
	if prog == 101 then
		action.play_motion("攻撃１", -1, 6)
		vm.wait()
		var1 = action.get_motion_status() or var1
		if var1 == 4 then
			action.set_program_value(prog + 1)
		end
		return
	end
	if prog == 102 then
		action.play_motion("攻撃１out", -1, 6)
		vm.wait()
		var1 = action.get_motion_status() or var1
		if var1 == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Helper function.
local function helper_13b0()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local var6: s32 = 0
	action.play_motion("攻撃２", -1, 2)
	helper_9559fe61(vm.f32(0.39), vm.f32(0.42))
	do
		local out1, out2, out3 = action.get_object_position("dcol01")
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = action.get_rotation()
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	var6 = action.get_weapon_attack(0) or var6
	action.create_effect_1("ねばねばＬ")
	action.set_effect_first_vector(-1, var0, var1, var2)
	action.set_effect_second_vector(-1, rot_x, rot_y, rot_z)
	action.set_effect_value(-1, 0, var6)
	helper_9da84b8b()
	action.set_program_value(0)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the character up when its script is initialised.
function script.init()
	action.add_object_frame(0, "dcol00")
	action.add_object_frame(2, "bcol00")
	action.add_motion_damage("dcol00", "", "モンスター攻撃", 2.5, 1.0, "攻撃１in", 0.1, 0.9)
	action.add_body_collision(2, 5.0)
end

--- Runs the character's normal behaviour.
function script.loop()
	local prog: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	action.set_program_value(0)
	while true do
		prog = action.get_program_value() or prog
		if prog >= 100 and prog < 199 then
			action.turn_toward_target(40.0, 5.0)
			helper_e38()
		end
		if prog >= 200 and prog < 299 then
			action.turn_toward_target(40.0, 5.0)
			helper_13b0()
		end
		prog = action.get_program_value() or prog
		if prog == 0 then
			action.run_movement()
			var3 = action.get_button_state_2(50) or var3
			var4 = action.get_button_state_2(51) or var4
			if var3 ~= 0 then
				prog = 100
			end
			if var4 ~= 0 then
				prog = 200
			end
			action.set_program_value(prog)
		end
		vm.wait()
	end
end

--- Reacts to a small hit.
script.on_small_damage = helper_1512c7e0

--- Holds the character in place.
script.on_hold = helper_1512c7e0

--- Reacts to a large hit.
script.on_large_damage = helper_42e38fa0

--- Follows up a melee hit that the character has landed.
-- Defined empty, so the engine runs this instead of its default.
function script.on_melee_hit() end

--- Runs the character's death.
script.on_death = helper_37f14ce7

return script
