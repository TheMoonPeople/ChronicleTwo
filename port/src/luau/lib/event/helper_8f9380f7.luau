--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_334224b7 = require("@lib/event/helper_334224b7")
local helper_6cf51ba5 = require("@lib/event/helper_6cf51ba5")
local helper_ee493967 = require("@lib/event/helper_ee493967")
local helper_fc15614f = require("@lib/event/helper_fc15614f")

--- Helper function.
local function helper_8f9380f7(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_ee493967(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_ee493967(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_6cf51ba5(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_fc15614f(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_334224b7(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_8f9380f7
