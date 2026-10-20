--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06bba5fd = require("@lib/event/helper_06bba5fd")
local helper_09b6ae38 = require("@lib/event/helper_09b6ae38")
local helper_6b8a4885 = require("@lib/event/helper_6b8a4885")
local helper_75332ca2 = require("@lib/event/helper_75332ca2")
local helper_784e0f5c = require("@lib/event/helper_784e0f5c")
local helper_cda868cb = require("@lib/event/helper_cda868cb")
local helper_cfe9fd94 = require("@lib/event/helper_cfe9fd94")

--- Helper function.
local function helper_2660b90a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_cda868cb(arg0, arg1)
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
				helper_06bba5fd(arg0, arg1)
			end
			if at <= 6 then
				helper_6b8a4885(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_cda868cb(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_09b6ae38(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_cfe9fd94(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_784e0f5c(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_06bba5fd(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_6b8a4885(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_75332ca2(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_2660b90a
