--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_895a896a = require("@lib/event/helper_895a896a")
local helper_a55c98d8 = require("@lib/event/helper_a55c98d8")
local helper_a9fed8c0 = require("@lib/event/helper_a9fed8c0")
local helper_ae63d493 = require("@lib/event/helper_ae63d493")

--- Helper function.
local function helper_8d5e794c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_a55c98d8(arg0, arg1, 0)
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
		helper_a55c98d8(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_ae63d493(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_895a896a(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_a9fed8c0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_8d5e794c
