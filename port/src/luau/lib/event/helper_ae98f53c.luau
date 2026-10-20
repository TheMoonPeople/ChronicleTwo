--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1f514f60 = require("@lib/event/helper_1f514f60")
local helper_3e3329d3 = require("@lib/event/helper_3e3329d3")
local helper_e5219064 = require("@lib/event/helper_e5219064")
local helper_eb560126 = require("@lib/event/helper_eb560126")

--- Helper function.
local function helper_ae98f53c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_1f514f60()
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_3e3329d3()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = helper_1f514f60()
	if 0 < var2 then
		event.MesMake_2(0, "Al parecer, todav[UNI00ed]a\nte queda mucho por aprender.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Tengo depositada una gran confianza en ti,\npero me temo que por el momento\nno podr[UNI00e9] ayudarte."
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Muy bien hecho.\nEspl[UNI00e9]ndido.<page>Estoy convencido de que cumplir[UNI00e1]s con creces mis expectativas.<page>[UNI00bf]Lo he prometido, no?\nTe acompa[UNI00f1]ar[UNI00e9]."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_3e3329d3()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 13, 1)
end

return helper_ae98f53c
