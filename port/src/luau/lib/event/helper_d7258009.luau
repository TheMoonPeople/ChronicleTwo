--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_10c864b3 = require("@lib/event/helper_10c864b3")
local helper_c2bf74a4 = require("@lib/event/helper_c2bf74a4")
local helper_c2f84268 = require("@lib/event/helper_c2f84268")
local helper_e5bb9ee3 = require("@lib/event/helper_e5bb9ee3")

--- Helper function.
local function helper_d7258009(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_10c864b3(arg0, arg1)
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
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_10c864b3(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_c2bf74a4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_e5bb9ee3(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_c2f84268(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_d7258009
