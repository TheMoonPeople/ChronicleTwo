--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_f5907d2b = require("@lib/event/helper_f5907d2b")

--- Helper function.
local function helper_13a5b588(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
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
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "They say that a fish mirrors its owner.")
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "There's no way I'll talk to such a \nweak fish's owner.")
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
		"I was watching, you know.\nIt was a great race.<page>I doubt that I could've raised\nsuch a good fish.<page>Please take me with you.\nPlease teach me what you know."
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
	event.SetQuestEtc(1, 16, 1)
end

return helper_13a5b588
