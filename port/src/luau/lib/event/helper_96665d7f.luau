--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_5008bb75 = require("@lib/event/helper_5008bb75")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_f5907d2b = require("@lib/event/helper_f5907d2b")

--- Helper function.
local function helper_96665d7f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_5008bb75()
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_f5907d2b()
		end
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = helper_5008bb75()
	if 0 < var2 then
		event.MesMake_2(0, "It seems like you're not\nquite good enough yet.")
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"I have high hopes for you in the future,\nbut I'm afraid I can't cooperate\nwith you at the moment."
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
		"You've done well.\nWonderful.<page>I'm sure you'll live\nup to my expectations.<page>I promised, didn't I?\nI'll go with you."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_f5907d2b()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 13, 1)
end

return helper_96665d7f
