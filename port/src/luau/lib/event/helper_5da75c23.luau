--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_264d92c0 = require("@lib/event/helper_264d92c0")
local helper_60caef10 = require("@lib/event/helper_60caef10")
local helper_9b1dd4c8 = require("@lib/event/helper_9b1dd4c8")
local helper_a4b554fe = require("@lib/event/helper_a4b554fe")
local helper_d71e0888 = require("@lib/event/helper_d71e0888")

--- Helper function.
local function helper_5da75c23(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_d71e0888(arg0, arg1)
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
		helper_d71e0888(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_264d92c0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_9b1dd4c8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_a4b554fe(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_60caef10(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_5da75c23
