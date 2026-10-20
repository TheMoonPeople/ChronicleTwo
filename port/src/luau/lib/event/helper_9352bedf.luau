--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1e2654af = require("@lib/event/helper_1e2654af")
local helper_3f2a8932 = require("@lib/event/helper_3f2a8932")
local helper_6a7e1c06 = require("@lib/event/helper_6a7e1c06")
local helper_a5c3821c = require("@lib/event/helper_a5c3821c")

--- Helper function.
local function helper_9352bedf(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1e2654af(arg0, arg1)
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
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_1e2654af(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_a5c3821c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_3f2a8932(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_6a7e1c06(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_9352bedf
