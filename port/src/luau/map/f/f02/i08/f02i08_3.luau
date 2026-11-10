--!strict
-- map/f/f02/i08/f02i08_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_13169207 = require("@lib/event/helper_13169207")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_28199468 = require("@lib/event/helper_28199468")
local helper_4e19428d = require("@lib/event/helper_4e19428d")
local helper_4fba7aa8 = require("@lib/event/helper_4fba7aa8")
local helper_96495cf4 = require("@lib/event/helper_96495cf4")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_df618068 = require("@lib/event/helper_df618068")
local helper_e57060a0 = require("@lib/event/helper_e57060a0")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_1c2b8()
	local var0: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(
			0,
			"Geben wir ihm eine Wei[UNI00df]e\nWindblume, damit er nach dem\nWunderrezept kocht.<page>\n(Men[UNI00fc] [UNI00f6]ffnen mit (#).)"
		)
		at = 1
		var0 = helper_c292fa16(0, -1, 5, 256, 208, var0)
		if var0 == 1 then
			return 1
		else
			return 0
		end
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[2] :: number
			end
			return 1
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_1ef0d4b2

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local argc: s32 = 0
	helper_1ef0d4b2()
	flag = event.get_save_flag(320) or flag
	flag_2 = event.get_save_flag(324) or flag_2
	flag_3 = event.get_save_flag(364) or flag_3
	helper_13169207(0)
	if flag_3 == 1 then
		if flag == 0 then
			helper_28199468()
		else
			argc = event.get_owned_item_count(363) or argc
			if flag_2 == 0 and argc >= 1 then
				event.set_function_point_enabled("", "syumai", 1)
			end
		end
	end
	helper_13169207(1)
	event.reset_follow_camera(1, 0.0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	helper_13169207(0)
	helper_96495cf4()
	helper_13169207(1)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local var0: s32 = 0
	local item: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		at = 1
		vm.wait(1)
		event.set_character_motion(0, "立ち")
		var0 = event.get_triggered_event_data_2(6) or var0
		if var0 == 1 then
			at = 2
			if helper_1c2b8() ~= 0 then
				var0 = 2
			end
		end
		if var0 == 2 then
			event.open_use_item_menu(363)
			at = 3
			vm.wait(3)
			item = vmhost.used_item() or item
			if item == 363 then
				event.add_inventory_item(364)
				event.set_function_point_enabled("", "syumai", 0)
				event.fade_out_music(30)
				event.fade_out_screen(30)
				at = 4
				wait_frames(30)
				helper_13169207(0)
				at = 5
				helper_96495cf4()
				helper_13169207(1)
			elseif item > 0 then
				at = 6
				helper_df618068()
			end
		end
		return
	end, function(received: { any })
		if at <= 6 then
			if at == 2 then
				local _ = received[1] :: number
			end
			if at <= 1 then
				local _ = helper_4e19428d()
			end
			if at <= 2 then
				local _ = var0 == 1
				var0 = 2
			end
			if at <= 3 then
				wait_frames_skipping(30)
			end
			if at <= 4 then
				helper_238b5abc(0)
				at = 5
				helper_96495cf4()
				return vm.continue_with(function()
					helper_13169207(1)
					return
				end)
			end
			if at <= 5 then
				helper_238b5abc(1)
				helper_4fba7aa8()
			end
			return 0
		end
		return nil
	end)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_e57060a0

--- Event 13200, which map data, a script or the engine runs by number.
function script.event_13200()
	helper_13169207(0)
	helper_28199468()
	helper_13169207(1)
end

--- Event 13240, which map data, a script or the engine runs by number.
function script.event_13240()
	helper_13169207(0)
	helper_96495cf4()
	helper_13169207(1)
end

return script
