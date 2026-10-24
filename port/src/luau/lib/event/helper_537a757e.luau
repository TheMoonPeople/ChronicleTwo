--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1a962f99 = require("@lib/event/helper_1a962f99")
local helper_5181d2fc = require("@lib/event/helper_5181d2fc")
local helper_a6f251e8 = require("@lib/event/helper_a6f251e8")
local helper_ccfa1607 = require("@lib/event/helper_ccfa1607")
local helper_eb4b3af4 = require("@lib/event/helper_eb4b3af4")

--- Helper function.
local function helper_537a757e(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_eb4b3af4(arg0, arg1)
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
		helper_eb4b3af4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_a6f251e8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_5181d2fc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_ccfa1607(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1a962f99(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_537a757e
