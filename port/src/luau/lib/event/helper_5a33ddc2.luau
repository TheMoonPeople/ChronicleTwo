--!strict
-- Shared event helper used by 455 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")

--- Helper function.
local function helper_5a33ddc2(arg0: s32, arg1: any, arg2: any)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local loud: s32 = 0
	local var9: s32 = 0
	event.set_message_button_prompt(arg0, 0)
	event.trigger_mouth_texture_animation(1)
	event.trigger_mouth_motion(0)
	var6 = 0
	argc_2 = event.get_voice_stream_state(1) or argc_2
	loud = 0
	var9 = 1
	while var9 ~= 0 do
		argc_2 = argc
		argc = event.get_voice_stream_state(1) or argc
		if argc_2 ~= 0 and argc == 0 then
			event.trigger_mouth_motion(2)
			if arg1 == -1 then
				var9 = 0
			end
		end
		var7 = loud
		loud = event.is_voice_stream_audible(1) or loud
		if var7 == 0 and loud == 1 then
			event.trigger_mouth_texture_animation(1)
		end
		if var7 == 1 and loud == 0 then
			event.trigger_mouth_texture_animation(0)
		end
		vm.wait(1)
		var6 = vm.i32(var6 + 1)
		if arg1 ~= -1 then
			if arg1 <= var6 then
				var9 = 0
			end
		end
		if arg2 == var6 then
			close_message(arg0)
		end
	end
	event.reset_mouth_motions()
	event.trigger_mouth_texture_animation(0)
	event.reset_mouth_texture_animations()
	event.set_message_button_prompt(arg0, 1)
end

return helper_5a33ddc2
