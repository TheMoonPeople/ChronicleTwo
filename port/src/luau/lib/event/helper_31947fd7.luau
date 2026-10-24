--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a35a9901 = require("@lib/event/helper_a35a9901")

--- Helper function.
local function helper_31947fd7(arg0: s32, arg1: s32, arg2: s32)
	local stream_playing: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		stream_playing = event.GetMesVoice() or stream_playing
		event.TrgPakuAnim(1)
		event.TrgPakuMotion(0)
		var7 = 0
		argc_2 = event.StreamGetStatus(1) or argc_2
		while true do
			if stream_playing ~= 0 then
				argc = event.StreamGetStatus(1) or argc
				if argc_2 ~= 0 and argc == 0 then
					event.TrgPakuAnim(0)
					event.TrgPakuMotion(2)
				end
				argc_2 = argc
			end
			var6 = helper_a35a9901(arg0, arg1)
			if var6 ~= 0 then
				if var6 == 2 then
					arg2 = 1
				else
					arg2 = 0
				end
				var7 = vm.i32(var7 + 1)
				break
			else
				at = 1
				vm.wait(1)
				var7 = vm.i32(var7 + 1)
			end
		end
		event.ResetPakuMotion()
		event.TrgPakuAnim(0)
		event.ResetPakuAnim()
		stream_playing = event.GetMesVoice() or stream_playing
		if stream_playing ~= 0 then
			event.StreamStop(1)
		end
		return var7, arg2
	end, function(received: { any })
		if at <= 1 then
			var7 = var7 + 1
			return var7, arg2
		end
		return nil, arg2
	end)
end

return helper_31947fd7
