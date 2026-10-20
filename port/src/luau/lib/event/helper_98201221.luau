--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1d597f0c = require("@lib/event/helper_1d597f0c")
local helper_4a05197b = require("@lib/event/helper_4a05197b")
local helper_623ff179 = require("@lib/event/helper_623ff179")
local helper_d82070da = require("@lib/event/helper_d82070da")

--- Helper function.
local function helper_98201221(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_4a05197b(arg0, arg1)
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
		helper_4a05197b(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_d82070da(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1d597f0c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_623ff179(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_98201221
