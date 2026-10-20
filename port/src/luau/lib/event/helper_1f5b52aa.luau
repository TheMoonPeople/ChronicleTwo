--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1e1df768 = require("@lib/event/helper_1e1df768")
local helper_5e1d62b4 = require("@lib/event/helper_5e1d62b4")
local helper_712d6d91 = require("@lib/event/helper_712d6d91")
local helper_83f08b5b = require("@lib/event/helper_83f08b5b")
local helper_ac09c9a6 = require("@lib/event/helper_ac09c9a6")
local helper_c7d2b2c7 = require("@lib/event/helper_c7d2b2c7")
local helper_f3dcce3e = require("@lib/event/helper_f3dcce3e")

--- Helper function.
local function helper_1f5b52aa(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_5e1d62b4(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 7 then
			if at <= 5 then
				helper_83f08b5b(arg0, arg1)
			end
			if at <= 6 then
				helper_f3dcce3e(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_5e1d62b4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1e1df768(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_ac09c9a6(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_c7d2b2c7(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_83f08b5b(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_f3dcce3e(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_712d6d91(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_1f5b52aa
