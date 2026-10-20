--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_37ad6db4 = require("@lib/event/helper_37ad6db4")
local helper_9262e858 = require("@lib/event/helper_9262e858")
local helper_cc086b4e = require("@lib/event/helper_cc086b4e")
local helper_fd303c6a = require("@lib/event/helper_fd303c6a")

--- Helper function.
local function helper_867b0751(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
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
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_fd303c6a(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_9262e858(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_37ad6db4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_cc086b4e(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_867b0751
