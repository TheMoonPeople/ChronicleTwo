--!strict
-- dungeon/monster/b205a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_179581d3 = require("@lib/monster/helper_179581d3")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1adea708 = require("@lib/monster/helper_1adea708")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_20ea05b8 = require("@lib/monster/helper_20ea05b8")
local helper_243517f2 = require("@lib/monster/helper_243517f2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56a4eab4 = require("@lib/monster/helper_56a4eab4")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5a759074 = require("@lib/monster/helper_5a759074")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_6911bbcd = require("@lib/monster/helper_6911bbcd")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_97d8f861 = require("@lib/monster/helper_97d8f861")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")
local helper_bfbcfc9f = require("@lib/monster/helper_bfbcfc9f")
local helper_cbe4d8e2 = require("@lib/monster/helper_cbe4d8e2")
local helper_cd4ea219 = require("@lib/monster/helper_cd4ea219")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d375874f = require("@lib/monster/helper_d375874f")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e62edeb2 = require("@lib/monster/helper_e62edeb2")
local helper_e8739558 = require("@lib/monster/helper_e8739558")
local helper_fd16d93e = require("@lib/monster/helper_fd16d93e")

--- Helper function.
local function helper_3048()
	local boss: s32 = 0
	helper_1adea708(500.0)
	helper_6911bbcd(80.0)
	helper_5a759074(0)
	monster.set_secondary_variable(5, 0)
	monster.set_secondary_variable(11, 150)
	monster.set_secondary_variable(12, 0)
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Helper function.
local function helper_16ce4()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 120.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = helper_bfbcfc9f(vm.f32(3.2), 3.5, var3, var4, 65.0, 30)
		helper_83e135e0(3.5)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_e62edeb2(65.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_11b1c(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local rot_speed: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: s32 = 0
	rot_speed = helper_787df986(arg1)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	var13 = 0
	while var13 < arg3 do
		monster.get_position_3()
		var12 = monster.get_target_distance() or var12
		if var12 < arg2 then
			helper_442b9962()
			monster.stop_moving()
			return
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		if var9 < -900.0 then
			helper_442b9962()
			monster.stop_moving()
			return
		end
		var11 = monster.get_target_angle() or var11
		monster.move_toward_position(var7, var8 - 20.0, var9, arg0, arg0)
		monster.turn_toward_angle(var11, rot_speed)
		helper_b9fff8e1()
		var13 = var13 + 1
		helper_442b9962()
	end
	monster.stop_moving()
	helper_442b9962()
end

--- Helper function.
local function helper_12cbc()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local argc: s32 = 0
	local pos_x_2: f32 = 0
	local pos_z_2: f32 = 0
	local var10: f32 = 0
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	helper_20ea05b8(helper_9df6409a(4))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol00")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("トーレの煙")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	helper_20ea05b8(helper_9df6409a(11))
	argc = monster.get_monster_count() or argc
	if argc < 7 then
		monster.get_random(3, var4)
		var3 = 0
		var4 = var4 + 1
		monster.set_monster_attributes(16, 1)
		while var3 < 3 do
			do
				local out1, _, out3 = monster.get_position_3()
				pos_x_2 = out1 or pos_x_2
				pos_z_2 = out3 or pos_z_2
			end
			do
				local _, out2, _ = monster.get_rotation()
				var10 = out2 or var10
			end
			do
				local out1, _, out3 = monster.get_point_from_facing(0.0, 40.0 + vm.f32(var3 * 10.0))
				pos_x_2 = out1 or pos_x_2
				pos_z_2 = out3 or pos_z_2
			end
			monster.create_monster(610, pos_x_2, 0.5, pos_z_2, var10)
			var3 = var3 + 1
		end
	end
	helper_cbe4d8e2()
	helper_20ea05b8(15)
	monster.set_monster_attributes(16, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_12270(arg0: f32, arg1: f32, arg2: s32, arg3: f32)
	local var5: f32 = 0
	local var7: f32 = 0
	arg0 = helper_787df986(arg0)
	do
		local _, out2, _ = monster.get_rotation()
		var5 = out2 or var5
	end
	monster.set_motion("歩き", -1.0, 0)
	var7 = vm.f32(var5 + arg0)
	helper_179581d3(helper_28452e16(var7), arg1)
	monster.set_motion("立ち", -1, 0)
	if helper_e62edeb2(arg3, 80.0, arg2) == 1 then
		return 0
	end
	do
		local _, out2, _ = monster.get_rotation()
		var5 = out2 or var5
	end
	monster.set_motion("歩き", -1.0, 0)
	var7 = vm.f32(var5 - arg0)
	helper_179581d3(helper_28452e16(var7), arg1)
	monster.set_motion("立ち", -1, 0)
	if helper_e62edeb2(arg3, 80.0, arg2) == 1 then
		return 0
	end
	do
		local _, out2, _ = monster.get_rotation()
		var5 = out2 or var5
	end
	monster.set_motion("歩き", -1.0, 0)
	var7 = vm.f32(var5 - arg0)
	helper_179581d3(helper_28452e16(var7), arg1)
	monster.set_motion("立ち", -1, 0)
	if helper_e62edeb2(arg3, 80.0, arg2) == 1 then
		return 0
	end
	do
		local _, out2, _ = monster.get_rotation()
		var5 = out2 or var5
	end
	monster.set_motion("歩き", -1.0, 0)
	var7 = vm.f32(var5 + arg0)
	helper_179581d3(helper_28452e16(var7), arg1)
	monster.set_motion("立ち", -1, 0)
	if helper_e62edeb2(arg3, 80.0, arg2) == 1 then
		return 0
	end
	return 0
end

--- Helper function.
local function helper_1633c()
	local argc: s32 = 0
	local argc_2: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 10 then
		argc_2 = monster.get_monster_count() or argc_2
		if argc_2 < 7 then
			monster.set_motion("歩き", -1.0, 0)
			helper_11b1c(vm.f32(3.2), 3.5, 65.0, 90)
			helper_12cbc()
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 75 then
			monster.set_motion("歩き", -1, 0)
			helper_83e135e0(3.5)
			monster.set_motion("歩き", -1, 0)
			helper_11b1c(vm.f32(3.2), 3.5, 65.0, 90)
		else
			argc = monster.get_random(100) or argc
			if argc < 40 then
				if helper_12270(45.0, 3.5, 60, 200.0) == 1 then
					monster.set_motion("歩き", -1.0, 0)
					helper_83e135e0(3.5)
					monster.set_motion("歩き", -1.0, 0)
					helper_11b1c(vm.f32(3.2), 3.5, 65.0, 90)
					monster.set_motion("立ち", -1, 0)
				end
			else
				argc = monster.get_random(100) or argc
				if argc < 50 then
					monster.set_motion("待機", -1, 0)
					if helper_e62edeb2(550.0, 45.0, 75) == 1 then
						monster.set_motion("歩き", -1.0, 0)
						helper_83e135e0(3.5)
						monster.set_motion("歩き", -1.0, 0)
						helper_11b1c(vm.f32(3.2), 3.5, 65.0, 90)
						monster.set_motion("立ち", -1, 0)
					end
				else
					helper_56a4eab4(30)
				end
			end
		end
	end
	helper_b9fff8e1()
end

--- Helper function.
local function helper_15c68()
	local argc: s32 = 0
	local argc_2: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 25 then
		argc_2 = monster.get_monster_count() or argc_2
		if argc_2 < 7 then
			monster.set_motion("歩き", -1.0, 0)
			helper_11b1c(vm.f32(3.2), 3.5, 65.0, 90)
			helper_12cbc()
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_motion("歩き", -1.0, 0)
			helper_83e135e0(3.5)
			monster.set_motion("歩き", -1.0, 0)
			helper_11b1c(vm.f32(3.2), 3.5, 65.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				monster.set_motion("歩き", -1.0, 0)
				helper_97d8f861(vm.f32(3.2), 3.5, 40.0, 180.0, 30.0, 65.0, 40)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				helper_e62edeb2(150.0, 45.0, 45)
			end
		end
	end
	helper_b9fff8e1()
end

--- Helper function.
local function helper_12b78()
	monster.set_motion("攻撃１", -1, 2)
	helper_cbe4d8e2()
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_15290()
	local argc: s32 = 0
	local var2: f32 = 0
	local argc_2: s32 = 0
	local var4: f32 = 0
	monster.get_life_int()
	argc = monster.get_random(100) or argc
	if argc < 85 then
		monster.set_motion("歩き", -1.0, 0)
		helper_83e135e0(3.5)
		monster.set_motion("歩き", -1.0, 0)
		helper_11b1c(vm.f32(3.2), 3.5, 65.0, 90)
		helper_12b78()
	else
		var2 = monster.get_target_distance() or var2
		if var2 < 70.0 then
			argc = monster.get_random(100) or argc
			if argc < 60 then
				argc_2 = monster.get_monster_count() or argc_2
				if argc_2 < 7 then
					monster.set_motion("歩き", -1.0, 0)
					helper_e8739558(7.0, 30.0, 15)
					helper_12cbc()
				end
			end
		end
		argc = monster.get_random(100) or argc
		if argc < 70 then
			monster.set_motion("歩き", -1.0, 0)
			helper_83e135e0(3.5)
			monster.set_motion("歩き", -1.0, 0)
			helper_11b1c(vm.f32(3.2), 3.5, 65.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			if argc < 100 then
				monster.set_motion("立ち", -1, 0)
				helper_e62edeb2(120.0, 30.0, 45)
			else
				monster.set_motion("歩き", -1.0, 0)
				helper_83e135e0(3.5)
				var4 = monster.get_target_angle() or var4
				monster.set_motion("歩き", -1.0, 0)
				helper_cd4ea219(vm.f32(3.2), helper_28452e16(var4), 100.0, 600.0, 15)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_171c4()
	local var3: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		helper_b9fff8e1()
		var3 = monster.get_target_distance() or var3
		if var3 > 600.0 then
			monster.set_variable(0, 0)
			helper_b9fff8e1()
			return
		elseif var3 > 120.0 then
			monster.set_variable(0, 0)
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			helper_b9fff8e1()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			helper_16ce4()
			continue
		end
		if var3 < 600.0 and var3 >= 200.0 then
			helper_1633c()
		elseif var3 < 200.0 and var3 >= 120.0 then
			helper_15c68()
		else
			helper_15290()
		end
		helper_b9fff8e1()
	end
end

--- Helper function.
local function helper_176c4()
	local var3: f32 = 0
	local value: s32 = 0
	monster.set_variable(0, 0)
	helper_b9fff8e1()
	var3 = monster.get_target_distance() or var3
	-- retail: monster.set_variable(0, value) does nothing, since its handler stores only an integer or a float
	if var3 < 320.0 and value == 0 then
		monster.set_motion("立ち", -1, 0)
		monster.set_motion("歩き", -1.0, 0)
		helper_83e135e0(vm.f32(2.45))
		monster.set_motion("立ち", -1, 0)
		helper_b9fff8e1()
		monster.set_variable(0, 1)
		return
	end
	value = monster.get_variable(0) or value
	if value == 0 then
		monster.set_motion("待機", -1, 0)
		helper_20ea05b8(10)
	end
end

--- Helper function.
local function helper_18e38()
	print("notice--------------\n")
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	helper_11b1c(vm.f32(6.4), 3.5, 65.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Helper function.
local function helper_19034()
	local var0: f32 = 0
	local var1: f32 = 0
	var0 = monster.get_target_distance() or var0
	print("test---------------------\n")
	if helper_a25c5b2e() == 0 then
		if var0 < 600.0 then
			helper_65eb2b74(0)
			helper_171c4()
		else
			helper_176c4()
		end
	else
		print("notice-------------\n")
		var1 = helper_243517f2(var1)
		if var0 < var1 then
			if var0 < 200.0 then
				helper_65eb2b74(0)
				helper_171c4()
			else
				helper_18e38()
			end
		else
			helper_65eb2b74(0)
		end
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local get_not_used_texb: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	monster.register_damage_hit("トレントス攻撃", 10.0, "攻撃１", 0.3, 0.7, 1)
	monster.register_damage_hit("トレントス攻撃", 10.0, "攻撃１", 0.4, 0.8, 2)
	monster.set_monster_attributes(512, 1)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.load_effect_script("トーレの煙", get_not_used_texb) or var1
		var2 = monster.load_effect_script("Ｍ小爆発", get_not_used_texb) or var2
		if (if var1 ~= 0 then 1 else var2) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 0)
	monster.set_variable(3, 0)
	helper_3048()
	monster.set_clip_distance(99999.9)
	helper_1adea708(vm.f32(99999.9))
	helper_6911bbcd(vm.f32(99999.9))
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_monster_attributes(16, 0)
	while true do
		helper_b9fff8e1()
		helper_19034()
	end
end

--- Reacts to a hit while greyed out, or to a hit that greys it out.
function script.on_status_hit()
	local var0: s32 = 0
	helper_5d37e9f4()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	var0 = 1
	while var0 ~= 0 do
		var0 = monster.get_status_ailments(40) or var0
		helper_b9fff8e1()
	end
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	monster.set_monster_attributes(16, 0)
	helper_5d37e9f4()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_cbe4d8e2()
	helper_20ea05b8(12)
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	monster.set_monster_attributes(16, 0)
	helper_fd16d93e()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_cbe4d8e2()
	helper_20ea05b8(12)
	monster.set_motion("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	monster.set_monster_attributes(16, 0)
	helper_ab4b367a()
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	monster.set_monster_attributes(16, 0)
	helper_49610f43()
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	monster.set_monster_attributes(16, 0)
	helper_49610f43()
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	monster.set_variable(64, 1)
	helper_02ce7891()
	monster.set_motion("死に", -1, 6)
	helper_56d63eae()
	monster.request_event_script(600)
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		helper_b9fff8e1()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_d375874f()
	monster.stop_moving()
	monster.end_throw()
	helper_20ea05b8(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	helper_cbe4d8e2()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	monster.set_monster_attributes(16, 0)
	helper_d30a9fa2()
	monster.set_motion("ダメージ", -1, 6)
	helper_20ea05b8(12)
	helper_e05438b5()
end

return script
