--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_95dae095 = require("@lib/event/helper_95dae095")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_be16759c = require("@lib/event/helper_be16759c")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_dc8bbe30 = require("@lib/event/helper_dc8bbe30")

--- Helper function.
local function helper_811dabdb(arg0: s32, arg1: s32)
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
			event.MesMake_2(0, "Todav[UNI00ed]a no me siento demasiado bien.")
			at = 2
			helper_b5a98ffa(0, -1, arg0, arg1, 0)
			event.MesMake_2(
				0,
				"A lo mejor es\nque me pasa algo de verdad.<page>Quiz[UNI00e1] ni siquiera\nel Dr. Dell pueda ayudarme..."
			)
			at = 3
			helper_b5a98ffa(0, -1, arg0, arg1, 0)
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "[UNI00a1]Hola!<page>[UNI00bf]Que c[UNI00f3]mo me siento? [UNI00a1]Como nunca!")
		at = 4
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"No me creo lo bien que me encuentro estos d[UNI00ed]as.<page>El mundo vuelve a estar como antes."
		)
		at = 5
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"Ah, s[UNI00ed], me hab[UNI00ed]as pedido un favor.<page>Te ayudar[UNI00e9] en lo que pueda.<page>T[UNI00fa] me has ayudado,\nas[UNI00ed] que te debo una."
		)
		at = 6
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetMotion(arg0, "立ち")
		at = 7
		helper_95dae095()
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

return helper_811dabdb
