--!strict
--- Holds the helpers that show and hide the painting in the Golden Paint painter house.


local i04_golden_paint_house = {}

--- Shows the painting while save flag 37 is clear.
function i04_golden_paint_house.refresh_paint_visibility()
	local save_flag: s32 = 0
	save_flag = event.get_save_flag(37) or save_flag
	i04_golden_paint_house.set_paint_visible(if save_flag == 0 then 1 else 0)
end

--- Attaches the painting map part and sets its visibility and function point state.
function i04_golden_paint_house.set_paint_visible(is_visible: s32)
	event.attach_object_handle_to_map_part_2(0, "p08_i04h03")
	event.set_object_handle_visible(0, is_visible)
	event.set_function_point_enabled("", "func0", is_visible)
end

return i04_golden_paint_house
