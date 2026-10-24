--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5e4fd4f9 = require("@lib/event/helper_5e4fd4f9")
local helper_a6bae986 = require("@lib/event/helper_a6bae986")
local helper_d6cfd3b8 = require("@lib/event/helper_d6cfd3b8")
local helper_e14df15e = require("@lib/event/helper_e14df15e")

--- Helper function.
local function helper_95fbb750(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_5e4fd4f9(arg0, arg1)
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
		helper_5e4fd4f9(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_d6cfd3b8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_e14df15e(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_a6bae986(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_95fbb750
