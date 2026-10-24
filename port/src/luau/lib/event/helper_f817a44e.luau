--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2a0df2c7 = require("@lib/event/helper_2a0df2c7")
local helper_72c18c3d = require("@lib/event/helper_72c18c3d")
local helper_a9943286 = require("@lib/event/helper_a9943286")
local helper_c3a24584 = require("@lib/event/helper_c3a24584")

--- Helper function.
local function helper_f817a44e(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_a9943286(arg0, arg1)
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
		helper_a9943286(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_2a0df2c7(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_72c18c3d(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_c3a24584(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_f817a44e
