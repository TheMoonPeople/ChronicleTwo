--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6982de90 = require("@lib/event/helper_6982de90")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_be16759c = require("@lib/event/helper_be16759c")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_dc8bbe30 = require("@lib/event/helper_dc8bbe30")

--- Helper function.
local function helper_89fadc79(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.SetMesPreset(0, 0)
		at = 1
		helper_c8484b43(arg0, 0, 0)
		var2 = event.GetMenuEtc_2(0) or var2
		var3 = event.GetCnt(19) or var3
		print("start=", var3, ",now=", var2, ",clear=", vm.i32(var2 - var3), "\n")
		if vm.i32(var2 - var3) < 10 then
			event.MesMake_2(0, "Ancora non mi sento bene.")
			at = 2
			helper_b5a98ffa(0, -1, arg0, arg1, 0)
			event.MesMake_2(
				0,
				"Sar[UNI00e0] qualcosa\ndi grave?<page>Forse neppure il Dottor Dell\npu[UNI00f2] aiutarmi ormai..."
			)
			at = 3
			helper_b5a98ffa(0, -1, arg0, arg1, 0)
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Salve!<page>Come mi sento? Benissimo!")
		at = 4
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "[UNI00c8] incredibile, sto molto meglio.<page>Il mondo [UNI00e8] tornato a posto.")
		at = 5
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"Oh s[UNI00ec], volevate un favore...<page>Far[UNI00f2] il possibile per aiutarvi.<page>Voi mi avete aiutato,\nquindi io aiuter[UNI00f2] voi."
		)
		at = 6
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetMotion(arg0, "立ち")
		at = 7
		helper_6982de90()
		event.Finish()
		event.SetQuestEtc(1, 17, 1)
		return
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
			end
			if at <= 1 then
				print("start=", var3, ",now=", var2, ",clear=", var2 - var3, "\n")
				helper_be16759c(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_be16759c(0, -1, arg0, arg1, 0)
			end
			return 0
		end
		if at <= 7 then
			if at <= 4 then
				helper_be16759c(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_be16759c(0, -1, arg0, arg1, 0)
			end
			if at <= 6 then
				helper_dc8bbe30()
			end
			return 0
		end
		return nil
	end)
end

return helper_89fadc79
