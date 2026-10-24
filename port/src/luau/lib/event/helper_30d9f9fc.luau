--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_46f8aa3e = require("@lib/event/helper_46f8aa3e")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")

--- Helper function.
local function helper_30d9f9fc(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_9cbdc640(1)
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_82705ce2(0, -1, 8, 0, 0)
	helper_46f8aa3e(0, arg1)
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_25abe6d2(arg2)
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_6992f518(0)
end

return helper_30d9f9fc
