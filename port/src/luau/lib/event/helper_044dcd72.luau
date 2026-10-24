--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3a2bdc39 = require("@lib/event/helper_3a2bdc39")
local helper_4450a03f = require("@lib/event/helper_4450a03f")
local helper_8ac43431 = require("@lib/event/helper_8ac43431")
local helper_ad50e908 = require("@lib/event/helper_ad50e908")
local helper_b142c8ee = require("@lib/event/helper_b142c8ee")
local helper_b1b4729a = require("@lib/event/helper_b1b4729a")
local helper_d6cb0a26 = require("@lib/event/helper_d6cb0a26")

--- Helper function.
local function helper_044dcd72(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_ad50e908(arg0, arg1)
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
				helper_b1b4729a(arg0, arg1)
			end
			if at <= 6 then
				helper_b142c8ee(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_ad50e908(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_8ac43431(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_d6cb0a26(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_3a2bdc39(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_b1b4729a(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_b142c8ee(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_4450a03f(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_044dcd72
