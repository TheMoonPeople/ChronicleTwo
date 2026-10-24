--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_18bbaa4d = require("@lib/event/helper_18bbaa4d")
local helper_313ae7ce = require("@lib/event/helper_313ae7ce")
local helper_368a7ca7 = require("@lib/event/helper_368a7ca7")
local helper_5917444a = require("@lib/event/helper_5917444a")
local helper_e87e8408 = require("@lib/event/helper_e87e8408")

--- Helper function.
local function helper_4244fa92(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_313ae7ce(arg0, arg1)
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
	if active_chr_no == 1 then
		helper_313ae7ce(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_18bbaa4d(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_368a7ca7(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_5917444a(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_e87e8408(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_4244fa92
