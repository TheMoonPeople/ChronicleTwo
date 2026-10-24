--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_34d1a8e2 = require("@lib/event/helper_34d1a8e2")
local helper_3f27fda3 = require("@lib/event/helper_3f27fda3")
local helper_45fe8560 = require("@lib/event/helper_45fe8560")
local helper_59bbca34 = require("@lib/event/helper_59bbca34")
local helper_6863b6b8 = require("@lib/event/helper_6863b6b8")

--- Helper function.
local function helper_556129a1(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_45fe8560(arg0, arg1)
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
		helper_45fe8560(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_6863b6b8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_3f27fda3(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_34d1a8e2(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_59bbca34(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_556129a1
