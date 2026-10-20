--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_40176515 = require("@lib/event/helper_40176515")
local helper_5195e5a3 = require("@lib/event/helper_5195e5a3")
local helper_6c1ffa42 = require("@lib/event/helper_6c1ffa42")
local helper_9444bc56 = require("@lib/event/helper_9444bc56")
local helper_c7771b43 = require("@lib/event/helper_c7771b43")

--- Helper function.
local function helper_38f6b261(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_9444bc56(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_9444bc56(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_c7771b43(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_6c1ffa42(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_5195e5a3(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_40176515(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_38f6b261
