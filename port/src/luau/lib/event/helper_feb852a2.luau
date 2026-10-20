--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_298d7055 = require("@lib/event/helper_298d7055")
local helper_4d6d8748 = require("@lib/event/helper_4d6d8748")
local helper_85540b8f = require("@lib/event/helper_85540b8f")
local helper_8ce0cbbf = require("@lib/event/helper_8ce0cbbf")

--- Helper function.
local function helper_feb852a2(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_4d6d8748(arg0, arg1)
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
		helper_4d6d8748(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_85540b8f(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_8ce0cbbf(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_298d7055(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_feb852a2
