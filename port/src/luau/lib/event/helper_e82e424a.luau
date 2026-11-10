--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_4823d22b = require("@lib/event/helper_4823d22b")
local helper_6e41effa = require("@lib/event/helper_6e41effa")
local helper_b3a58fad = require("@lib/event/helper_b3a58fad")
local helper_f0df9191 = require("@lib/event/helper_f0df9191")

--- Helper function.
local function helper_e82e424a(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(42) or flag
	if flag == 0 then
		helper_4823d22b(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 == 0 then
		helper_f0df9191(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_6e41effa(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_b3a58fad(arg0, arg1)
		return
	end
end

return helper_e82e424a
