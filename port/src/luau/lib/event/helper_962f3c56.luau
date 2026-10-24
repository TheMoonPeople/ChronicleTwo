--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_051a91a2 = require("@lib/event/helper_051a91a2")
local helper_6c755231 = require("@lib/event/helper_6c755231")
local helper_ad1d90f0 = require("@lib/event/helper_ad1d90f0")
local helper_b723892d = require("@lib/event/helper_b723892d")

--- Helper function.
local function helper_962f3c56(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_6c755231(arg0, arg1)
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
		helper_6c755231(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_b723892d(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_051a91a2(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_ad1d90f0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_962f3c56
