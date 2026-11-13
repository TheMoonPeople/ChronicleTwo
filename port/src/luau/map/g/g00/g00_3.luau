--!strict
--- Event script for the g00 town that spawns its Georama character and handles villager talk.

local g00_town_shared_data = require("@lib/event/g00_town_shared_data")
local message = require("@lib/event/message")
local partner_talk = require("@lib/event/german/partner_talk")
local town_villagers = require("@lib/event/german/town_villagers")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing when the script loads.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = g00_town_shared_data.spawn_georama_character

--- Spawns the Georama character, resets the camera and fades in.
function script.default_event()
	g00_town_shared_data.spawn_georama_character()
	event.reset_follow_camera(1, 0.0)
	event.fade_in_screen(30)
end

--- Shows the stylish-clothes message when square is pressed.
function script.key_open()
	event.open_message_window_2(0, "お洒落")
	message.show(0, -1, 8, 0, 0)
end

--- Plays the villager conversation and then the companion menu.
function script.talk_to_villager()
	town_villagers.talk_to_villager()
	partner_talk.open_camp_companion_menu()
end
script[1000] = script.talk_to_villager

return script
