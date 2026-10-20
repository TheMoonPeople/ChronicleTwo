--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_067337be = require("@lib/event/helper_067337be")
local helper_067ab078 = require("@lib/event/helper_067ab078")
local helper_12f09086 = require("@lib/event/helper_12f09086")
local helper_5c29ff33 = require("@lib/event/helper_5c29ff33")
local helper_8e96aaa4 = require("@lib/event/helper_8e96aaa4")
local helper_a11ca8e0 = require("@lib/event/helper_a11ca8e0")
local helper_a25cb356 = require("@lib/event/helper_a25cb356")

--- Helper function.
local function helper_a1e64c37(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_067337be(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 7 then
			if at <= 5 then
				helper_8e96aaa4(arg0, arg1)
			end
			if at <= 6 then
				helper_a25cb356(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_067337be(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_12f09086(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_a11ca8e0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_5c29ff33(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_8e96aaa4(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_a25cb356(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_067ab078(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_a1e64c37
