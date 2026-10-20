--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0d9a7872 = require("@lib/event/helper_0d9a7872")
local helper_53c4b63d = require("@lib/event/helper_53c4b63d")
local helper_60280dcc = require("@lib/event/helper_60280dcc")
local helper_efe5c407 = require("@lib/event/helper_efe5c407")

--- Helper function.
local function helper_6ad38579(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_60280dcc(arg0, arg1)
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
		helper_60280dcc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_0d9a7872(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_53c4b63d(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_efe5c407(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_6ad38579
