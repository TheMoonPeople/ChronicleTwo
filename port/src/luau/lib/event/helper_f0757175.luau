--!strict
-- Shared event helper used by 105 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_250b314c = require("@lib/event/helper_250b314c")
local helper_ab0a8186 = require("@lib/event/helper_ab0a8186")
local helper_ba297414 = require("@lib/event/helper_ba297414")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_c8ef5bf1 = require("@lib/event/helper_c8ef5bf1")

--- Helper function.
local function helper_f0757175(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local var6: f32 = 0
	local player_chara: s32 = 0
	local var8: any = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		var6 = helper_c8484b43(arg0, arg4, arg5)
		player_chara = event.get_player_character_slot() or player_chara
		at = 2
		var8 = helper_c8ef5bf1(0, arg1, arg0, player_chara, arg2, arg3)
		at = 3
		helper_ab0a8186(arg0, var6, arg4, arg5)
		return var8
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var6 = received[1] :: number
			end
			if at == 2 then
				var8 = received[1] :: number
			end
			if at <= 1 then
				var8 = helper_250b314c(0, arg1, arg0, player_chara, arg2, arg3)
			end
			if at <= 2 then
				helper_ba297414(arg0, var6, arg4, arg5)
			end
			return var8
		end
		return nil
	end)
end

return helper_f0757175
