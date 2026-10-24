--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_20be1371 = require("@lib/event/helper_20be1371")
local helper_33f5143b = require("@lib/event/helper_33f5143b")
local helper_48c10ac3 = require("@lib/event/helper_48c10ac3")
local helper_8ab07f4b = require("@lib/event/helper_8ab07f4b")
local helper_8ea3e25b = require("@lib/event/helper_8ea3e25b")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")

--- Helper function.
local function helper_374f760f(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local argc: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var1 = event.GetEventData_2(13) or var1
		player_chara = event.GetControlChrid() or player_chara
		now_map_no = event.GetNowMapNo() or now_map_no
		argc = event.GetItemHaveNum(355) or argc
		if argc <= 0 then
			helper_125385ee(arg0, 1)
			event.MesMake_2(arg0, "Go get me a\nScoop Memo, will ya?")
			if now_map_no == 22 then
				at = 1
				helper_b5a98ffa(arg0, -1, var1, player_chara, 0)
			else
				at = 2
				helper_a3cc6850(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		do
			local out1, out2 = event.GetMenuEtc_3(5)
			var5 = out1 or var5
			var6 = out2 or var6
		end
		if var5 == var6 then
			helper_125385ee(arg0, 1)
			event.MesMake_2(arg0, "Looks like there's\nno more scoops to be had.")
			if now_map_no == 22 then
				at = 3
				helper_b5a98ffa(arg0, -1, var1, player_chara, 0)
			else
				at = 4
				helper_a3cc6850(arg0, -1, 3, 256, 208)
			end
			at = 5
			return helper_8ea3e25b(arg0)
		end
		var7 = event.GetMenuEtc_2(3) or var7
		if 0 < var7 then
			helper_125385ee(arg0, 8)
			event.SetMesValue(arg0, 1, var7)
			event.MesMake_2(arg0, "I figured out [Number1] more scoops.")
			event.SetMesDrawspeed(arg0, 0)
			at = 6
			helper_a3cc6850(arg0, -1, 8, 0, 0)
		end
		helper_125385ee(arg0, 1)
		var7 = event.GetMenuEtc_2(4) or var7
		if var7 <= 0 then
			event.MesMake_2(arg0, "Come on, man! Quit slackin'!\nWhere's all your new inside scoops?")
		else
			event.SetMesValue(arg0, 1, var7)
			event.MesMake_2(arg0, "Woo! You got [Number1] new scoops!\nI knew you had it in ya!")
		end
		if now_map_no == 22 then
			at = 7
			helper_b5a98ffa(arg0, -1, var1, player_chara, 0)
		else
			at = 8
			helper_a3cc6850(arg0, -1, 3, 256, 208)
		end
		at = 9
		return helper_8ea3e25b(arg0)
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_33f5143b(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 5 then
			if at <= 3 then
				helper_33f5143b(arg0, -1, 3, 256, 208)
			end
			return helper_20be1371(arg0)
		end
		if at <= 9 then
			if at <= 6 then
				helper_8ab07f4b(arg0, 1)
				helper_48c10ac3(arg0, -1, var1, player_chara, 0)
			end
			if at <= 7 then
				helper_33f5143b(arg0, -1, 3, 256, 208)
			end
			return helper_20be1371(arg0)
		end
		return nil
	end)
end

return helper_374f760f
