--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_327bb77a = require("@lib/event/helper_327bb77a")
local helper_a45db3c8 = require("@lib/event/helper_a45db3c8")
local helper_d33fcbd5 = require("@lib/event/helper_d33fcbd5")
local helper_db166312 = require("@lib/event/helper_db166312")

--- Helper function.
local function helper_196368ad(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_db166312(arg0, arg1)
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
		helper_db166312(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_a45db3c8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_327bb77a(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_d33fcbd5(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_196368ad
