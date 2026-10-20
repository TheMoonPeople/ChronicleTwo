--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_16115ce5 = require("@lib/event/helper_16115ce5")
local helper_73ea514e = require("@lib/event/helper_73ea514e")
local helper_7cd5871d = require("@lib/event/helper_7cd5871d")
local helper_c292fbd3 = require("@lib/event/helper_c292fbd3")

--- Helper function.
local function helper_b1e5b516(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_16115ce5(arg0, arg1)
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
		helper_16115ce5(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_c292fbd3(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_7cd5871d(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_73ea514e(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_b1e5b516
