--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_325b60c8 = require("@lib/event/helper_325b60c8")
local helper_415fa089 = require("@lib/event/helper_415fa089")
local helper_6eaf4409 = require("@lib/event/helper_6eaf4409")
local helper_80a41925 = require("@lib/event/helper_80a41925")
local helper_c09f9b97 = require("@lib/event/helper_c09f9b97")

--- Helper function.
local function helper_52d4f83c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_80a41925(arg0, arg1)
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
		helper_80a41925(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_c09f9b97(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_415fa089(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_325b60c8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_6eaf4409(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_52d4f83c
