--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_18824021 = require("@lib/event/helper_18824021")
local helper_4303440d = require("@lib/event/helper_4303440d")
local helper_5c3c6a10 = require("@lib/event/helper_5c3c6a10")
local helper_e04ab7f3 = require("@lib/event/helper_e04ab7f3")

--- Helper function.
local function helper_fafd3587(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_5c3c6a10(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_5c3c6a10(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_4303440d(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_18824021(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_e04ab7f3(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_fafd3587
