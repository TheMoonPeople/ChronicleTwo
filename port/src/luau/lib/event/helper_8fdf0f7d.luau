--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0a608a2f = require("@lib/event/helper_0a608a2f")
local helper_434bf1f8 = require("@lib/event/helper_434bf1f8")
local helper_47881720 = require("@lib/event/helper_47881720")
local helper_9fa8a736 = require("@lib/event/helper_9fa8a736")

--- Helper function.
local function helper_8fdf0f7d(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_9fa8a736(arg0, arg1)
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
		helper_9fa8a736(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_434bf1f8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_47881720(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_0a608a2f(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_8fdf0f7d
