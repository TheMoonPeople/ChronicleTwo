--!strict
-- dungeon/monster/e223a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_01663a12 = require("@lib/monster/helper_01663a12")
local helper_09acbcc2 = require("@lib/monster/helper_09acbcc2")
local helper_0b6e560f = require("@lib/monster/helper_0b6e560f")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1be0f106 = require("@lib/monster/helper_1be0f106")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_2db2fc96 = require("@lib/monster/helper_2db2fc96")
local helper_2e729f21 = require("@lib/monster/helper_2e729f21")
local helper_362382c7 = require("@lib/monster/helper_362382c7")
local helper_3d0d0c5c = require("@lib/monster/helper_3d0d0c5c")
local helper_3df77102 = require("@lib/monster/helper_3df77102")
local helper_3e764841 = require("@lib/monster/helper_3e764841")
local helper_4077f308 = require("@lib/monster/helper_4077f308")
local helper_45797ccb = require("@lib/monster/helper_45797ccb")
local helper_461f64ff = require("@lib/monster/helper_461f64ff")
local helper_4772ab41 = require("@lib/monster/helper_4772ab41")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_57b569a8 = require("@lib/monster/helper_57b569a8")
local helper_57bfae69 = require("@lib/monster/helper_57bfae69")
local helper_5b414714 = require("@lib/monster/helper_5b414714")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a5c03b2 = require("@lib/monster/helper_6a5c03b2")
local helper_6fca5c97 = require("@lib/monster/helper_6fca5c97")
local helper_7ea3f35f = require("@lib/monster/helper_7ea3f35f")
local helper_83dc8947 = require("@lib/monster/helper_83dc8947")
local helper_895326d8 = require("@lib/monster/helper_895326d8")
local helper_905c94a1 = require("@lib/monster/helper_905c94a1")
local helper_9944827a = require("@lib/monster/helper_9944827a")
local helper_9d1ba522 = require("@lib/monster/helper_9d1ba522")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_ac26cdde = require("@lib/monster/helper_ac26cdde")
local helper_b3c03340 = require("@lib/monster/helper_b3c03340")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_d9999117 = require("@lib/monster/helper_d9999117")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")
local helper_e2fdabb9 = require("@lib/monster/helper_e2fdabb9")
local helper_f5727415 = require("@lib/monster/helper_f5727415")

--- Helper function.
local function helper_1cec()
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
local function helper_186e4()
	local var0: s32 = 0
	local var1: f32 = 0
	var1 = monster.get_random_whole_number(360.0) or var1
	monster.set_motion("歩き", -1, 0)
	helper_362382c7(var1, vm.f32(4.8))
	monster.set_motion("立ち", -1, 0)
	helper_45797ccb(9)
	var0 = helper_3e764841(300.0, 45.0, 45)
	if var0 == 1 then
		monster.set_motion("走り", -1, 0)
		helper_6fca5c97(3.0, vm.f32(4.8), 30.0, 5.0, 0, 150)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Helper function.
local function helper_18efc()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local attack: s32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("歩き", -1, 0)
	helper_f5727415(vm.f32(7.2000003))
	monster.set_motion("攻撃２", -1, 6)
	do
		local out1, out2, out3 = monster.get_frame_position("face")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	helper_9944827a(vm.f32(4.8), vm.f32(0.592), -1.0)
	monster.create_effect_1("氷弾Ｆ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	helper_4077f308(vm.f32(0.608), -1.0)
	monster.create_effect_1("氷弾Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	monster.set_effect_value(-1, 0, attack)
	helper_895326d8()
	monster.set_motion("立ち", -1, 0)
	helper_45797ccb(9)
end

--- Helper function.
local function helper_1b394()
	local argc: s32 = 0
	local var2: f32 = 0
	var2 = helper_e2fdabb9(var2)
	argc = monster.get_random(100) or argc
	if argc < 80 then
		argc = monster.get_random(100) or argc
		if argc < 20 then
			helper_186e4()
		else
			helper_18efc()
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 25 then
			monster.set_motion("歩き", -1, 0)
			helper_6a5c03b2(2.0, vm.f32(4.8), 120.0, 60)
			helper_6fca5c97(2.0, vm.f32(4.8), 30.0, 30.0, 0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			helper_3e764841(30.0, 45.0, 75)
		end
	end
end

--- Helper function.
local function helper_1abac()
	local argc: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	var4 = helper_e2fdabb9(var4)
	argc = monster.get_random(100) or argc
	if argc < 60 then
		helper_18efc()
	else
		argc = monster.get_random(100) or argc
		if argc < 30 then
			helper_186e4()
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				argc = monster.get_random(100) or argc
				var6 = monster.get_random_whole_number(60.0) or var6
				if argc < 50 then
					var6 = vm.f32(-var6 - 30.0)
				else
					var6 = vm.f32(var6 + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				helper_9d1ba522(2.0, vm.f32(4.8), var6, 60.0, 1.0, 30.0, 75)
				helper_f5727415(vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
				helper_45797ccb(9)
			else
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var7 = 1
					monster.set_motion("ステップ右", -1, 0)
				else
					var7 = 0
					monster.set_motion("ステップ左", -1, 0)
				end
				helper_01663a12(2.0, 30.0, 30.0, var7, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_18a6c()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	helper_f5727415(vm.f32(7.2000003))
	do
		local out1, out2, out3 = monster.get_target_position()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	monster.get_target_position(var0, var1, var2)
	var6 = helper_57bfae69(var0, var1, var2, var6)
	helper_0b6e560f(var3, var4, var5, 10.5, 10.0, 3.0, 27)
	helper_895326d8()
	monster.set_motion("立ち", -1, 0)
	helper_45797ccb(9)
end

--- Helper function.
local function helper_1a174()
	local argc: s32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	monster.get_life()
	argc = monster.get_random(100) or argc
	if argc < 65 then
		monster.set_motion("歩き", -1, 0)
		helper_b3c03340(2.0, vm.f32(4.8), 30.0, 30.0, 60)
		helper_18a6c()
		monster.set_motion("立ち", -1, 0)
	else
		argc = monster.get_random(100) or argc
		if argc < 15 then
			argc = monster.get_random(100) or argc
			var4 = monster.get_random_whole_number(60.0) or var4
			if argc < 50 then
				var4 = vm.f32(-var4 - 30.0)
			else
				var4 = vm.f32(var4 + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			helper_9d1ba522(2.0, vm.f32(4.8), var4, 60.0, 1.0, 30.0, 50)
			helper_f5727415(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
			helper_45797ccb(9)
		else
			monster.set_motion("歩き", -1, 0)
			helper_f5727415(vm.f32(4.8))
			argc = monster.get_random(100) or argc
			if argc < 67 then
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var5 = 1
					monster.set_motion("ステップ右", -1, 0)
				else
					var5 = 0
					monster.set_motion("ステップ左", -1, 0)
				end
				helper_01663a12(2.0, 30.0, 30.0, var5, 60)
				monster.set_motion("立ち", -1, 0)
			else
				helper_d9999117(2.0, 30.0, 30.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
end

--- Helper function.
local function helper_1b814()
	local var0: f32 = 0
	local priority: s32 = 0
	while true do
		helper_461f64ff()
		monster.get_life()
		helper_3d0d0c5c()
		var0 = helper_e2fdabb9(var0)
		if var0 > 300.0 then
			helper_461f64ff()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			helper_5b414714()
			continue
		end
		if var0 < 300.0 and var0 >= 200.0 then
			helper_1b394()
		elseif var0 < 200.0 and var0 >= 120.0 then
			helper_1abac()
		else
			helper_1a174()
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
	local var3: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.register_damage_hit("通常攻撃", 3.5, "攻撃１", 0.288, 0.408, 0)
	monster.register_damage_hit("通常攻撃", 3.5, "攻撃１", 0.288, 0.408, 1)
	monster.register_damage_hit("通常攻撃", 3.5, "攻撃１", 0.432, 0.696, 0)
	monster.register_damage_hit("通常攻撃", 3.5, "攻撃１", 0.432, 0.696, 1)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		var1 = monster.load_effect_script("氷弾Ｆ", get_not_used_texb) or var1
		var2 = monster.load_effect_script("氷弾Ｌ", get_not_used_texb) or var2
		var3 = monster.load_effect_script("氷弾Ｈ", get_not_used_texb) or var3
		if (if (if var1 ~= 0 then 1 else var2) ~= 0 then 1 else var3) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, pos_y + 20.0, pos_z)
	helper_1be0f106()
	helper_ac26cdde(45.0)
	helper_1cec()
	monster.set_variable(0, 0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var2: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		helper_461f64ff()
		helper_3d0d0c5c()
		var2 = helper_e2fdabb9(var2)
		if var2 < 300.0 then
			helper_1b814()
		else
			helper_3df77102()
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
	helper_895326d8()
	helper_45797ccb(12)
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_09acbcc2()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	helper_895326d8()
	monster.set_action_status(1)
	helper_45797ccb(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	helper_895326d8()
	monster.set_motion("立ち")
	helper_905c94a1()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	helper_45797ccb(8)
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.get_target_angle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, var0, 0.0)
	helper_461f64ff()
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.get_target_angle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, var0, 0.0)
	helper_461f64ff()
	monster.set_motion("歩き", -1, 0)
	helper_f5727415(vm.f32(4.8))
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_83dc8947()
	monster.set_motion("死に", -1, 2)
	helper_895326d8()
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	helper_2db2fc96()
	monster.set_motion("じたばた", -1, 4)
	while true do
		helper_461f64ff()
	end
	helper_7ea3f35f()
end

--- Lands the monster after it has been thrown.
function script.on_land()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	helper_4772ab41()
	monster.stop_moving()
	monster.end_throw()
	helper_45797ccb(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	helper_895326d8()
	helper_2e729f21()
	var3 = helper_57b569a8(var3)
	helper_461f64ff()
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, var3 + 10.0, pos_z)
	helper_461f64ff()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local height: f32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	helper_d30a9fa2()
	monster.set_monster_attributes(4, 0)
	monster.set_monster_attributes(8, 0)
	monster.set_motion("吹っ飛び", -1, 6)
	while true do
		height = monster.get_height_above_ground() or height
		if height < 10.0 then
			break
		else
			helper_461f64ff()
			var4 = monster.is_motion_finished() or var4
			if var4 ~= 0 then
				break
			end
		end
	end
	monster.set_motion("起き上がり", -1, 6)
	while true do
		height = monster.get_height_above_ground() or height
		if height < 10.0 then
			break
		else
			helper_461f64ff()
			var4 = monster.is_motion_finished() or var4
			if var4 ~= 0 then
				break
			end
		end
	end
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(8, 1)
	var5 = helper_57b569a8(var5)
	helper_461f64ff()
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, var5 + 10.0, pos_z)
	helper_461f64ff()
	helper_e05438b5()
end

return script
