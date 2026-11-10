--!strict
-- map/s/s44/s44_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_38a7113b = require("@lib/event/helper_38a7113b")
local helper_4e838289 = require("@lib/event/helper_4e838289")
local helper_b2a546f8 = require("@lib/event/helper_b2a546f8")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_fed47f16 = require("@lib/event/helper_fed47f16")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.initialize_event()
	vm.wait(1)
	event.set_camera_sequence_position(31.07, 49.02, 53.789978)
	event.set_camera_sequence_look_at(-33.5, 41.8, 200.70001)
	vm.wait(2)
	helper_c956b4a2(64)
	event.clear_effect_manager()
	event.finish_event()
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_4e838289()
	event.jump_to_map_3(-1, "d06b03", 510)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_38a7113b()
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
	vm.wait(2)
	event.load_dungeon_map("d06b01")
	event.load_event_script("d06b01/d06b01.stb", 512)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	helper_fed47f16()
	event.jump_to_map_3(-1, "g05", 550)
	vm.wait(2)
end

--- Event 560, which map data, a script or the engine runs by number.
function script.event_560()
	helper_b2a546f8()
	event.jump_to_map_3(-1, "g05", 560)
	vm.wait(2)
end

--- Event 570, which map data, a script or the engine runs by number.
function script.event_570()
	local at: number = 0
	return vm.guard(function()
		at = 1
		helper_fed47f16()
		at = 2
		helper_b2a546f8()
		event.jump_to_map_3(-1, "g05", 560)
		at = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_b2a546f8()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "g05", 560)
					at = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 17440, which map data, a script or the engine runs by number.
script.event_17440 = helper_fed47f16

--- Event 17480, which map data, a script or the engine runs by number.
function script.event_17480()
	helper_b2a546f8()
	event.jump_to_map_3(-1, "g05", 560)
	vm.wait(2)
end

return script
