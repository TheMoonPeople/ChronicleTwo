--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_33f5143b = require("@lib/event/helper_33f5143b")
local helper_8ab07f4b = require("@lib/event/helper_8ab07f4b")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_be16759c = require("@lib/event/helper_be16759c")

--- Helper function.
local function helper_c89f2a72(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var1 = event.GetEventData_2(13) or var1
		player_chara = event.GetControlChrid() or player_chara
		now_map_no = event.GetNowMapNo() or now_map_no
		do
			local out1, out2 = event.GetMenuEtc_3(6)
			var4 = out1 or var4
			var5 = out2 or var5
		end
		if 0 < var4 then
			return 1
		end
		if var5 == 1 then
			helper_125385ee(arg0, 1)
			event.MesMake_2(arg0, "Wenn du mir keine Kn[UNI00fc]ller lieferst,\nkann ich dir nichts geben!")
			if now_map_no == 22 then
				at = 1
				helper_b5a98ffa(arg0, -1, var1, player_chara, 0)
			else
				at = 2
				helper_9e7d1511(arg0, -1, 3, 256, 208)
			end
		end
		if var5 == 2 then
			helper_125385ee(arg0, 1)
			event.MesMake_2(
				arg0,
				"Deine Fotografie-Stufe h[UNI00e4]ngt ab\nvon der Anzahl Ideen und Kn[UNI00fc]ller,\ndie du hast.<page>Je weiter deine Stufe steigt, umso\nmehr coole Belohnungen kriegst du."
			)
			if now_map_no == 22 then
				at = 3
				helper_b5a98ffa(arg0, -1, var1, player_chara, 0)
			else
				at = 4
				helper_9e7d1511(arg0, -1, 3, 256, 208)
			end
		end
		return 0
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_33f5143b(arg0, -1, 3, 256, 208)
			end
			if at <= 2 then
				helper_8ab07f4b(arg0, 1)
				helper_be16759c(arg0, -1, var1, player_chara, 0)
			end
			if at <= 3 then
				helper_33f5143b(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

return helper_c89f2a72
