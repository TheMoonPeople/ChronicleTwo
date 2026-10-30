--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_684bf7e6 = require("@lib/event/helper_684bf7e6")

--- Helper function.
local function helper_db8bc11a()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local flag: s32 = 0
	var0 = event.get_save_counter(0) or var0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	var1 = 8
	event.clear_local_event_counters()
	var2 = 1
	while var2 <= 25 do
		var3 = event.get_npc_party_status(var2) or var3
		if var3 == 0 then
			var2 = var2 + 1
			continue
		end
		if bit32.band(var3, 4) ~= 0 then
			var2 = var2 + 1
			continue
		end
		var4 = event.get_villager_training_value(0, var2) or var4
		if var0 ~= var4 then
			var2 = var2 + 1
			continue
		end
		event.load_npc_character(1, 5, var2, var1)
		helper_684bf7e6(var1, var2)
		event.set_local_event_counter(var1, var2)
		event.set_scene_character_number(var1, var2)
		if bit32.band(var3, 1) ~= 0 then
			event.set_character_active(0, var1)
		else
			event.set_character_active(var1)
		end
		var1 = vm.i32(var1 + 1)
		var2 = var2 + 1
	end
	flag = event.get_save_flag(254) or flag
	if flag ~= 0 and var0 == 3 then
		event.load_character(5, "event/train/tp02_01a.gltf", "info", var1)
		event.set_character_position(var1, 0.0, 0.0, -200.0)
		event.set_character_rotation(var1, 0.0, 0.0, 0.0)
		event.set_character_motion(var1, "立ち", 4)
		event.set_local_event_counter(var1, 34)
		event.set_scene_character_number(var1, 34)
		event.set_character_active(var1)
	end
end

return helper_db8bc11a
