--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_122f5763 = require("@lib/event/helper_122f5763")
local helper_1f12dd60 = require("@lib/event/helper_1f12dd60")
local helper_5b43b51b = require("@lib/event/helper_5b43b51b")
local helper_6380135f = require("@lib/event/helper_6380135f")
local helper_711c875f = require("@lib/event/helper_711c875f")
local helper_98e79b26 = require("@lib/event/helper_98e79b26")
local helper_b9229e4d = require("@lib/event/helper_b9229e4d")

--- Helper function.
local function helper_65f16098(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_711c875f(arg0, arg1)
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
				helper_1f12dd60(arg0, arg1)
			end
			if at <= 6 then
				helper_5b43b51b(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_711c875f(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_6380135f(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_122f5763(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_b9229e4d(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_1f12dd60(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_5b43b51b(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_98e79b26(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_65f16098
