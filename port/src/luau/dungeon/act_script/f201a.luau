--!strict
-- dungeon/act_script/f201a.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1512c7e0 = require("@lib/action/helper_1512c7e0")
local helper_1eb83da1 = require("@lib/action/helper_1eb83da1")
local helper_37f14ce7 = require("@lib/action/helper_37f14ce7")
local helper_42e38fa0 = require("@lib/action/helper_42e38fa0")

--- Helper function.
local function helper_11b4()
	local var1: s32 = 0
	local prog: s32 = 0
	local var4: f32 = 0
	prog = action.get_program_value() or prog
	if prog == 200 then
		action.play_motion("避け攻撃", -1, 6)
		vm.wait()
		var4 = action.get_motion_progress() or var4
		if var4 >= vm.f32(0.01) and var4 <= vm.f32(0.3) then
			action.set_move_impulse(2.0, 0.0, 2)
		end
		var1 = action.get_motion_status() or var1
		if var1 == 4 then
			action.set_program_value(0)
		end
		return
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the character up when its script is initialised.
function script.init()
	action.add_object_frame(0, "dcol00")
	action.add_object_frame(1, "ef00")
	action.add_object_frame(2, "bcol00")
	action.add_object_frame(3, "bcol01")
	action.add_object_frame(4, "keri_R")
	action.add_object_frame(5, "nage")
	action.add_motion_damage("dcol00", "", "モンスター攻撃", 2.5, 1.0, "攻撃１", 0.1, 0.9)
	action.add_motion_damage("dcol01", "", "モンス攻撃B", 2.5, 1.0, "避け攻撃", 0.3, 0.43)
	action.add_body_collision(2, 5.0)
	action.add_body_collision(3, 4.0)
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
			helper_11b4()
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
