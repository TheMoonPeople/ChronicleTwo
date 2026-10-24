--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_955f0976()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
		if at <= 7 then
			return
		end
		if at <= 8 then
			return
		end
	end
	var0 = event.GetCnt(1) or var0
	if var0 == 2 then
		event.MapJump(-1, "s02")
		if vm.wait() then
			return skip(1)
		end
		return
	end
	if var0 == 3 then
		event.MapJump(-1, "s04")
		if vm.wait() then
			return skip(2)
		end
		return
	end
	if var0 == 4 then
		event.MapJump(-1, "s09")
		if vm.wait() then
			return skip(3)
		end
		return
	end
	if var0 == 5 then
		event.MapJump(-1, "s10")
		if vm.wait() then
			return skip(4)
		end
		return
	end
	if var0 == 6 then
		event.MapJump(-1, "s11")
		if vm.wait() then
			return skip(5)
		end
		return
	end
	if var0 == 7 then
		event.MapJump(-1, "s12")
		if vm.wait() then
			return skip(6)
		end
		return
	end
	if var0 == 8 then
		event.MapJump(-1, "s31")
		if vm.wait() then
			return skip(7)
		end
		return
	end
	if var0 == 9 then
		event.MapJump(-1, "s34")
		if vm.wait() then
			return skip(8)
		end
		return
	end
	event.MapJump(-1, "i02h01")
	if vm.wait() then
		return skip(9)
	end
end

return helper_955f0976
