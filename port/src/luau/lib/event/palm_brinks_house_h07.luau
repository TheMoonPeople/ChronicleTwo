--!strict
--- Helpers for the grid puzzle of the Palm Brinks house.

local vm = require("@lib/vm")
local wait = vm.module("@lib/event/wait")

local palm_brinks_house_h07 = {}

--- Flips the grid cell and its four neighbours with the camera overhead.
function palm_brinks_house_h07.toggle_cell_and_neighbors(row: s32, column: s32)
	event.set_character_motion(0, "立ち")
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-5.74, 133.71, 0.0)
	event.set_camera_sequence_look_at(-143.54, 66.02, 0.0)
	wait.frames(45)
	palm_brinks_house_h07.toggle_grid_cell(row, column)
	palm_brinks_house_h07.toggle_grid_cell(vm.i32(row + 1), column)
	palm_brinks_house_h07.toggle_grid_cell(vm.i32(row - 1), column)
	palm_brinks_house_h07.toggle_grid_cell(row, vm.i32(column + 1))
	palm_brinks_house_h07.toggle_grid_cell(row, vm.i32(column - 1))
	wait.frames(45)
end

--- Flips the visibility of the map part at the given grid cell.
function palm_brinks_house_h07.toggle_grid_cell(row: s32, column: s32)
	local cell_index: s32 = 0
	local visible: s32 = 0
	if row < 0 or 1 < row or column < 0 or 6 < column then
		return
	end
	cell_index = row * 7 + column
	if cell_index == 0 then
		event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m7")
	end
	if cell_index == 7 then
		event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m21")
	end
	if cell_index == 1 then
		event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m8")
	end
	if cell_index == 8 then
		event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m20")
	end
	if cell_index == 2 then
		event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m9")
	end
	if cell_index == 9 then
		event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m19")
	end
	if cell_index == 3 then
		event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m10")
	end
	if cell_index == 10 then
		event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m18")
	end
	if cell_index == 4 then
		event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m11")
	end
	if cell_index == 11 then
		event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m17")
	end
	if cell_index == 5 then
		event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m12")
	end
	if cell_index == 12 then
		event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m16")
	end
	if cell_index == 6 then
		event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m14")
	end
	if cell_index == 13 then
		event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m15")
	end
	visible = event.is_object_handle_visible(0) or visible
	event.set_object_handle_visible(0, if visible == 0 then 1 else 0)
end

return palm_brinks_house_h07
