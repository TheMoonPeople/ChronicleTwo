--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_546181df = require("@lib/event/helper_546181df")
local helper_717a7abd = require("@lib/event/helper_717a7abd")
local helper_98e665dd = require("@lib/event/helper_98e665dd")
local helper_ac1b62ee = require("@lib/event/helper_ac1b62ee")
local helper_fa518013 = require("@lib/event/helper_fa518013")

--- Helper function.
local function helper_46f65bfa(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_ac1b62ee(arg0, arg1)
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
		helper_ac1b62ee(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_717a7abd(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_546181df(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_fa518013(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_98e665dd(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_46f65bfa
