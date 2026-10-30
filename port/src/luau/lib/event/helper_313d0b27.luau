--!strict
-- Shared event helper used by 42 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")

--- Helper function.
local function helper_313d0b27()
	local var0: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 1)
	do
		local out1, out2 = event.get_monster_talk_data_2()
		var0 = out1 or var0
		var1 = out2 or var1
	end
	if var1 < 0 then
		vm.wait(1)
		return
	end
	event.set_dungeon_pause_flags(4096, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.preload_monster_talk_messages()
	while true do
		argc = event.is_background_load_pending() or argc
		if argc == 0 then
			break
		else
			vm.wait(2)
		end
	end
	event.load_monster_talk_messages(0, 5)
	event.open_message_window_2(0, var1)
	helper_1c04a0eb(var0, -1, 0, 1)
	event.load_message_file(0, -1)
	event.set_dungeon_pause_flags(4096, 0)
end

return helper_313d0b27
