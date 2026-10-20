--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_242ec1cd = require("@lib/event/helper_242ec1cd")
local helper_3707f749 = require("@lib/event/helper_3707f749")
local helper_7d9a5e90 = require("@lib/event/helper_7d9a5e90")
local helper_7e2d86b5 = require("@lib/event/helper_7e2d86b5")
local helper_8ea0646f = require("@lib/event/helper_8ea0646f")
local helper_b2e29c5c = require("@lib/event/helper_b2e29c5c")
local helper_cca2c630 = require("@lib/event/helper_cca2c630")

--- Helper function.
local function helper_ffba54b1(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3707f749(arg0, arg1)
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
				helper_7e2d86b5(arg0, arg1)
			end
			if at <= 6 then
				helper_8ea0646f(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_3707f749(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_242ec1cd(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_7d9a5e90(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_b2e29c5c(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_7e2d86b5(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_8ea0646f(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_cca2c630(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_ffba54b1
