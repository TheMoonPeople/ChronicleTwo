--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5d5f1b6d = require("@lib/event/helper_5d5f1b6d")
local helper_915bdb40 = require("@lib/event/helper_915bdb40")
local helper_a897debb = require("@lib/event/helper_a897debb")
local helper_b6c286a3 = require("@lib/event/helper_b6c286a3")
local helper_d7248d72 = require("@lib/event/helper_d7248d72")
local helper_e4e11439 = require("@lib/event/helper_e4e11439")
local helper_edd27615 = require("@lib/event/helper_edd27615")

--- Helper function.
local function helper_ac1f571d(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e4e11439(arg0, arg1)
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
				helper_b6c286a3(arg0, arg1)
			end
			if at <= 6 then
				helper_915bdb40(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_e4e11439(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_edd27615(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_a897debb(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_5d5f1b6d(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_b6c286a3(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_915bdb40(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_d7248d72(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_ac1f571d
