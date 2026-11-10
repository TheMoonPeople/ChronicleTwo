--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_2695d6f0 = require("@lib/event/helper_2695d6f0")
local helper_6f36f7eb = require("@lib/event/helper_6f36f7eb")
local helper_9076d256 = require("@lib/event/helper_9076d256")
local helper_bcc0aead = require("@lib/event/helper_bcc0aead")

--- Helper function.
local function helper_75a1d435(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_9076d256(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 4) or var2
	if var2 == 0 then
		helper_bcc0aead(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_6f36f7eb(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_2695d6f0(arg0, arg1)
		return
	end
end

return helper_75a1d435
