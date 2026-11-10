--!strict
-- dungeon/act_script/f204a.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

--- Helper function.
local function helper_438()
	local var1: s32 = 0
	local var3: s32 = 0
	action.call_command(7, var3) -- retail: command 7 is not registered
	if var3 == 100 then
		action.release_held_object("特攻", -1, 6)
		vm.wait()
		action.call_command(103, var1) -- retail: the handler rejects 1 arguments
		if var1 == 4 then
			action.call_command(6, 0) -- retail: command 6 is not registered
			helper_bac4ec65(8)
		end
		return
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the character up when its script is initialised.
function script.init()
	action.start_palette_flash(0, "dcol00")
	action.start_palette_flash(2, "bcol00")
	action.shake_camera(0, "基本攻撃", 2.5, "特攻", 0.1, 0.9)
	action.get_equipped_item(2, 5.0)
end

--- Runs the character's normal behaviour.
function script.loop()
	local var0: s32 = 0
	local var2: s32 = 0
	action.call_command(6, 0) -- retail: command 6 is not registered
	while true do
		action.call_command(7, var2) -- retail: command 7 is not registered
		action.set_program_value(var0) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		action.reset_script_entries_1()
		if var2 >= 100 and var2 < 199 then
			action.call_command(13) -- retail: command 13 is not registered
			helper_438()
		end
		action.call_command(7, var2) -- retail: command 7 is not registered
		if var2 == 0 then
			action.run_carry_movement()
			if bit32.band(var0, 32) ~= 0 then
				var2 = 100
			end
			action.call_command(6, var2) -- retail: command 6 is not registered
		end
		vm.wait()
	end
end

--- Reacts to a small hit.
function script.on_small_damage()
	action.get_button_state_1(0)
	action.call_command(35, 5.0, 0.0, 3) -- retail: the handler rejects 3 arguments
	action.call_command(33, 0) -- retail: the handler rejects 1 arguments
	action.release_held_object("ダメージ", -1, 2)
	helper_bac4ec65(8)
	action.call_command(6, 0) -- retail: command 6 is not registered
end

--- Reacts to a large hit.
function script.on_large_damage()
	action.get_button_state_1(0)
	action.call_command(35, 8.0, 0.0, 3) -- retail: the handler rejects 3 arguments
	action.call_command(33, 0) -- retail: the handler rejects 1 arguments
	action.release_held_object("ダメージ", -1, 2)
	helper_bac4ec65(8)
	action.call_command(6, 0) -- retail: command 6 is not registered
end

--- Follows up a melee hit that the character has landed.
function script.on_melee_hit()
	action.call_command(35, 3.0, 0.0, 4) -- retail: the handler rejects 3 arguments
	action.fire_magic_sword_shot(nil) -- retail: argument 1 is 0.0, which the handler reads as no string
	helper_bac4ec65(10)
	action.call_command(6, 0) -- retail: command 6 is not registered
end

return script
