--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local message_step = require("@lib/event/message_step")

--- Helper function.
local function helper_34237bde(arg0: any, arg1: any)
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.set_message_button_prompt(arg0, 0)
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		var3 = 0
		while var3 < arg1 do
			var2 = message_step(arg0, 0)
			if var2 ~= 0 then
				var3 = vm.i32(var3 + 1)
				break
			else
				at = 1
				vm.wait(1)
				var3 = vm.i32(var3 + 1)
			end
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		event.set_message_button_prompt(arg0, 1)
		close_message(arg0)
		return
	end, function(received: { any })
		if at <= 1 then
			var3 = var3 + 1
			helper_d16eef1e(arg0)
			return var3
		end
		return nil
	end)
end

return helper_34237bde
