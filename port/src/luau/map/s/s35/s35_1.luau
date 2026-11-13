--!strict
--- Moon Flower Palace surfacing scenes leading into the dungeon.

local vm = require("@lib/vm")
local moon_flower_palace_surfacing = require("@lib/event/moon_flower_palace_surfacing")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.key_open() end

--- Plays the ring cutscene and loads d06e01.
function script.cutscene_ring()
	moon_flower_palace_surfacing.play_e612_ring_cutscene()
	event.load_dungeon_map("d06e01")
	event.load_event_script("d06e01/d06e01.stb", 506)
	vm.wait(2)
end
script[500] = script.cutscene_ring

--- Plays the warp cutscene and loads d06e01.
function script.cutscene_warp()
	moon_flower_palace_surfacing.play_e612_warp_cutscene()
	event.load_dungeon_map("d06e01")
	event.load_event_script("d06e01/d06e01.stb", 508)
	vm.wait(2)
end
script[502] = script.cutscene_warp

return script
