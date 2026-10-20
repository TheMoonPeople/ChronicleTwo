--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_000ae916 = require("@lib/event/helper_000ae916")
local helper_0c16b661 = require("@lib/event/helper_0c16b661")
local helper_1993eb91 = require("@lib/event/helper_1993eb91")
local helper_a6f8c0d6 = require("@lib/event/helper_a6f8c0d6")
local helper_d9cdd3a3 = require("@lib/event/helper_d9cdd3a3")

--- Helper function.
local function helper_f50eb14e(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1993eb91(arg0, arg1)
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
		helper_1993eb91(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_d9cdd3a3(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_000ae916(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_0c16b661(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_a6f8c0d6(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_f50eb14e
