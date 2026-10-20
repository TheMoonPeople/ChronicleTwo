--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_38294c7b = require("@lib/event/helper_38294c7b")

--- Helper function.
local function helper_819810cb(arg0: s32, sp: number)
	local junk = 0
	vm.stack(sp + 4)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			vm.stack(sp + junk + 8)
			helper_38294c7b(10, sp + junk + 7)
			junk += 3
		end
		if at <= 2 then
			vm.stack(sp + junk + 6)
			junk += 1
		end
		if at <= 3 then
			vm.stack(sp + junk + 6)
			junk += 1
		end
		vm.stack(sp + junk + 6)
	end
	if vm.skipping() then
		return skip(1)
	end
	vm.stack(sp + junk + 5)
	argc = event.CheckGetItemLimit() or argc
	vm.stack(sp + junk + 5)
	argc_2 = event.CheckItemOver() or argc_2
	vm.stack(sp + junk + 5)
	if argc >= 1 or argc_2 >= 1 then
		vm.stack(sp + junk + 5)
		if arg0 == 1 then
			vm.stack(sp + junk + 5)
			event.SetFadeOut(10)
			vm.stack(sp + junk + 4)
			helper_38294c7b(10, sp + junk + 4)
			if vm.skipping() then
				return skip(2)
			end
		end
		vm.stack(sp + junk + 5)
		argc_3 = event.GetNowLoopNo() or argc_3
		vm.stack(sp + junk + 5)
		if argc_3 == 1 then
			vm.stack(sp + junk + 5)
			event.GotoMenu(16)
			if vm.wait() then
				return skip(3)
			end
		end
		vm.stack(sp + junk + 5)
		if argc_3 == 2 then
			vm.stack(sp + junk + 5)
			event.GotoMenu(17)
			if vm.wait() then
				return skip(4)
			end
		end
		vm.stack(sp + junk + 5)
		if arg0 == 1 then
			vm.stack(sp + junk + 5)
			event.SetFadeIn(10)
		end
	end
	vm.stack(sp + junk + 4)
end

return helper_819810cb
