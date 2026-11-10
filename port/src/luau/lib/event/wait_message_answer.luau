--!strict
-- Shared event helper used by 771 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local message_step = require("@lib/event/message_step")

--- Waits for a message window's answer; returns the frames it waited and whether the expected answer was chosen.
local function wait_message_answer(window: any, answers: s32, chosen: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		var4 = 0
		while true do
			var3 = message_step(window, answers)
			if var3 ~= 0 then
				chosen = 0
				if answers == 1 and var3 == 2 then
					chosen = 1
				end
				if answers == 2 and var3 == 3 then
					chosen = 1
				end
				var4 = vm.i32(var4 + 1)
				break
			else
				at = 1
				vm.wait(1)
				var4 = vm.i32(var4 + 1)
			end
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		return var4, chosen
	end, function(received: { any })
		if at <= 1 then
			var4 = var4 + 1
			return var4, chosen
		end
		return nil, chosen
	end)
end

return wait_message_answer
