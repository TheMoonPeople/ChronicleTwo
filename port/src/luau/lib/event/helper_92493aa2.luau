--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2a0361d4 = require("@lib/event/helper_2a0361d4")
local helper_2f6f8a35 = require("@lib/event/helper_2f6f8a35")
local helper_52115bbf = require("@lib/event/helper_52115bbf")
local helper_649c18cd = require("@lib/event/helper_649c18cd")
local helper_975c8257 = require("@lib/event/helper_975c8257")
local helper_99d04251 = require("@lib/event/helper_99d04251")
local helper_c8c8b790 = require("@lib/event/helper_c8c8b790")
local helper_fd3a2124 = require("@lib/event/helper_fd3a2124")

--- Helper function.
local function helper_92493aa2()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local stage_id: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local position_x_2: f32 = 0
	local position_y_2: f32 = 0
	local position_z_2: f32 = 0
	local at: number = 0
	return vm.guard(function()
		active_chr_no = event.get_playable_character() or active_chr_no
		helper_52115bbf()
		if active_chr_no == 0 then
			at = 1
			helper_99d04251()
		end
		if active_chr_no == 1 then
			at = 2
			helper_2f6f8a35()
		end
		if active_chr_no == 2 or active_chr_no == 3 then
			at = 3
			helper_649c18cd(active_chr_no)
		end
		var1 = event.is_e3_version() or var1
		if var1 ~= 1 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			event.get_dungeon_floor()
			if stage_id ~= 3 then
				helper_fd3a2124(0)
				do
					local out1, out2, out3 = event.get_previous_camera_next_position()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				event.set_camera_position(position_x, position_y, position_z)
				do
					local out1, out2, out3 = event.get_previous_camera_next_look_at()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				event.set_camera_look_at(position_x, position_y, position_z)
				event.set_message_window_mode(0, 4)
				event.set_message_draw_speed(0, 1)
				at = 4
				helper_c8c8b790(0, 2100, 8, 0, 0)
				event.set_message_window_mode(0, 1)
				event.set_message_draw_speed(0, 0)
			end
		end
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.set_camera_position(position_x_2, position_y_2, position_z_2)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.set_camera_look_at(position_x_2, position_y_2, position_z_2)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		at = 5
		helper_c8c8b790(0, 2130, 8, 0, 0)
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 5 then
			if at <= 1 then
				at = 2
				helper_2f6f8a35()
				return vm.continue_with(function()
					if active_chr_no == 2 or active_chr_no == 3 then
						at = 3
						helper_649c18cd(active_chr_no)
					end
					var1 = event.is_e3_version() or var1
					if var1 ~= 1 then
						stage_id = event.get_dungeon_stage_id() or stage_id
						event.get_dungeon_floor()
						if stage_id ~= 3 then
							helper_fd3a2124(0)
							do
								local out1, out2, out3 = event.get_previous_camera_next_position()
								position_x = out1 or position_x
								position_y = out2 or position_y
								position_z = out3 or position_z
							end
							event.set_camera_position(position_x, position_y, position_z)
							do
								local out1, out2, out3 = event.get_previous_camera_next_look_at()
								position_x = out1 or position_x
								position_y = out2 or position_y
								position_z = out3 or position_z
							end
							event.set_camera_look_at(position_x, position_y, position_z)
							event.set_message_window_mode(0, 4)
							event.set_message_draw_speed(0, 1)
							at = 4
							helper_c8c8b790(0, 2100, 8, 0, 0)
							event.set_message_window_mode(0, 1)
							event.set_message_draw_speed(0, 0)
						end
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						position_x_2 = out1 or position_x_2
						position_y_2 = out2 or position_y_2
						position_z_2 = out3 or position_z_2
					end
					event.set_camera_position(position_x_2, position_y_2, position_z_2)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						position_x_2 = out1 or position_x_2
						position_y_2 = out2 or position_y_2
						position_z_2 = out3 or position_z_2
					end
					event.set_camera_look_at(position_x_2, position_y_2, position_z_2)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					at = 5
					helper_c8c8b790(0, 2130, 8, 0, 0)
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.finish_event()
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_649c18cd(active_chr_no)
				return vm.continue_with(function()
					var1 = event.is_e3_version() or var1
					if var1 ~= 1 then
						stage_id = event.get_dungeon_stage_id() or stage_id
						event.get_dungeon_floor()
						if stage_id ~= 3 then
							helper_fd3a2124(0)
							do
								local out1, out2, out3 = event.get_previous_camera_next_position()
								position_x = out1 or position_x
								position_y = out2 or position_y
								position_z = out3 or position_z
							end
							event.set_camera_position(position_x, position_y, position_z)
							do
								local out1, out2, out3 = event.get_previous_camera_next_look_at()
								position_x = out1 or position_x
								position_y = out2 or position_y
								position_z = out3 or position_z
							end
							event.set_camera_look_at(position_x, position_y, position_z)
							event.set_message_window_mode(0, 4)
							event.set_message_draw_speed(0, 1)
							at = 4
							helper_c8c8b790(0, 2100, 8, 0, 0)
							event.set_message_window_mode(0, 1)
							event.set_message_draw_speed(0, 0)
						end
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						position_x_2 = out1 or position_x_2
						position_y_2 = out2 or position_y_2
						position_z_2 = out3 or position_z_2
					end
					event.set_camera_position(position_x_2, position_y_2, position_z_2)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						position_x_2 = out1 or position_x_2
						position_y_2 = out2 or position_y_2
						position_z_2 = out3 or position_z_2
					end
					event.set_camera_look_at(position_x_2, position_y_2, position_z_2)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					at = 5
					helper_c8c8b790(0, 2130, 8, 0, 0)
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.finish_event()
					return
				end)
			end
			if at <= 3 then
				helper_975c8257(0)
				helper_2a0361d4(0, 2100, 8, 0, 0)
			end
			if at <= 4 then
				helper_2a0361d4(0, 2130, 8, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

return helper_92493aa2
