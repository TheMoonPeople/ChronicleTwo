--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_f5907d2b = require("@lib/event/helper_f5907d2b")

--- Helper function.
local function helper_34d1a8e2(arg0: s32, arg1: s32)
	local var2: s32 = 0
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
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_f5907d2b()
		end
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 < 3 then
		event.MesMake_2(0, "Sorry, I'm still\nnot ready.<page>Can you give me\na little longer?")
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "By the way, have you been\nto Morton's for me yet?")
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "What! How can he be\nso inconsiderate?<page>Oh well,\nyou have them.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Never mind that,\nlet's get going.<page>So where are\nwe off to?")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SubItem(300, 20)
	event.AddItem(299, 20)
	helper_f5907d2b()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 8, 1)
end

return helper_34d1a8e2
