--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_01385240 = require("@lib/event/helper_01385240")
local helper_43cc0565 = require("@lib/event/helper_43cc0565")
local helper_541f8f6c = require("@lib/event/helper_541f8f6c")
local helper_71076f2d = require("@lib/event/helper_71076f2d")
local helper_98b91c3a = require("@lib/event/helper_98b91c3a")
local helper_b9a881dd = require("@lib/event/helper_b9a881dd")

--- Helper function.
local function helper_ddd55ec8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_541f8f6c(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_43cc0565(arg0, arg1)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_01385240(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 9) or var3
	if var3 == 0 then
		helper_b9a881dd(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_71076f2d(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_98b91c3a(arg0, arg1)
		return
	end
end

return helper_ddd55ec8
