--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3a0eff10 = require("@lib/event/helper_3a0eff10")
local helper_62e802d7 = require("@lib/event/helper_62e802d7")
local helper_64262de4 = require("@lib/event/helper_64262de4")
local helper_ee5c73fa = require("@lib/event/helper_ee5c73fa")
local helper_ee641f31 = require("@lib/event/helper_ee641f31")

--- Helper function.
local function helper_49f52371(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3a0eff10(arg0, arg1)
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
		helper_3a0eff10(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_64262de4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_ee5c73fa(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_62e802d7(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_ee641f31(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_49f52371
