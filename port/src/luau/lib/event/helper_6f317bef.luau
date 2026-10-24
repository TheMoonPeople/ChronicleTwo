--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_10094463 = require("@lib/event/helper_10094463")
local helper_11bfeee2 = require("@lib/event/helper_11bfeee2")
local helper_53496ade = require("@lib/event/helper_53496ade")
local helper_80954245 = require("@lib/event/helper_80954245")
local helper_9235d5d7 = require("@lib/event/helper_9235d5d7")
local helper_c27cc4dd = require("@lib/event/helper_c27cc4dd")

--- Helper function.
local function helper_6f317bef(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_80954245(arg0, arg1)
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
		if at <= 6 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_80954245(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_9235d5d7(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 ~= vm.f32(1182.3) or var6 ~= vm.f32(210.6) then
		helper_10094463(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_53496ade(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 1 then
		helper_11bfeee2(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var3 == 2 then
		helper_c27cc4dd(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
		return
	end
end

return helper_6f317bef
