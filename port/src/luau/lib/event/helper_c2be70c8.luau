--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1d0e9051 = require("@lib/event/helper_1d0e9051")
local helper_7db47905 = require("@lib/event/helper_7db47905")
local helper_8e17178d = require("@lib/event/helper_8e17178d")
local helper_ba2ef81c = require("@lib/event/helper_ba2ef81c")

--- Helper function.
local function helper_c2be70c8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_8e17178d(arg0, arg1)
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
		helper_8e17178d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_7db47905(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1d0e9051(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_ba2ef81c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_c2be70c8
