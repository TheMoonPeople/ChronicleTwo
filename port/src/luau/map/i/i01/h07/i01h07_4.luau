--!strict
--- Palm Brinks house interior script that runs a grid toggle puzzle and villager dialogue.

local palm_brinks_house_h07 = require("@lib/event/palm_brinks_house_h07")
local villager_dialogue = require("@lib/event/italian/villager_dialogue")

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Resets the follow camera when the interior is entered.
function script.default_event()
	event.reset_follow_camera(1, 0.0, 10.0)
end

--- Prints the current map and submap numbers for debugging.
function script.key_open()
	local now_map_no: s32 = 0
	local now_sub_map_no: s32 = 0
	now_map_no = event.get_current_map() or now_map_no
	now_sub_map_no = event.get_current_submap() or now_sub_map_no
	print(
		"##########################map_no=",
		now_map_no,
		",submap_no=",
		now_sub_map_no,
		"###########################\n"
	)
end

--- Toggles the puzzle cell at row 0, column 5 and its neighbors.
function script.toggle_cell_0_5()
	palm_brinks_house_h07.toggle_cell_and_neighbors(0, 5)
end
script[401] = script.toggle_cell_0_5

--- Toggles the puzzle cell at row 0, column 4 and its neighbors.
function script.toggle_cell_0_4()
	palm_brinks_house_h07.toggle_cell_and_neighbors(0, 4)
end
script[402] = script.toggle_cell_0_4

--- Toggles the puzzle cell at row 0, column 3 and its neighbors.
function script.toggle_cell_0_3()
	palm_brinks_house_h07.toggle_cell_and_neighbors(0, 3)
end
script[403] = script.toggle_cell_0_3

--- Toggles the puzzle cell at row 0, column 2 and its neighbors.
function script.toggle_cell_0_2()
	palm_brinks_house_h07.toggle_cell_and_neighbors(0, 2)
end
script[404] = script.toggle_cell_0_2

--- Toggles the puzzle cell at row 0, column 1 and its neighbors.
function script.toggle_cell_0_1()
	palm_brinks_house_h07.toggle_cell_and_neighbors(0, 1)
end
script[405] = script.toggle_cell_0_1

--- Toggles the puzzle cell at row 0, column 0 and its neighbors.
function script.toggle_cell_0_0()
	palm_brinks_house_h07.toggle_cell_and_neighbors(0, 0)
end
script[406] = script.toggle_cell_0_0

--- Toggles the puzzle cell at row 1, column 6 and its neighbors.
function script.toggle_cell_1_6()
	palm_brinks_house_h07.toggle_cell_and_neighbors(1, 6)
end
script[407] = script.toggle_cell_1_6

--- Toggles the puzzle cell at row 1, column 5 and its neighbors.
function script.toggle_cell_1_5()
	palm_brinks_house_h07.toggle_cell_and_neighbors(1, 5)
end
script[408] = script.toggle_cell_1_5

--- Toggles the puzzle cell at row 1, column 4 and its neighbors.
function script.toggle_cell_1_4()
	palm_brinks_house_h07.toggle_cell_and_neighbors(1, 4)
end
script[409] = script.toggle_cell_1_4

--- Toggles the puzzle cell at row 1, column 3 and its neighbors.
function script.toggle_cell_1_3()
	palm_brinks_house_h07.toggle_cell_and_neighbors(1, 3)
end
script[410] = script.toggle_cell_1_3

--- Toggles the puzzle cell at row 1, column 2 and its neighbors.
function script.toggle_cell_1_2()
	palm_brinks_house_h07.toggle_cell_and_neighbors(1, 2)
end
script[411] = script.toggle_cell_1_2

--- Toggles the puzzle cell at row 1, column 1 and its neighbors.
function script.toggle_cell_1_1()
	palm_brinks_house_h07.toggle_cell_and_neighbors(1, 1)
end
script[412] = script.toggle_cell_1_1

--- Toggles the puzzle cell at row 1, column 0 and its neighbors.
function script.toggle_cell_1_0()
	palm_brinks_house_h07.toggle_cell_and_neighbors(1, 0)
end
script[413] = script.toggle_cell_1_0

--- Toggles the puzzle cell at row 0, column 6 and its neighbors.
function script.toggle_cell_0_6()
	palm_brinks_house_h07.toggle_cell_and_neighbors(0, 6)
end
script[414] = script.toggle_cell_0_6

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = villager_dialogue.talk_to_triggered_villager

return script
