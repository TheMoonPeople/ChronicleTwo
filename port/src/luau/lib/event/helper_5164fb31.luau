--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_d3a581d1 = require("@lib/event/helper_d3a581d1")
local helper_dae2ac4c = require("@lib/event/helper_dae2ac4c")

--- Helper function.
local function helper_5164fb31(arg0: s32, arg1: s32)
	local photo: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_d3a581d1()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	photo = event.CheckInventPhoto(193) or photo
	if photo <= 0 then
		event.MesMake_2(
			0,
			"Je te croyais diff[UNI00e9]rent, mais non,\nles hommes sont les hommes.<page>Peu importe, je suis habitu[UNI00e9] [UNI00e0] ce\nqu'on me raconte des mensonges."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Il y a une lune sur cette photo !<page>Je pourrai la voir quand je veux !")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Venir avec toi ?<page>Mais oui, bien s[UNI00fb]r.\nJe n'ai nulle part ailleurs o[UNI00f9]\naller."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_d3a581d1()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 14, 1)
end

return helper_5164fb31
