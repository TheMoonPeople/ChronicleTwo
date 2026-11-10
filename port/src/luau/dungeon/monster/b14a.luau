--!strict
-- dungeon/monster/b14a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_27f80314 = require("@lib/monster/helper_27f80314")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5f4a60e2 = require("@lib/monster/helper_5f4a60e2")
local helper_6eaf9360 = require("@lib/monster/helper_6eaf9360")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_a004bd11 = require("@lib/monster/helper_a004bd11")
local helper_af712f29 = require("@lib/monster/helper_af712f29")

--- Runs the monster's death.
local function on_death()
	local value: s32 = 0
	local value_2: s32 = 0
	local value_3: s32 = 0
	local value_4: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	monster.stop_moving()
	helper_442b9962()
	value = monster.get_variable(8) or value
	value_2 = monster.get_variable(6) or value_2
	value = helper_af712f29(value, value_2)
	monster.set_variable(8, value)
	monster.start_death()
	monster.set_motion("死に", -1, 6)
	helper_56d63eae()
	monster.spawn_death_effects()
	value_3 = 0
	value_4 = 0
	value_3 = monster.get_variable(9) or value_3
	value_4 = monster.get_variable(10) or value_4
	value_4 = vm.i32(value_4 + 1)
	monster.set_variable(10, value_4)
	if value_3 == 0 then
		if value_4 >= 10 then
			monster.set_variable(9, 1)
			monster.set_variable(10, 0)
			monster.request_event_script(510)
		end
	elseif value_3 == 1 then
		if value_4 >= 20 then
			monster.set_variable(9, 2)
			monster.set_variable(10, 0)
			monster.request_event_script(510)
		end
	end
	monster.create_monster(513, 0.0, -100.0, 0.0)
	while true do
		vm.wait()
	end
end

--- Helper function.
local function helper_1984(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32, arg7: s32)
	local var8: s32 = 0
	local var9: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var14: f32 = 0
	var8 = 0
	var9 = 0
	while var8 < arg7 do
		var14 = vm.f32(
			vm.fdiv(
				vm.f32(vm.f32(vm.f32(arg4 - arg1) * 2.0) - vm.f32(vm.f32(arg6 * vm.i32(arg7 + 1)) * vm.i32(arg7 + 1))),
				vm.f32(vm.i32(arg7 + 1) * 2.0)
			)
		)
		y = arg1
		for var10 = 0, var8 - 1 do
			var14 = vm.f32(var14 + arg6)
			y = vm.f32(y + var14)
		end
		x = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg3 - arg0) * var8), arg7)) + arg0)
		z = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg5 - arg2) * var8), arg7)) + arg2)
		if var9 == 1 then
			if y < arg4 then
				y = arg4
			end
		elseif y > arg4 then
			var9 = 1
		end
		monster.set_position(x, y, z)
		var8 = var8 + 1
		vm.wait()
	end
end

--- Helper function.
local function helper_296c()
	local value: s32 = 0
	local var1: f32 = 0
	value = 0
	var1 = monster.get_target_distance() or var1
	if var1 <= 50.0 then
		value = vm.i32(bit32.bor(value, 1))
	elseif var1 <= 240.0 then
		value = vm.i32(bit32.bor(value, 2))
	elseif var1 <= 760.0 then
		value = vm.i32(bit32.bor(value, 4))
	else
		value = vm.i32(bit32.bor(value, 8))
	end
	if var1 <= 240.0 then
		value = vm.i32(bit32.bor(value, 16))
	end
	if helper_6eaf9360(0, 45.0) ~= 0 then
		value = vm.i32(bit32.bor(value, 32))
	end
	if var1 <= 90.0 then
		value = vm.i32(bit32.bor(value, 64))
	end
	if helper_6eaf9360(0, 80.0) ~= 0 then
		value = vm.i32(bit32.bor(value, 128))
	end
	monster.set_variable(0, value)
end

--- Helper function.
local function helper_2f20()
	local value: s32 = 0
	local value_2: s32 = 0
	local argc: s32 = 0
	value = monster.get_variable(2) or value
	if value ~= -1 then
		value_2 = monster.get_variable(3) or value_2
		monster.set_variable(1, value)
		monster.set_variable(2, value_2)
		monster.set_variable(3, -1)
		return
	end
	monster.get_variable(0)
	monster.set_variable(1, 4)
	monster.set_variable(2, 3)
	argc = monster.get_random(60) or argc
	argc = vm.i32(argc + 60)
	monster.set_variable(4, argc)
end

--- Helper function.
local function helper_2354()
	local var0: f32 = 0
	local argc: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var5: f32 = 0
	local argc_2: s32 = 0
	local arrived: s32 = 0
	argc = vm.bits_float(monster.get_random(20.0)) or argc
	argc = vm.f32(argc + 20.0)
	var0 = monster.get_angle_to_position(0.0, 0.0, 0.0) or var0
	target = vm.f32(vm.f32(vm.sin(var0) * argc) + target)
	target_2 = 0.0
	target_3 = vm.f32(vm.f32(vm.cos(var0) * argc) + target_3)
	argc_2 = monster.get_random(100) or argc_2
	if vm.imod(argc_2, 2) == 0 then
		monster.set_motion("歩き")
		var5 = vm.f32(0.2)
	else
		monster.set_motion("走り")
		var5 = vm.f32(0.4)
	end
	monster.move_toward_position(target, target_2, target_3, var5, var5)
	arrived = monster.is_move_finished() or arrived
	while arrived == 0 do
		monster.turn_toward_angle(var0, 0.034906585)
		vm.wait()
		arrived = monster.is_move_finished() or arrived
	end
	monster.set_motion("立ち")
end

--- Helper function.
local function helper_2244()
	local value: s32 = 0
	value = monster.get_variable(4) or value
	helper_5f4a60e2(value)
	monster.set_variable(4, 40)
end

--- Helper function.
local function helper_3348()
	local value: s32 = 0
	value = monster.get_variable(1) or value
	monster.get_variable(0)
	if value == 1 then
		helper_1ef0d4b2()
	end
	if value == 2 then
		helper_1ef0d4b2()
	end
	if value == 4 then
		helper_2354()
	end
	if value == 3 then
		monster.set_motion("立ち")
		helper_2244()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 3)
	monster.set_variable(3, -1)
	monster.set_variable(4, 40)
	monster.set_variable(5, 0)
	monster.set_variable(6, 0)
	monster.set_clip_distance(40.0)
	monster.set_motion("立ち", -1, 4)
	monster.set_alpha(0.99)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local value_2: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local value_3: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local angle: f32 = 0
	value = monster.get_variable(5) or value
	if value == 0 then
		vm.wait()
		monster.set_variable(5, 1)
		monster.set_monster_attributes(12, 1)
		monster.set_invulnerable_time(30)
		value_2 = monster.get_variable(8) or value_2
		if bit32.band(value_2, 255) == 255 then
			print("ERRER : ---  NOT_ROOT --- \n")
			on_death()
			return
		end
		while true do
			var2 = 0
			value_3 = 1
			argc = monster.get_random(8) or argc
			while var2 < argc do
				value_3 = vm.i32(value_3 * 2)
				var2 = var2 + 1
			end
			if vm.i32(bit32.band(value_2, value_3)) == 0 then
				value_2 = vm.i32(bit32.bor(value_2, value_3))
				monster.set_variable(8, value_2)
				monster.set_variable(6, value_3)
				break
			end
		end
		angle = vm.f32(vm.f32(-0.08) + vm.f32(vm.f32(0.7853982) * argc))
		angle = monster.wrap_angle(angle) or angle
		x = vm.f32(vm.sin(angle) * 400.0)
		y = -80.0
		z = vm.f32(vm.cos(angle) * 400.0)
		monster.set_position(x, y, z)
		var11 = monster.get_angle_to_position(0.0, 0.0, 0.0) or var11
		do
			local out1, _, out3 = monster.get_point_from_facing(var11, 140.0)
			pos_x = out1 or pos_x
			pos_z = out3 or pos_z
		end
		monster.set_rotation(0.0, var11, 0.0)
		helper_1984(x, -80.0, z, pos_x, 0.0, pos_z, vm.f32(-0.6), 30)
		monster.set_monster_attributes(12, 0)
	end
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_motion("立ち")
	while true do
		helper_296c()
		helper_2f20()
		helper_3348()
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_a004bd11()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	helper_442b9962()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_56d63eae()
	helper_5f4a60e2(8)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_a004bd11()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	helper_442b9962()
	helper_93495fdf()
	vm.wait()
	monster.start_knockback(5.0, 0.05, 10)
	monster.set_motion("吹っ飛び", -1, 6)
	helper_56d63eae()
	monster.set_action_status(1)
	helper_5f4a60e2(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Guards against a hit.
function script.on_guard()
	helper_a004bd11()
	monster.stop_moving()
	helper_93495fdf()
	monster.set_motion("ガード", -1, 6)
	monster.start_knockback(3.0, 0.0, 4)
	helper_56d63eae()
	helper_5f4a60e2(8)
end

--- Dodges the target's first kind of attack.
script.on_dodge_1 = helper_a004bd11

--- Dodges the target's second kind of attack.
script.on_dodge_2 = helper_a004bd11

script.on_death = on_death

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	monster.stop_moving()
	monster.end_throw()
	helper_5f4a60e2(10)
	monster.set_motion("起き上がり", -1, 2)
	helper_56d63eae()
	monster.set_motion("立ち")
	return 1
end

--- Stuns the monster.
function script.on_stun()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	helper_442b9962()
	monster.set_motion("吹っ飛び", -1, 6)
	helper_56d63eae()
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	monster.set_motion("気絶", -1)
	helper_27f80314()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

return script
