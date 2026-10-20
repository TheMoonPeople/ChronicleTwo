--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8c0c0562 = require("@lib/event/helper_8c0c0562")
local helper_cc7603b9 = require("@lib/event/helper_cc7603b9")
local helper_e5219064 = require("@lib/event/helper_e5219064")
local helper_eb560126 = require("@lib/event/helper_eb560126")

--- Helper function.
local function helper_c168ef21(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_cc7603b9(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_8c0c0562(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Io vorrei aiutarvi, ma lottare\nfa paura... e poi ci si sporca!")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Non vorrei essere di peso a\nnessuno. Devo dirvi di no.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Ma devono esserci molte cose\ninsolite fuori citt[UNI00e0].<page>Mi chiedo come siano gli alberi\ne quali fiori sboccino."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Se vedi un fiore interessante, gli\nfaresti una foto per me, Max?\nMi piacerebbe tanto vederlo."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Questa volta ha detto no ma, se le\n   mostrassi una foto di qualcosa\n   che le piace, forse cederebbe."
	)
	helper_cc7603b9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 4, 1)
end

return helper_c168ef21
