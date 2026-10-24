--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2a816956 = require("@lib/event/helper_2a816956")
local helper_2c037bef = require("@lib/event/helper_2c037bef")
local helper_4e0f6c7f = require("@lib/event/helper_4e0f6c7f")
local helper_4ee70f67 = require("@lib/event/helper_4ee70f67")
local helper_988d9a96 = require("@lib/event/helper_988d9a96")

--- Helper function.
local function helper_9dde08bd(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2a816956(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_2a816956(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_2c037bef(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_4e0f6c7f(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_4ee70f67(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_988d9a96(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_9dde08bd
