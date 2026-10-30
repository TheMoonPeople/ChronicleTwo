--!strict
-- dungeon/monster/ejema.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05dbc6c9 = require("@lib/monster/helper_05dbc6c9")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_206033b2 = require("@lib/monster/helper_206033b2")
local helper_2db2fc96 = require("@lib/monster/helper_2db2fc96")
local helper_2e729f21 = require("@lib/monster/helper_2e729f21")
local helper_2f2adeb4 = require("@lib/monster/helper_2f2adeb4")
local helper_317bfc18 = require("@lib/monster/helper_317bfc18")
local helper_36608329 = require("@lib/monster/helper_36608329")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_48852a90 = require("@lib/monster/helper_48852a90")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_65df8bdc = require("@lib/monster/helper_65df8bdc")
local helper_68e24e97 = require("@lib/monster/helper_68e24e97")
local helper_72fec261 = require("@lib/monster/helper_72fec261")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_8191476b = require("@lib/monster/helper_8191476b")
local helper_83dc8947 = require("@lib/monster/helper_83dc8947")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_905c94a1 = require("@lib/monster/helper_905c94a1")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_a2d828a7 = require("@lib/monster/helper_a2d828a7")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_ac26cdde = require("@lib/monster/helper_ac26cdde")
local helper_b0ab6794 = require("@lib/monster/helper_b0ab6794")
local helper_b33c6f49 = require("@lib/monster/helper_b33c6f49")
local helper_beda02f3 = require("@lib/monster/helper_beda02f3")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d5ece76c = require("@lib/monster/helper_d5ece76c")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e2fdabb9 = require("@lib/monster/helper_e2fdabb9")
local helper_f2f4e524 = require("@lib/monster/helper_f2f4e524")
local helper_ff67a99d = require("@lib/monster/helper_ff67a99d")

--- Helper function.
local function helper_1c5c()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Helper function.
local function helper_18828()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local attack: s32 = 0
	local monster_id: s32 = 0
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	helper_48852a90(vm.f32(4.8), vm.f32(0.39), vm.f32(0.015))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol0")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_y = vm.f32(pos_y - 5.0)
	do
		local out1, out2, out3 = monster.get_rotation()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_target_position()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	var7 = vm.f32(var7 + 20.0)
	do
		local out1, out2, out3 = monster.subtract_vectors(var6, var7, var8, pos_x, pos_y, pos_z)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var6, var7, var8)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	monster_id = monster.get_monster_kind() or monster_id
	if monster_id >= 112 and monster_id <= 115 then
		monster.create_effect_1("火弾Ｆ")
	end
	if monster_id >= 116 and monster_id <= 119 then
		monster.create_effect_1("氷弾Ｆ")
	end
	if monster_id >= 120 and monster_id <= 123 then
		monster.create_effect_1("雷弾Ｆ")
	end
	if monster_id >= 124 and monster_id <= 127 then
		monster.create_effect_1("風弾Ｆ")
	end
	if monster_id >= 128 and monster_id <= 131 then
		monster.create_effect_1("聖弾Ｆ")
	end
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	helper_72fec261(vm.f32(0.42), vm.f32(0.015))
	if monster_id >= 112 and monster_id <= 115 then
		monster.create_effect_1("火弾Ｌ３")
	end
	if monster_id >= 116 and monster_id <= 119 then
		monster.create_effect_1("氷弾Ｌ２")
	end
	if monster_id >= 120 and monster_id <= 123 then
		monster.create_effect_1("雷弾Ｌ２")
	end
	if monster_id >= 124 and monster_id <= 127 then
		monster.create_effect_1("風弾Ｌ２")
	end
	if monster_id >= 128 and monster_id <= 131 then
		monster.create_effect_1("聖弾Ｌ２")
	end
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var6, var7, var8)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, 12.0)
	helper_56d63eae()
end

--- Helper function.
local function helper_1d308()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	if argc < 65 then
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(vm.f32(4.8))
		helper_18828()
		monster.set_motion("立ち", -1, 0)
		helper_c3e8ae39(15)
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			var1 = -45.0
		else
			var1 = 45.0
		end
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(vm.f32(4.8))
		monster.set_motion("歩き", -1, 0)
		var2 = monster.get_target_distance() or var2
		helper_65df8bdc(2.0, vm.f32(4.8), var1, var2, 35.0, 25.0, 60)
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(vm.f32(2.4))
		monster.set_motion("立ち", -1, 0)
		helper_7ca8a12f(35.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_18654()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.set_motion("歩き", -1, 0)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	helper_68e24e97(pos_x, pos_y, pos_z, 2.0, 0.0, 25.0, 30)
end

--- Helper function.
local function helper_197cc()
	local pos_y: f32 = 0
	local var4: f32 = 0
	helper_18654()
	monster.set_motion("ガードin", -1, 6)
	helper_f2f4e524(vm.f32(4.8))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	do
		local _, out2, _ = monster.get_target_position()
		var4 = out2 or var4
	end
	if pos_y < var4 then
		monster.set_motion("攻撃２", -1, 0)
		helper_36608329(vm.f32(5.6), vm.f32(4.8), 0.0, 40.0, 10)
		helper_d5ece76c(vm.f32(5.6), vm.f32(4.8), 0.0, 40.0, 0, 20)
	else
		monster.set_motion("攻撃２", -1, 0)
		helper_36608329(vm.f32(5.6), vm.f32(4.8), 0.0, 8.0, 10)
		helper_d5ece76c(vm.f32(5.6), vm.f32(4.8), 0.0, 8.0, 0, 20)
	end
	monster.set_motion("ガードout", -1, 6)
	helper_56d63eae()
end

--- Helper function.
local function helper_19d80(arg0: f32, arg1: f32, arg2: s32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(vm.f32(4.8))
	var9 = monster.get_target_distance() or var9
	var9 = vm.f32(var9 + arg0)
	arg1 = helper_787df986(arg1)
	var8 = monster.get_target_angle() or var8
	var8 = vm.f32(var8 - vm.f32(3.1415927))
	var8 = vm.f32(var8 + arg1)
	if var8 > vm.f32(3.1415927) then
		var8 = vm.f32(var8 - vm.f32(6.2831855))
	end
	if var8 <= vm.f32(-3.1415927) then
		var8 = vm.f32(var8 + vm.f32(6.2831855))
	end
	if arg2 == 1 then
		monster.set_motion("ステップ右", -1, 0)
	else
		monster.set_motion("ステップ左", -1, 0)
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var8) * var9))
	pos_y = vm.f32(pos_y - 10.0)
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var8) * var9))
	helper_68e24e97(pos_x, pos_y, pos_z, 4.0, 4.0, 5.0, vm.idiv(arg3, 2))
	helper_68e24e97(pos_x, pos_y, pos_z, 4.0, 4.0, 25.0, vm.idiv(arg3, 2))
end

--- Helper function.
local function helper_1a5f4()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(vm.f32(4.8))
		helper_19d80(50.0, 150.0, 1, 30)
	else
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(vm.f32(4.8))
		helper_19d80(50.0, -150.0, 0, 30)
	end
end

--- Helper function.
local function helper_1ca84()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 40 then
		helper_197cc()
	end
	argc = monster.get_random(100) or argc
	if argc < 60 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(vm.f32(4.8))
			helper_18828()
			monster.set_motion("立ち", -1, 0)
			helper_c3e8ae39(15)
		else
			helper_1a5f4()
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(vm.f32(9.6))
			helper_18828()
			monster.set_motion("立ち", -1, 0)
			helper_c3e8ae39(15)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			var2 = -45.0
		else
			var2 = 45.0
		end
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(vm.f32(4.8))
		monster.set_motion("歩き", -1, 0)
		var1 = monster.get_target_distance() or var1
		var1 = vm.f32(var1 + 10.0)
		helper_65df8bdc(2.0, vm.f32(4.8), var2, var1, 35.0, 25.0, 60)
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(vm.f32(2.4))
		monster.set_motion("立ち", -1, 0)
		helper_7ca8a12f(35.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_1a888(arg0: f32)
	local pos_y: f32 = 0
	local pos_x_2: f32 = 0
	local var6: f32 = 0
	local pos_z_2: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	monster.set_monster_attributes(32, 1)
	var8 = monster.get_target_distance() or var8
	do
		local out1, _, out3 = monster.get_target_rotation()
		pos_x_2 = out1 or pos_x_2
		pos_z_2 = out3 or pos_z_2
	end
	var10 = monster.get_random_whole_number(10.0) or var10
	var8 = vm.f32(var8 + vm.f32(30.0 + var10))
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	pos_x_2, var6, pos_z_2 = helper_125e5305(0.0, var8, pos_x_2, var6, pos_z_2)
	helper_c3e8ae39(helper_9df6409a(4))
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	helper_68e24e97(pos_x_2, pos_y, pos_z_2, arg0, vm.f32(arg0 + 1.0), 25.0, helper_9df6409a(10))
	monster.set_monster_attributes(32, 0)
	helper_56d63eae()
	monster.stop_moving()
end

--- Helper function.
local function helper_1c074()
	local argc: s32 = 0
	local var1: f32 = 0
	monster.get_life_int()
	argc = monster.get_random(100) or argc
	if argc < 90 then
		helper_197cc()
	end
	var1 = monster.get_target_distance() or var1
	if var1 < 40.0 then
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(vm.f32(4.8))
		helper_18828()
		monster.set_motion("立ち", -1, 0)
		helper_c3e8ae39(21)
	end
	argc = monster.get_random(100) or argc
	if argc < 60 then
		argc = monster.get_random(100) or argc
		if argc < 60 then
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(vm.f32(4.8))
			helper_18828()
			monster.set_motion("立ち", -1, 0)
			helper_c3e8ae39(15)
		else
			helper_1a5f4()
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(vm.f32(9.6))
			helper_18828()
			monster.set_motion("立ち", -1, 0)
			helper_c3e8ae39(15)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 30 then
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(vm.f32(4.8))
			helper_1a888(3.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(2.0)
			argc = monster.get_random(100) or argc
			if argc < 50 then
				helper_beda02f3(2.0, 215.0, 100.0, 35.0, 25.0, 20)
			else
				helper_beda02f3(2.0, 145.0, 100.0, 35.0, 25.0, 20)
			end
		end
	end
end

--- Helper function.
local function helper_1d8ac()
	local var3: f32 = 0
	local priority: s32 = 0
	while true do
		vm.wait()
		helper_8191476b()
		var3 = monster.get_target_distance() or var3
		if var3 > 350.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			helper_05dbc6c9()
			continue
		end
		if var3 < 350.0 and var3 >= 240.0 then
			helper_1d308()
		elseif var3 < 240.0 and var3 >= 140.0 then
			helper_1ca84()
		else
			helper_1c074()
		end
	end
end

--- Helper function.
local function helper_1ad2c()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	var4 = monster.get_target_distance() or var4
	monster.set_monster_attributes(32, 1)
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_motion("ステップ右", -1, 0)
		var5 = 60.0
	else
		monster.set_motion("ステップ左", -1, 0)
		var5 = -60.0
	end
	var1, var2, var3 = helper_125e5305(var5, var4, var1, var2, var3)
	helper_68e24e97(var1, vm.f32(var2 - 10.0), var3, 3.0, 3.0, 25.0, helper_9df6409a(10))
	monster.set_monster_attributes(32, 0)
	helper_b0ab6794(helper_9df6409a(30))
	monster.stop_moving()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local monster_id: s32 = 0
	local get_not_used_texb: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.register_damage_hit("吹っ飛び攻撃", 7.2, "攻撃２", 0.0, 0.5, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 7.2, "攻撃２", 0.5, 1.0, 1)
	monster_id = monster.get_monster_kind() or monster_id
	if monster_id >= 112 and monster_id <= 115 then
		get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
		if get_not_used_texb ~= -1 then
			var2 = monster.load_effect_script("火弾Ｆ", get_not_used_texb) or var2
			var3 = monster.load_effect_script("火弾Ｌ３", get_not_used_texb) or var3
			var4 = monster.load_effect_script("火弾Ｈ", get_not_used_texb) or var4
			if (if (if var2 ~= 0 then 1 else var3) ~= 0 then 1 else var4) ~= 0 then
				monster.reserve_texture_block()
			end
		end
	end
	if monster_id >= 116 and monster_id <= 119 then
		get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
		if get_not_used_texb ~= -1 then
			var2 = monster.load_effect_script("氷弾Ｆ", get_not_used_texb) or var2
			var3 = monster.load_effect_script("氷弾Ｌ２", get_not_used_texb) or var3
			var4 = monster.load_effect_script("氷弾Ｈ", get_not_used_texb) or var4
			if (if (if var2 ~= 0 then 1 else var3) ~= 0 then 1 else var4) ~= 0 then
				monster.reserve_texture_block()
			end
		end
	end
	if monster_id >= 120 and monster_id <= 123 then
		get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
		if get_not_used_texb ~= -1 then
			var2 = monster.load_effect_script("雷弾Ｆ", get_not_used_texb) or var2
			var3 = monster.load_effect_script("雷弾Ｌ２", get_not_used_texb) or var3
			var4 = monster.load_effect_script("雷弾Ｈ", get_not_used_texb) or var4
			if (if (if var2 ~= 0 then 1 else var3) ~= 0 then 1 else var4) ~= 0 then
				monster.reserve_texture_block()
			end
		end
	end
	if monster_id >= 124 and monster_id <= 127 then
		get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
		if get_not_used_texb ~= -1 then
			var2 = monster.load_effect_script("風弾Ｆ", get_not_used_texb) or var2
			var3 = monster.load_effect_script("風弾Ｌ２", get_not_used_texb) or var3
			var4 = monster.load_effect_script("風弾Ｈ", get_not_used_texb) or var4
			if (if (if var2 ~= 0 then 1 else var3) ~= 0 then 1 else var4) ~= 0 then
				monster.reserve_texture_block()
			end
		end
	end
	if monster_id >= 128 and monster_id <= 131 then
		get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
		if get_not_used_texb ~= -1 then
			var2 = monster.load_effect_script("聖弾Ｆ", get_not_used_texb) or var2
			var3 = monster.load_effect_script("聖弾Ｌ２", get_not_used_texb) or var3
			var4 = monster.load_effect_script("聖弾Ｈ", get_not_used_texb) or var4
			if (if (if var2 ~= 0 then 1 else var3) ~= 0 then 1 else var4) ~= 0 then
				monster.reserve_texture_block()
			end
		end
	end
	helper_b33c6f49()
	helper_ac26cdde(40.0)
	helper_1c5c()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, vm.f32(pos_y + 25.0) - 10.0, pos_z)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var1: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		monster.get_rage_hits_left()
		helper_8191476b()
		var1 = helper_e2fdabb9(var1)
		if var1 < 350.0 then
			helper_1d8ac()
		else
			helper_ff67a99d()
		end
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
		vm.wait()
	end
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5d37e9f4()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_56d63eae()
	helper_c3e8ae39(16)
	monster.set_motion("立ち", -1, 0)
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_a2d828a7()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 25)
	helper_56d63eae()
	monster.set_action_status(1)
	helper_c3e8ae39(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	monster.set_motion("立ち")
	helper_905c94a1()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.set_motion("ガード入り", -1, 6)
	helper_56d63eae()
	monster.set_motion("ガード", -1, 6)
	monster.start_knockback(3.0, 0.0, 2)
	helper_56d63eae()
	helper_c3e8ae39(8)
	monster.set_motion("ガード戻り", -1, 6)
	helper_56d63eae()
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_49610f43()
	monster.stop_moving()
	helper_442b9962()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	helper_93495fdf()
	vm.wait()
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(vm.f32(4.8))
	helper_1ad2c()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	monster.stop_moving()
	helper_442b9962()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(vm.f32(4.8))
	helper_1ad2c()
	helper_93495fdf()
	vm.wait()
	helper_56d63eae()
	monster.set_motion("よけるもどり", -1, 6)
	helper_56d63eae()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_83dc8947()
	monster.set_motion("死に", -1, 6)
	helper_56d63eae()
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	helper_2db2fc96()
	monster.set_motion("じたばた", -1, 4)
	helper_206033b2()
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_2f2adeb4()
	helper_317bfc18(1)
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	helper_2e729f21()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.set_motion("吹っ飛び", -1, 6)
	helper_56d63eae()
	monster.set_motion("吹っ飛びループ", -1, 6)
	helper_56d63eae()
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	monster.set_motion("気絶", -1)
	helper_e05438b5()
end

return script
