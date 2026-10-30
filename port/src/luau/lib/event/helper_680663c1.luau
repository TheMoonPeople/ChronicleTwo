--!strict
-- Shared event helper used by 66 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_39af59c5 = require("@lib/event/helper_39af59c5")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local open_message = require("@lib/event/open_message")

--- Helper function.
local function helper_680663c1(arg0: s32)
	local var1: any = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: s32 = 0
	local active_chr_no_2: s32 = 0
	local max: s32 = 0
	local at: number = 0
	return vm.guard(function()
		open_message(0, 2200, 5, 0, 0)
		at = 1
		var1 = helper_39af59c5(0, 4, 4, 0)
		if var1 == 1 then
			var2 = 0
		end
		if var1 == 2 then
			var2 = 0
		end
		if var1 == 3 then
			var2 = 0
		end
		if var1 == -1 or var1 == 4 then
			var2 = 1
		end
		if var2 ~= 1 then
			var3 = 8
			var4 = 1
			while var4 < var1 do
				var3 = vm.i32(var3 * 2)
				var4 = vm.i32(var4 + 1)
			end
			event.set_message_selection_top_line(0, 0)
			if vm.i32(bit32.band(arg0, var3)) ~= 0 then
				at = 2
				helper_75684dd8(0, 2213, 5, 0, 0)
				var2 = 0
			else
				event.play_system_sound_effect(24)
				if bit32.band(arg0, 8) ~= 0 then
					active_chr_no = event.get_playable_character() or active_chr_no
					if active_chr_no == 0 or active_chr_no == 2 then
						at = 3
						helper_75684dd8(0, 2215, 5, 0, 0)
						event.set_character_status(0, 1, 0)
						event.add_character_hp_by_rate(0, -0.7)
					else
						at = 4
						helper_75684dd8(0, 2216, 5, 0, 0)
						event.set_character_status(1, 1, 0)
						event.add_character_hp_by_rate(1, -0.7)
					end
					var2 = 1
				end
				if bit32.band(arg0, 16) ~= 0 then
					at = 5
					helper_75684dd8(0, 2211, 5, 0, 0)
					event.set_nearest_treasure_box_state(0)
					do
						local out1, out2, out3, _ = event.get_dungeon_event_point(1)
						var6 = out1 or var6
						var7 = out2 or var7
						var8 = out3 or var8
					end
					var10 = event.get_sound_id(4) or var10
					event.play_sound_effect(var10, 11)
					event.create_dungeon_effect("爆発", var6, var7 + 4.0, var8, 5)
					var2 = 1
				end
				if bit32.band(arg0, 32) ~= 0 then
					active_chr_no_2 = event.get_playable_character() or active_chr_no_2
					if active_chr_no_2 == 3 then
						active_chr_no_2 = 1
					end
					event.add_weapon_durability(active_chr_no_2, 0, -999)
					event.add_weapon_durability(active_chr_no_2, 1, -999)
					do
						local _, out2 = event.get_weapon_absorption(active_chr_no_2, 0)
						max = out2 or max
					end
					event.add_weapon_absorption(active_chr_no_2, 0, vm.idiv(vm.i32(-max), 10))
					do
						local _, out2 = event.get_weapon_absorption(active_chr_no_2, 1)
						max = out2 or max
					end
					event.add_weapon_absorption(active_chr_no_2, 1, vm.idiv(vm.i32(-max), 10))
					at = 6
					helper_75684dd8(0, 2212, 5, 0, 0)
					var2 = 1
				end
			end
		end
		return var2, arg0
	end, function(received: { any })
		if at <= 6 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				var2 = 0
				var2 = 0
				var2 = 0
				var2 = 1
				var3 = 8
				var4 = 1
				var3 = var3 * 2
				local _ = var4 < var1
				var4 = var4 + 1
				helper_ee1c51d0(0, 2213, 5, 0, 0)
			end
			if at <= 2 then
				local _ = var2 ~= 1
				var2 = 0
				helper_ee1c51d0(0, 2215, 5, 0, 0)
			end
			if at <= 3 then
				helper_ee1c51d0(0, 2216, 5, 0, 0)
			end
			if at <= 4 then
				var2 = 1
				helper_ee1c51d0(0, 2211, 5, 0, 0)
			end
			if at <= 5 then
				var2 = 1
				local _ = active_chr_no_2 == 3
				active_chr_no_2 = 1
				helper_ee1c51d0(0, 2212, 5, 0, 0)
			end
			var2 = 1
			return var2, arg0
		end
		return nil, arg0
	end)
end

return helper_680663c1
