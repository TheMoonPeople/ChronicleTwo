--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1aed60f3 = require("@lib/monster/helper_1aed60f3")
local helper_65eb2b74 = require("@lib/monster/helper_65eb2b74")
local helper_95828c6f = require("@lib/monster/helper_95828c6f")
local helper_a25c5b2e = require("@lib/monster/helper_a25c5b2e")
local helper_e91cba05 = require("@lib/monster/helper_e91cba05")

--- Helper function.
local function helper_274f6d9a()
	helper_e91cba05()
	if helper_a25c5b2e() ~= 0 then
		if helper_1aed60f3() ~= 0 then
			helper_65eb2b74(0)
		end
	end
	helper_95828c6f()
	vm.wait()
end

return helper_274f6d9a
