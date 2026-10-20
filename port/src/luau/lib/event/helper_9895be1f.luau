--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_081932cf = require("@lib/event/helper_081932cf")
local helper_31d31ab1 = require("@lib/event/helper_31d31ab1")
local helper_68abde2b = require("@lib/event/helper_68abde2b")
local helper_bd048af9 = require("@lib/event/helper_bd048af9")

--- Helper function.
local function helper_9895be1f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_31d31ab1(arg0, arg1, 0)
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
		helper_31d31ab1(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_081932cf(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_68abde2b(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_bd048af9(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_9895be1f
