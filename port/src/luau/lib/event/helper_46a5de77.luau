--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_0419459a = require("@lib/event/helper_0419459a")
local helper_61afd6a2 = require("@lib/event/helper_61afd6a2")
local helper_9a4c0658 = require("@lib/event/helper_9a4c0658")
local helper_a3aca423 = require("@lib/event/helper_a3aca423")
local helper_d12fc8fb = require("@lib/event/helper_d12fc8fb")

--- Helper function.
local function helper_46a5de77(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_9a4c0658(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_a3aca423(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_0419459a(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_d12fc8fb(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_61afd6a2(arg0, arg1)
		return
	end
end

return helper_46a5de77
