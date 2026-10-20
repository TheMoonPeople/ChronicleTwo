--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f719ebb = require("@lib/event/helper_2f719ebb")
local helper_66877e57 = require("@lib/event/helper_66877e57")
local helper_92461917 = require("@lib/event/helper_92461917")
local helper_c51f1455 = require("@lib/event/helper_c51f1455")
local helper_e606137c = require("@lib/event/helper_e606137c")

--- Helper function.
local function helper_b142d525(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_66877e57(arg0, arg1)
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
		helper_66877e57(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_92461917(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_e606137c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_c51f1455(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_2f719ebb(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_b142d525
