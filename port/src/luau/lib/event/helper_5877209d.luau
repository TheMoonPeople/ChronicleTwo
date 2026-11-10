--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_5877209d(arg0: f32, arg1: f32, tex_block: s32)
	local var3: s32 = 0
	local mini_level: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local scale: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: s32 = 0
	local scale_2: f32 = 0
	var3 = 0
	while var3 < 48 do
		event.reset_event_sprite(var3)
		event.set_event_sprite_type(var3, 1)
		event.set_event_sprite_texture(var3, "sphida_bar", tex_block)
		event.set_event_sprite_texture_rect(var3, 64, 0, 32, 32)
		event.set_event_sprite_size(var3, 2, 2)
		event.set_event_sprite_color(var3, 128, 128, 128, 128)
		event.set_event_sprite_draw_pass(var3, 0)
		var3 = var3 + 1
	end
	mini_level = event.get_sphida_minimap_scale() or mini_level
	if mini_level == 0 then
		event.set_event_sprite_type(31, 0)
		event.set_event_sprite_texture_rect(31, 308, 146, 204, 30)
		event.set_event_sprite_draw_pass(31, 1)
		event.set_event_sprite_size(31, 204, 30)
		event.set_event_sprite_position(31, 120, 30)
	elseif mini_level == 2 then
		var3 = 0
		while var3 < 32 do
			event.set_event_sprite_color(var3, 128, 128, 128, 32)
			var3 = var3 + 1
		end
	end
	mini_level = 0
	do
		local out1, out2, out3 = event.get_character_position(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	var6 = vm.f32(var6 + 3.0)
	var15 = vm.f32(var15 + 3.0)
	scale = 600.0
	var11 = vm.f32(vm.sin(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
	var12 = vm.f32(20.0 * vm.sin(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)))
	var13 = vm.f32(vm.cos(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
	do
		local out1, out2, out3 = event.copy_vector(var11, var12, var13)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = event.scale_vector(var8, var9, var10, 30.0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	var3 = 1
	while true do
		do
			local out1, out2, out3 = event.add_vectors(var5, var6, var7, var8, var9, var10)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, var14, var15, var16, var5, var6, var7, 1)
			var19 = out1 or var19
			var20 = out2 or var20
			var21 = out3 or var21
			var22 = out4 or var22
			var23 = out5 or var23
			var24 = out6 or var24
			var29 = out7 or var29
		end
		if var29 >= 0 then
			do
				local out1, out2, out3 = event.copy_vector(-var11, -var12, -var13)
				var25 = out1 or var25
				var26 = out2 or var26
				var27 = out3 or var27
			end
			do
				local out1, out2, out3 = event.normalize_vector(var25, var26, var27)
				var25 = out1 or var25
				var26 = out2 or var26
				var27 = out3 or var27
			end
			do
				local out1, out2, out3 = event.scale_vector(var25, var26, var27, 3.0)
				var25 = out1 or var25
				var26 = out2 or var26
				var27 = out3 or var27
			end
			do
				local out1, out2, out3 = event.add_vectors(var19, var20, var21, var25, var26, var27)
				var19 = out1 or var19
				var20 = out2 or var20
				var21 = out3 or var21
			end
			var28 = event.get_distance_between(var14, var15, var16, var19, var20, var21) or var28
			scale = vm.f32(scale - var28)
			if scale <= 0.0 then
				break
			end
			while true do
				var28 = event.get_distance_between(var14, var15, var16, var19, var20, var21) or var28
				if var28 <= 20.0 then
					scale_2 = vm.f32(20.0 - var28)
					scale = vm.f32(scale - scale_2)
					do
						local out1, out2, out3 = event.copy_vector(var19, var20, var21)
						var14 = out1 or var14
						var15 = out2 or var15
						var16 = out3 or var16
					end
					break
				end
				do
					local out1, out2, out3 = event.add_vectors(var14, var15, var16, var11, var12, var13)
					var14 = out1 or var14
					var15 = out2 or var15
					var16 = out3 or var16
				end
				event.set_event_sprite_position(var3, var14, var15, var16)
				event.set_event_sprite_draw_pass(var3, 1)
				if vm.imod(var3, 6) == 0 then
					event.set_sphida_minimap_shot_line_point(mini_level, var14, var15, var16)
					mini_level = vm.i32(mini_level + 1)
				end
				var3 = var3 + 1
				if var3 >= 31 then
					break
				end
			end
			if var3 >= 31 then
				break
			end
			do
				local out1, out2, out3 = event.copy_vector(var22, var23, var24)
				var11 = out1 or var11
				var12 = out2 or var12
				var13 = out3 or var13
			end
			do
				local out1, out2, out3 = event.scale_vector(var11, var12, var13, scale_2)
				var11 = out1 or var11
				var12 = out2 or var12
				var13 = out3 or var13
			end
			do
				local out1, out2, out3 = event.add_vectors(var14, var15, var16, var11, var12, var13)
				var14 = out1 or var14
				var15 = out2 or var15
				var16 = out3 or var16
			end
			event.set_event_sprite_position(var3, var14, var15, var16)
			event.set_event_sprite_draw_pass(var3, 1)
			if vm.imod(var3, 6) == 0 then
				event.set_sphida_minimap_shot_line_point(mini_level, var14, var15, var16)
				mini_level = vm.i32(mini_level + 1)
			end
			var3 = var3 + 1
			if var3 >= 31 then
				break
			end
			do
				local out1, out2, out3 = event.copy_vector(var22, var23, var24)
				var11 = out1 or var11
				var12 = out2 or var12
				var13 = out3 or var13
			end
			do
				local out1, out2, out3 = event.scale_vector(var11, var12, var13, 20.0)
				var11 = out1 or var11
				var12 = out2 or var12
				var13 = out3 or var13
			end
			do
				local out1, out2, out3 = event.copy_vector(var22, var23, var24)
				var8 = out1 or var8
				var9 = out2 or var9
				var10 = out3 or var10
			end
			do
				local out1, out2, out3 = event.scale_vector(var8, var9, var10, scale)
				var8 = out1 or var8
				var9 = out2 or var9
				var10 = out3 or var10
			end
			do
				local out1, out2, out3 = event.copy_vector(var14, var15, var16)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
		else
			while var3 < 31 do
				do
					local out1, out2, out3 = event.add_vectors(var14, var15, var16, var11, var12, var13)
					var14 = out1 or var14
					var15 = out2 or var15
					var16 = out3 or var16
				end
				event.set_event_sprite_position(var3, var14, var15, var16)
				event.set_event_sprite_draw_pass(var3, 1)
				if vm.imod(var3, 6) == 0 then
					event.set_sphida_minimap_shot_line_point(mini_level, var14, var15, var16)
					mini_level = vm.i32(mini_level + 1)
				end
				var3 = var3 + 1
			end
			break
		end
	end
end

return helper_5877209d
