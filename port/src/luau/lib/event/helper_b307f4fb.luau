--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_375124ef = require("@lib/event/helper_375124ef")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b8950300 = require("@lib/event/helper_b8950300")

--- Helper function.
local function helper_b307f4fb(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_375124ef()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.ExtTyped(564, "iiF", 2, 322) or var2
	if var2 <= 0 then
		event.MesMake_2(
			0,
			"H[UNI00e9], je parie que tu n'as jamais\nattrap[UNI00e9] un Nonky ?<page>Ah ah. Tu dois [UNI00ea]tre vraiment\nnul en p[UNI00ea]che !"
		)
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 < vm.f32(0.6) then
		var3 = vm.ftoi(vm.f32(var2 * 100.0))
		event.SetMesValue(0, 1, var3)
		event.MesMake_2(0, "Ah ah ! Tu n'as attrap[UNI00e9] qu'un tout\npetit poisson de [数値１] cm !")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Tu ne m[UNI00e9]rites pas mon aide !<page>Tu ferais mieux de recommencer.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "...Oh, je t'avais sous-estim[UNI00e9].")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Un homme, [UNI00e7]a n'a qu'une parole.<page>Je vais [UNI00e9]couter ce que t'as [UNI00e0] dire."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Parle autant que tu veux !")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_375124ef()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 15, 1)
end

return helper_b307f4fb
