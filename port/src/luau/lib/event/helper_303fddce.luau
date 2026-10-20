--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_085d9936 = require("@lib/event/helper_085d9936")
local helper_7586ce72 = require("@lib/event/helper_7586ce72")
local helper_bbc9379e = require("@lib/event/helper_bbc9379e")
local helper_bf6577e6 = require("@lib/event/helper_bf6577e6")
local helper_d3b2745a = require("@lib/event/helper_d3b2745a")

--- Helper function.
local function helper_303fddce(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_bbc9379e(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_bbc9379e(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_085d9936(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_d3b2745a(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_bf6577e6(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_7586ce72(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_303fddce
