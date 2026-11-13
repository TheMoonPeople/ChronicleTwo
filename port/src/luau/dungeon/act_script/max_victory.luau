--!strict
--- Drives Max's victory pose after a battle is won.

local vm = require("@lib/vm")
local timing = require("@lib/action/timing")

--- Runs the victory pose program when the program value is 100.
local function run_victory_program()
	local motion_status: s32 = 0
	local program_value: s32 = 0
	action.call_command(7, program_value) -- retail: command 7 is not registered
	if program_value == 100 then
		action.call_command(103, motion_status) -- retail: the handler rejects 1 arguments
		if motion_status == 4 then
			action.release_held_object("戻り", -1, 6)
			action.call_command(6, 0) -- retail: command 6 is not registered
		end
		return
	end
end

--- Waits until a shot has been fired.
local function wait_for_shot()
	local shot_fired: s32 = 0
	while true do
		vm.wait()
		shot_fired = action.fire_shot() or shot_fired
		if shot_fired ~= 0 then
			return
		end
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the character's frames, attack damage, effects and sounds.
function script.init()
	action.start_palette_flash(0, "dcol00")
	action.start_palette_flash(1, "ef00")
	action.start_palette_flash(2, "bcol00")
	action.start_palette_flash(3, "bcol01")
	action.start_palette_flash(4, "keri_R")
	action.start_palette_flash(5, "nage")
	action.start_palette_flash(6, "gun")
	action.shake_camera(0, "基本攻撃", 2.5, "3連続レンチ1", 0.1, 0.9)
	action.shake_camera(0, "基本攻撃", 2.5, "3連続レンチ2", 0.1, 0.8)
	action.shake_camera(0, "基本攻撃", 2.5, "3連続レンチ3", 0.1, 0.8)
	action.shake_camera(0, "吹っ飛び攻撃", 2.5, "中距離攻撃", 0.5, 0.9)
	action.shake_camera(4, "基本攻撃", 2.0, "ダウン･蹴り", 0.35, 0.45)
	action.shake_camera(0, "吹っ飛び攻撃", 6.0, "ため攻撃", 0.3, 0.8)
	action.shake_camera(5, "投げ攻撃", 8.0, "持ち上げ", 0.15, 0.3)
	action.get_equipped_item(2, 5.0)
	action.get_equipped_item(3, 4.0)
	action.call_command(37, 0, 1, "3連続レンチ1", 0.25, "3連続レンチ3", 0.9) -- retail: the handler rejects 6 arguments
	action.call_command(37, 0, 1, "中距離攻撃", 0.4, "中距離攻撃", 0.9) -- retail: the handler rejects 6 arguments
	action.call_command(37, 0, 1, "ため攻撃", 0.0, "ため攻撃", 0.9) -- retail: the handler rejects 6 arguments
	action.get_buttons_released(0, 2)
	action.call_command(80, -2, "歩き", 0.07, 0.1) -- retail: command 80 is not registered
	action.call_command(80, -3, "歩き", 0.5, 0.55) -- retail: command 80 is not registered
	action.call_command(80, -2, "走り", 0.4, 0.5) -- retail: command 80 is not registered
	action.call_command(80, -3, "走り", 0.9, 1.0) -- retail: command 80 is not registered
	action.call_command(80, 400, "3連続レンチ1", 0.1, 0.2) -- retail: command 80 is not registered
	action.call_command(80, 401, "3連続レンチ2", 0.1, 0.3) -- retail: command 80 is not registered
	action.call_command(80, 402, "3連続レンチ3", 0.2, 0.3) -- retail: command 80 is not registered
	action.call_command(80, 403, "銃攻撃", 0.2, 0.3) -- retail: command 80 is not registered
	action.call_command(80, 400, "中距離攻撃", 0.3, 0.4) -- retail: command 80 is not registered
end

--- Plays the victory pose when the victory status bit is set.
function script.loop()
	local status_flags: s32 = 0
	local program_value: s32 = 0
	action.call_command(6, 0) -- retail: command 6 is not registered
	while true do
		action.call_command(7, program_value) -- retail: command 7 is not registered
		action.set_program_value(status_flags) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		action.reset_script_entries_1()
		if program_value >= 100 and program_value < 199 then
			run_victory_program()
		end
		action.call_command(7, program_value) -- retail: command 7 is not registered
		if program_value == 0 then
			action.run_carry_movement()
			if bit32.band(status_flags, 32) ~= 0 then
				action.release_held_object("勝利のポーズ", 0.6, 6)
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
	action.call_command(35, 5.0, 0.0, 10) -- retail: the handler rejects 3 arguments
	action.call_command(36) -- retail: the handler rejects 0 arguments
	action.call_command(33, 0) -- retail: the handler rejects 1 arguments
	action.release_held_object("吹っ飛び", -1, 6)
	wait_for_shot()
	timing.wait_frames(8)
	action.release_held_object("起き上がり", -1, 6)
	wait_for_shot()
	timing.wait_frames(2)
	action.call_command(6, 0) -- retail: command 6 is not registered
end

--- Recoils and fires the magic sword shot.
function script.on_melee_hit()
	action.get_button_state_1(0)
	action.call_command(35, 3.0, 0.0, 4) -- retail: the handler rejects 3 arguments
	action.fire_magic_sword_shot(nil) -- retail: argument 1 is 0.0, which the handler reads as no string
	timing.wait_frames(10)
	action.call_command(6, 0) -- retail: command 6 is not registered
end

return script
