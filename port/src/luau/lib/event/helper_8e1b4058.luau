--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_71d26155 = require("@lib/event/helper_71d26155")
local helper_943c00be = require("@lib/event/helper_943c00be")
local helper_9d87065f = require("@lib/event/helper_9d87065f")
local helper_b5813fc2 = require("@lib/event/helper_b5813fc2")
local helper_dc1f6d56 = require("@lib/event/helper_dc1f6d56")
local helper_f0bc1d13 = require("@lib/event/helper_f0bc1d13")
local helper_ffbed135 = require("@lib/event/helper_ffbed135")

--- Helper function.
local function helper_8e1b4058(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_ffbed135(arg0, arg1)
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
				helper_71d26155(arg0, arg1)
			end
			if at <= 6 then
				helper_f0bc1d13(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_ffbed135(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_dc1f6d56(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_b5813fc2(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_943c00be(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_71d26155(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_f0bc1d13(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_9d87065f(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_8e1b4058
