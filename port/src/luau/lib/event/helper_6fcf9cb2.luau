--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_178692b6 = require("@lib/event/helper_178692b6")
local helper_82d8ecbe = require("@lib/event/helper_82d8ecbe")
local helper_af5cf15d = require("@lib/event/helper_af5cf15d")
local helper_b1323216 = require("@lib/event/helper_b1323216")
local helper_bf1fa268 = require("@lib/event/helper_bf1fa268")
local helper_c28fa25b = require("@lib/event/helper_c28fa25b")
local helper_f918064b = require("@lib/event/helper_f918064b")

--- Helper function.
local function helper_6fcf9cb2(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_82d8ecbe(arg0, arg1)
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
				helper_af5cf15d(arg0, arg1)
			end
			if at <= 6 then
				helper_b1323216(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_82d8ecbe(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_178692b6(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_bf1fa268(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_f918064b(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_af5cf15d(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_b1323216(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_c28fa25b(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_6fcf9cb2
