--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_daa12212 = require("@lib/event/helper_daa12212")

--- Helper function.
local function helper_6d8a7e05()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c1c32f84(30)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 0)
	event.SetFadeIn(30)
	event.MesMake_2(0, "Ｅ３５６　～ギルトーニ撃退・クレストとの別れ～(つづき)")
	helper_daa12212(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(2)
	end
	event.Finish()
end

return helper_6d8a7e05
