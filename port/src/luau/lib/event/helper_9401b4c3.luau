--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1d467b6b = require("@lib/event/helper_1d467b6b")
local helper_8dc299a4 = require("@lib/event/helper_8dc299a4")
local helper_9532b70c = require("@lib/event/helper_9532b70c")
local helper_a5810f7c = require("@lib/event/helper_a5810f7c")

--- Helper function.
local function helper_9401b4c3(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1d467b6b(arg0, arg1, 0)
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
		helper_1d467b6b(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_9532b70c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_a5810f7c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_8dc299a4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_9401b4c3
