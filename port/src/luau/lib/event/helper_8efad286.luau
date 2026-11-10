--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_d4172c24 = require("@lib/event/helper_d4172c24")
local helper_d552d8eb = require("@lib/event/helper_d552d8eb")
local helper_ed22addb = require("@lib/event/helper_ed22addb")
local helper_f97100db = require("@lib/event/helper_f97100db")

--- Helper function.
local function helper_8efad286()
	local flag: s32 = 0
	print("map_init-------------------------\n")
	flag = event.get_save_flag(280) or flag
	if flag ~= 0 then
		helper_f97100db()
	end
	helper_d552d8eb()
	helper_ed22addb()
	helper_d4172c24()
end

return helper_8efad286
