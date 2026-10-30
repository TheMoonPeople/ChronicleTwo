--!strict
-- dungeon/act_script/f49a.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1512c7e0 = require("@lib/action/helper_1512c7e0")
local helper_1eb83da1 = require("@lib/action/helper_1eb83da1")
local helper_37f14ce7 = require("@lib/action/helper_37f14ce7")
local helper_42e38fa0 = require("@lib/action/helper_42e38fa0")

--- Helper function.
local function helper_1004()
	local rate: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	rate = action.get_hp_ratio() or rate
	if rate < 0.5 then
		action.set_program_value(0)
		return
	end
	do
		local out1, out2, out3 = action.get_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	action.create_effect_1("爆発")
	action.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	action.set_effect_value(-1, 0, 2)
	action.set_hp_to_five_percent()
	action.set_program_value(0)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the character up when its script is initialised.
function script.init()
	action.add_motion_damage("dcol0", "", "モンスター攻撃", 2.5, 1.0, "攻撃１", 0.3, 0.5)
	action.add_motion_damage("dcol1", "", "モンスター攻撃", 2.5, 1.0, "攻撃１", 0.35, 0.45)
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
			helper_1004()
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
