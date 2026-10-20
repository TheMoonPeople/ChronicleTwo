--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_544e1646 = require("@lib/event/helper_544e1646")
local helper_57b5870c = require("@lib/event/helper_57b5870c")
local helper_b1529faf = require("@lib/event/helper_b1529faf")
local helper_b5826b0b = require("@lib/event/helper_b5826b0b")
local helper_bb0e2de8 = require("@lib/event/helper_bb0e2de8")
local helper_c524548b = require("@lib/event/helper_c524548b")
local helper_e88f05ef = require("@lib/event/helper_e88f05ef")

--- Helper function.
local function helper_601370c4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b5826b0b(arg0, arg1)
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
				helper_c524548b(arg0, arg1)
			end
			if at <= 6 then
				helper_544e1646(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_b5826b0b(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_57b5870c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_e88f05ef(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_bb0e2de8(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_c524548b(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_544e1646(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_b1529faf(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_601370c4
