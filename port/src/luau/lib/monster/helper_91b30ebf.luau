--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_01663a12 = require("@lib/monster/helper_01663a12")
local helper_45797ccb = require("@lib/monster/helper_45797ccb")
local helper_9d1ba522 = require("@lib/monster/helper_9d1ba522")
local helper_b3c03340 = require("@lib/monster/helper_b3c03340")
local helper_d9999117 = require("@lib/monster/helper_d9999117")
local helper_f5727415 = require("@lib/monster/helper_f5727415")
local helper_f9be9dbe = require("@lib/monster/helper_f9be9dbe")

--- Helper function.
local function helper_91b30ebf()
	local argc: s32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	monster.GetMonsterLife()
	argc = monster.GetRnd(100) or argc
	if argc < 65 then
		monster.SetMos("歩き", -1, 0)
		helper_b3c03340(1.75, vm.f32(4.8), 30.0, 30.0, 60)
		helper_f9be9dbe()
		monster.SetMos("立ち", -1, 0)
	else
		argc = monster.GetRnd(100) or argc
		if argc < 15 then
			argc = monster.GetRnd(100) or argc
			var4 = monster.GetRndf(60.0) or var4
			if argc < 50 then
				var4 = vm.f32(-var4 - 30.0)
			else
				var4 = vm.f32(var4 + 30.0)
			end
			monster.SetMos("歩き", -1, 0)
			helper_9d1ba522(1.75, vm.f32(4.8), var4, 60.0, 1.0, 30.0, 50)
			helper_f5727415(vm.f32(4.8))
			monster.SetMos("立ち", -1, 0)
			helper_45797ccb(9)
		else
			monster.SetMos("歩き", -1, 0)
			helper_f5727415(vm.f32(4.8))
			argc = monster.GetRnd(100) or argc
			if argc < 67 then
				argc = monster.GetRnd(100) or argc
				if argc < 50 then
					var5 = 1
					monster.SetMos("ステップ右", -1, 0)
				else
					var5 = 0
					monster.SetMos("ステップ左", -1, 0)
				end
				helper_01663a12(1.75, 30.0, 30.0, var5, 60)
				monster.SetMos("立ち", -1, 0)
			else
				helper_d9999117(1.75, 30.0, 30.0, 60)
				monster.SetMos("立ち", -1, 0)
			end
		end
	end
end

return helper_91b30ebf
