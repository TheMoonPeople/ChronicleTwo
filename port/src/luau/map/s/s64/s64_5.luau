--!strict
--- Event script for a short map that plays Andrea's conversation with the sun and then loads the dungeon floor.

local moon_flower_palace_flashback_2 = require("@lib/event/moon_flower_palace_flashback_2")

--- Does nothing; the map needs no setup before it is entered.
local function initialize_map() end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

script.initialize_map = initialize_map
script[99] = script.initialize_map

--- Resets the follow camera and fades the screen in on entering the map.
function script.default_event()
	initialize_map()
	event.reset_follow_camera(1)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the engine runs this instead of its default.
function script.key_open() end

--- Plays the conversation between Andrea and the sun and then loads the dungeon map and its event script.
function script.cutscene_andrea_and_sun_conversation()
	moon_flower_palace_flashback_2.play_andrea_and_sun_conversation()
	event.skip_next_music_load()
	event.load_dungeon_map("d06b01")
	event.load_event_script("d06b01/d06b01.stb", 510)
end
script[500] = script.cutscene_andrea_and_sun_conversation

return script
