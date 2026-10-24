--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_261b46af = require("@lib/event/helper_261b46af")
local helper_37cd5d9b = require("@lib/event/helper_37cd5d9b")
local helper_5ba8c5fe = require("@lib/event/helper_5ba8c5fe")
local helper_75d5c9b2 = require("@lib/event/helper_75d5c9b2")

--- Helper function.
local function helper_b53d33ea(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_261b46af(arg0, arg1)
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
		helper_261b46af(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_75d5c9b2(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_37cd5d9b(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_5ba8c5fe(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_b53d33ea
