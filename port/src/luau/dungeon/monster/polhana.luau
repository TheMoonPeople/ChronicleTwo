--!strict
-- dungeon/monster/polhana.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_1924(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32, arg7: f32)
	local var8: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var13: f32 = 0
	var8 = 0
	while var8 < arg7 do
		var13 = vm.f32(
			vm.fdiv(vm.f32(vm.f32(vm.f32(arg4 - arg1) * 2.0) - vm.f32(vm.f32(arg6 * arg7) * arg7)), vm.f32(arg7 * 2.0))
		)
		y = arg1
		for var9 = 0, var8 - 1 do
			var13 = vm.f32(var13 + arg6)
			y = vm.f32(y + var13)
		end
		x = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg3 - arg0) * var8), arg7)) + arg0)
		z = vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg5 - arg2) * var8), arg7)) + arg2)
		if y < arg4 then
			y = arg4
		end
		monster.set_position(x, y, z)
		var8 = vm.i32(var8 + 1)
		vm.wait()
	end
end

--- Runs the monster's death.
local function on_death()
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local value: s32 = 0
	monster.stop_moving()
	helper_442b9962()
	monster.set_monster_attributes(86, 1)
	monster.set_life_int(0)
	monster.start_death()
	monster.spawn_death_effects()
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("ロボミサイル爆発")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_value(-1, 0, attack)
	value = monster.get_variable(1) or value
	if value == 1 then
		monster.set_effect_owner(-1, 0)
	end
	monster.play_sound(8)
	while true do
		vm.wait()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.register_entry_object(0, "hana_obj")
	monster.set_clip_distance(120.0)
	monster.set_monster_attributes(1, 1)
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	vm.wait()
	value = monster.get_variable(0) or value
	if value == 0 then
		monster.set_variable(0, 1)
		monster.set_variable(1, 0)
		monster.set_monster_attributes(4, 1)
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = monster.get_target_position()
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		do
			local out1, out2, out3 = monster.subtract_vectors(var8, var9, var10, pos_x, pos_y, pos_z)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		var7 = monster.get_vector_length(var8, 0.0, var10) or var7
		var7 = monster.get_target_distance() or var7
		if var7 < 80.0 then
			var7 = 80.0
		end
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, var7)
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		pos_y_2 = 0.0
		var11 = vm.f32(vm.f32(-0.8) + vm.f32(var7 * vm.f32(0.0001)))
		var12 = vm.f32(vm.f32(var7 / 16.0) + 6.0)
		helper_1924(pos_x, pos_y, pos_z, pos_x_2, pos_y_2, pos_z_2, var11, var12)
		monster.play_sound(6)
		monster.set_monster_attributes(4, 0)
		do
			local out1, out2, out3 = monster.get_point_from_facing(0.0, 16.0)
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		pos_y_2 = vm.f32(3.2)
		monster.move_toward_position(pos_x_2, pos_y_2, pos_z_2, 3.2, 3.2)
	end
	var14 = 0.0
	var15 = 0
	while var15 < 80 do
		if var15 >= 50 then
			if var15 == 50 then
				monster.start_palette_pulse(128, 128, 255, 4, 30)
			end
			var13 = vm.f32(vm.f32(vm.sin(var14) / 10.0) + 1.0)
			var14 = vm.f32(var14 + vm.f32(0.4))
			if var14 >= vm.f32(3.1415927) then
				monster.play_sound(7)
				var14 = 0.0
			end
			monster.set_scale(var13, var13, var13)
		end
		var15 = var15 + 1
		vm.wait()
	end
	on_death()
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_2() end

script.on_death = on_death

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	monster.stop_moving()
	monster.set_monster_attributes(4, 0)
	monster.set_monster_attributes(32, 1)
	monster.stop_palette_pulse()
	monster.set_variable(1, 1)
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	monster.stop_moving()
	monster.end_throw()
	monster.set_monster_attributes(32, 0)
	on_death()
end

--- Stuns the monster.
script.on_stun = on_death

return script
