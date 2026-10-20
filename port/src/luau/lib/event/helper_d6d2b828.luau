--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_26500ca2 = require("@lib/event/helper_26500ca2")
local helper_2cab318c = require("@lib/event/helper_2cab318c")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")

--- Helper function.
local function helper_d6d2b828(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_2cab318c()
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_26500ca2()
		end
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = helper_2cab318c()
	if 0 < var2 then
		event.MesMake_2(0, "Du scheinst noch nicht gut\ngenug zu sein.")
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Ich setze gro[UNI00df]e Hoffnungen in dich,\naber ich f[UNI00fc]rchte, momentan kann\nich dir nicht helfen."
		)
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Gut gemacht.\nWunderbar.<page>Du wirst meine Erwartungen\nsicher nicht entt[UNI00e4]uschen.<page>Ich hab's versprochen, nicht wahr?\nIch begleite dich."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_26500ca2()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 13, 1)
end

return helper_d6d2b828
