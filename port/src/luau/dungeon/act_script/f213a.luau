--!strict
-- dungeon/act_script/f213a.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1512c7e0 = require("@lib/action/helper_1512c7e0")
local helper_1eb83da1 = require("@lib/action/helper_1eb83da1")
local helper_37f14ce7 = require("@lib/action/helper_37f14ce7")
local helper_42e38fa0 = require("@lib/action/helper_42e38fa0")
local helper_9559fe61 = require("@lib/action/helper_9559fe61")
local helper_9da84b8b = require("@lib/action/helper_9da84b8b")

--- Helper function.
local function helper_f90()
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local front_x: f32 = 0
	local front_y: f32 = 0
	local front_z: f32 = 0
	local var10: s32 = 0
	local monster_id: s32 = 0
	action.get_program_value()
	action.play_motion("攻撃２", -1, 6)
	vm.wait()
	helper_9559fe61(vm.f32(0.4), vm.f32(0.45))
	var10 = action.get_weapon_attack(0) or var10
	do
		local out1, out2, out3 = action.get_object_position("col_magic")
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	do
		local out1, out2, out3 = action.get_facing_direction()
		front_x = out1 or front_x
		front_y = out2 or front_y
		front_z = out3 or front_z
	end
	monster_id = action.get_monster_form_id() or monster_id
	if monster_id == 44 then
		action.create_effect_1("火弾Ｌ３")
	end
	if monster_id == 45 then
		action.create_effect_1("風弾Ｌ２")
	end
	if monster_id == 46 then
		action.create_effect_1("氷弾Ｌ２")
	end
	if monster_id == 47 then
		action.create_effect_1("雷弾Ｌ２")
	end
	action.set_effect_first_vector(-1, var4, var5, var6)
	action.set_effect_second_vector(-1, front_x, front_y, front_z)
	action.set_effect_value(-1, 0, var10)
	action.set_effect_value_float(-1, 1, 10.0)
	helper_9da84b8b()
	action.set_program_value(0)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the character up when its script is initialised.
function script.init()
	action.add_motion_damage("col_ha", "", "モンスター攻撃", 3.5, 1.0, "攻撃１", 0.32, 0.42)
	action.set_move_speed(3.4)
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
			helper_1eb83da1()
		end
		if prog >= 200 and prog < 299 then
			action.turn_toward_target(40.0, 5.0)
			helper_f90()
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
