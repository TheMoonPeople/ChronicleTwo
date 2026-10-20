--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_34697dc2 = require("@lib/event/helper_34697dc2")
local helper_63ac1aa2 = require("@lib/event/helper_63ac1aa2")
local helper_7eea83cb = require("@lib/event/helper_7eea83cb")
local helper_d1ad244c = require("@lib/event/helper_d1ad244c")
local helper_fa18e0f3 = require("@lib/event/helper_fa18e0f3")

--- Helper function.
local function helper_72d47da7(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_fa18e0f3(arg0, arg1)
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
	if active_chr_no == 0 then
		helper_fa18e0f3(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_34697dc2(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_d1ad244c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_63ac1aa2(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_7eea83cb(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_72d47da7
