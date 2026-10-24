--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_85c5bf98 = require("@lib/event/helper_85c5bf98")
local helper_85db9a80 = require("@lib/event/helper_85db9a80")
local helper_8703ef2d = require("@lib/event/helper_8703ef2d")
local helper_9e6c067e = require("@lib/event/helper_9e6c067e")
local helper_a8934c5b = require("@lib/event/helper_a8934c5b")
local helper_d47b6d6a = require("@lib/event/helper_d47b6d6a")
local helper_d753c97e = require("@lib/event/helper_d753c97e")

--- Helper function.
local function helper_0f5aa988(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_85c5bf98(arg0, arg1)
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
				helper_d753c97e(arg0, arg1)
			end
			if at <= 6 then
				helper_8703ef2d(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_85c5bf98(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_85db9a80(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_d47b6d6a(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_9e6c067e(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_d753c97e(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_8703ef2d(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_a8934c5b(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_0f5aa988
