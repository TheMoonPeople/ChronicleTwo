--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9d62329a = require("@lib/event/helper_9d62329a")
local helper_b73fcc0e = require("@lib/event/helper_b73fcc0e")
local helper_dd5af72c = require("@lib/event/helper_dd5af72c")
local helper_de64e465 = require("@lib/event/helper_de64e465")

--- Helper function.
local function helper_3c9de9c1(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b73fcc0e(arg0, arg1)
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
		helper_b73fcc0e(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_9d62329a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_dd5af72c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_de64e465(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_3c9de9c1
