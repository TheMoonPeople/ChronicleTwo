--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_34761c0d = require("@lib/event/helper_34761c0d")
local helper_d8873deb = require("@lib/event/helper_d8873deb")
local helper_dd640815 = require("@lib/event/helper_dd640815")
local helper_f6eeb5bc = require("@lib/event/helper_f6eeb5bc")

--- Helper function.
local function helper_846af1dc(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_dd640815(arg0, arg1)
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
		helper_dd640815(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_d8873deb(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_f6eeb5bc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_34761c0d(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_846af1dc
