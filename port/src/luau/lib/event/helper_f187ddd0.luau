--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02b2988d = require("@lib/event/helper_02b2988d")
local helper_2f004f4d = require("@lib/event/helper_2f004f4d")
local helper_393b17d5 = require("@lib/event/helper_393b17d5")
local helper_4baaa9c7 = require("@lib/event/helper_4baaa9c7")

--- Helper function.
local function helper_f187ddd0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2f004f4d(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_02b2988d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_4baaa9c7(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_393b17d5(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_f187ddd0
