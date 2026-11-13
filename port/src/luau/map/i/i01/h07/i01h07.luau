--!strict
--- Palm Brinks house interior script that runs a grid toggle puzzle and villager dialogue.

local vm = require("@lib/vm")
local npc = require("@lib/event/npc")
local palm_brinks_house_h07 = require("@lib/event/palm_brinks_house_h07")
local wait = require("@lib/event/wait")

--- Shows the puzzle grid from above and toggles a cell and its four neighbors.
local function toggle_cell_and_neighbors(row: s32, column: s32)
	event.set_character_motion(0, "立ち")
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-5.74, 133.71, 0.0)
	event.set_camera_sequence_look_at(-143.54, 66.02, 0.0)
	wait.for_frame_count(45)
	palm_brinks_house_h07.toggle_grid_cell(row, column)
	palm_brinks_house_h07.toggle_grid_cell(vm.i32(row + 1), column)
	palm_brinks_house_h07.toggle_grid_cell(vm.i32(row - 1), column)
	palm_brinks_house_h07.toggle_grid_cell(row, vm.i32(column + 1))
	palm_brinks_house_h07.toggle_grid_cell(row, vm.i32(column - 1))
	wait.for_frame_count(45)
end

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
	toggle_cell_and_neighbors(0, 5)
end
script[401] = script.toggle_cell_0_5

--- Toggles the puzzle cell at row 0, column 4 and its neighbors.
function script.toggle_cell_0_4()
	toggle_cell_and_neighbors(0, 4)
end
script[402] = script.toggle_cell_0_4

--- Toggles the puzzle cell at row 0, column 3 and its neighbors.
function script.toggle_cell_0_3()
	toggle_cell_and_neighbors(0, 3)
end
script[403] = script.toggle_cell_0_3

--- Toggles the puzzle cell at row 0, column 2 and its neighbors.
function script.toggle_cell_0_2()
	toggle_cell_and_neighbors(0, 2)
end
script[404] = script.toggle_cell_0_2

--- Toggles the puzzle cell at row 0, column 1 and its neighbors.
function script.toggle_cell_0_1()
	toggle_cell_and_neighbors(0, 1)
end
script[405] = script.toggle_cell_0_1

--- Toggles the puzzle cell at row 0, column 0 and its neighbors.
function script.toggle_cell_0_0()
	toggle_cell_and_neighbors(0, 0)
end
script[406] = script.toggle_cell_0_0

--- Toggles the puzzle cell at row 1, column 6 and its neighbors.
function script.toggle_cell_1_6()
	toggle_cell_and_neighbors(1, 6)
end
script[407] = script.toggle_cell_1_6

--- Toggles the puzzle cell at row 1, column 5 and its neighbors.
function script.toggle_cell_1_5()
	toggle_cell_and_neighbors(1, 5)
end
script[408] = script.toggle_cell_1_5

--- Toggles the puzzle cell at row 1, column 4 and its neighbors.
function script.toggle_cell_1_4()
	toggle_cell_and_neighbors(1, 4)
end
script[409] = script.toggle_cell_1_4

--- Toggles the puzzle cell at row 1, column 3 and its neighbors.
function script.toggle_cell_1_3()
	toggle_cell_and_neighbors(1, 3)
end
script[410] = script.toggle_cell_1_3

--- Toggles the puzzle cell at row 1, column 2 and its neighbors.
function script.toggle_cell_1_2()
	toggle_cell_and_neighbors(1, 2)
end
script[411] = script.toggle_cell_1_2

--- Toggles the puzzle cell at row 1, column 1 and its neighbors.
function script.toggle_cell_1_1()
	toggle_cell_and_neighbors(1, 1)
end
script[412] = script.toggle_cell_1_1

--- Toggles the puzzle cell at row 1, column 0 and its neighbors.
function script.toggle_cell_1_0()
	toggle_cell_and_neighbors(1, 0)
end
script[413] = script.toggle_cell_1_0

--- Toggles the puzzle cell at row 0, column 6 and its neighbors.
function script.toggle_cell_0_6()
	toggle_cell_and_neighbors(0, 6)
end
script[414] = script.toggle_cell_0_6

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = npc.talk_to_triggered_npc

return script
