--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_33a348a7 = require("@lib/event/helper_33a348a7")
local helper_e2203e72 = require("@lib/event/helper_e2203e72")
local helper_e5219064 = require("@lib/event/helper_e5219064")
local helper_eb560126 = require("@lib/event/helper_eb560126")

--- Helper function.
local function helper_7236feb8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_e2203e72(30)
			end
			return
		end
		if at <= 4 then
			helper_33a348a7()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(11) or var2
	if var2 < 1 then
		event.MesMake_2(0, "Oh! Du hast mich!<page>Aber findest du mich noch mal?")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(11, var2 + 1)
		event.SetFadeOut(30)
		helper_e2203e72(30)
		if vm.skipping() then
			return skip(3)
		end
		event.SetAi(1, arg0)
		event.CharaActive(0, arg0)
		event.DeleteVillager(arg0)
		event.SetFadeIn(30)
		return
	end
	event.MesMake_2(
		0,
		"Oh! Du hast mich ...<page>Ich hab keine Lust mehr.<page>Verstecken ist eigentlich\ntotal langweilig.<page>Na gut! Dann ziehen wir in\nunser Abenteuer!"
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_33a348a7()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 18, 1)
end

return helper_7236feb8
