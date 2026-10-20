--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_fff9cb22(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_a45deb91(arg0, 0, 0)
			end
			if at <= 2 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_a45deb91(arg0, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Hallo.\nDu bist Monica, stimmt's?")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Ich bin Parn.\nIch bin Zaubermaler.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Hey, Max.<page>Warum siehst du immer\nso gesund aus?")
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
end

return helper_fff9cb22
