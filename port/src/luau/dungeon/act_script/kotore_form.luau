--!strict
--- Drives the charging attack of the Kotore monster form.

local vm = require("@lib/vm")
local timing = require("@lib/action/timing")

--- Runs the charging attack when the program value is 100.
local function run_charge_attack()
	local motion_status: s32 = 0
	local program_value: s32 = 0
	action.call_command(7, program_value) -- retail: command 7 is not registered
	if program_value == 100 then
		action.release_held_object("特攻", -1, 6)
		vm.wait()
		action.call_command(103, motion_status) -- retail: the handler rejects 1 arguments
		if motion_status == 4 then
			action.call_command(6, 0) -- retail: command 6 is not registered
			timing.wait_frames(8)
		end
		return
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the character's frames, attack damage, effects and sounds.
function script.init()
	action.start_palette_flash(0, "dcol00")
	action.start_palette_flash(2, "bcol00")
	action.shake_camera(0, "基本攻撃", 2.5, "特攻", 0.1, 0.9)
	action.get_equipped_item(2, 5.0)
end

--- Runs the charging attack when the attack status bit is set.
function script.loop()
	local status_flags: s32 = 0
	local program_value: s32 = 0
	action.call_command(6, 0) -- retail: command 6 is not registered
	while true do
		action.call_command(7, program_value) -- retail: command 7 is not registered
		action.set_program_value(status_flags) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		action.reset_script_entries_1()
		if program_value >= 100 and program_value < 199 then
			action.call_command(13) -- retail: command 13 is not registered
			run_charge_attack()
		end
		action.call_command(7, program_value) -- retail: command 7 is not registered
		if program_value == 0 then
			action.run_carry_movement()
			if bit32.band(status_flags, 32) ~= 0 then
				program_value = 100
			end
			action.call_command(6, program_value) -- retail: command 6 is not registered
		end
		vm.wait()
	end
end

--- Staggers the character briefly.
function script.on_small_damage()
	action.get_button_state_1(0)
	action.call_command(35, 5.0, 0.0, 3) -- retail: the handler rejects 3 arguments
	action.call_command(33, 0) -- retail: the handler rejects 1 arguments
	action.release_held_object("ダメージ", -1, 2)
	timing.wait_frames(8)
	action.call_command(6, 0) -- retail: command 6 is not registered
end

--- Knocks the character back and stands it up again.
function script.on_large_damage()
	action.get_button_state_1(0)
	action.call_command(35, 8.0, 0.0, 3) -- retail: the handler rejects 3 arguments
	action.call_command(33, 0) -- retail: the handler rejects 1 arguments
	action.release_held_object("ダメージ", -1, 2)
	timing.wait_frames(8)
	action.call_command(6, 0) -- retail: command 6 is not registered
end

--- Recoils after a melee hit.
function script.on_melee_hit()
	action.call_command(35, 3.0, 0.0, 4) -- retail: the handler rejects 3 arguments
	action.fire_magic_sword_shot(nil) -- retail: argument 1 is 0.0, which the handler reads as no string
	timing.wait_frames(10)
	action.call_command(6, 0) -- retail: command 6 is not registered
end

return script
