--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_ad8b424a()
	local var0: f32 = 0
	local var1: f32 = 0
	event.load_dungeon_monster(501, 1)
	event.load_dungeon_monster(502, 0)
	event.load_dungeon_monster(503, 0)
	event.load_dungeon_monster(504, 0)
	event.load_dungeon_monster(505, 0)
	event.load_dungeon_monster(506, 0)
	event.load_dungeon_monster(507, 0)
	event.load_dungeon_monster(508, 0)
	event.load_dungeon_monster(509, 0)
	event.place_dungeon_monster(501, 0, 0, 0)
	event.place_dungeon_monster(502, 0, 0, 0)
	event.place_dungeon_monster(503, 0, 0, 0)
	event.place_dungeon_monster(504, 0, 0, 0)
	event.place_dungeon_monster(505, 0, 0, 0)
	event.place_dungeon_monster(506, 0, 0, 0)
	event.place_dungeon_monster(507, 0, 0, 0)
	event.place_dungeon_monster(508, 0, 0, 0)
	var0 = 0.0
	var1 = vm.f32(3.1415927)
	event.place_dungeon_monster(
		509,
		vm.f32(268.802) + vm.f32(vm.sin(var0) * vm.f32(46.1983)),
		772.7575,
		vm.f32(-322.002) + vm.f32(vm.cos(var0) * vm.f32(46.1983)),
		0.0,
		var1,
		0.0
	)
	var0 = vm.f32(3.1415927)
	var1 = 0.0
	event.place_dungeon_monster(
		509,
		vm.f32(268.802) + vm.f32(vm.sin(var0) * vm.f32(46.1983)),
		772.7575,
		vm.f32(-322.002) + vm.f32(vm.cos(var0) * vm.f32(46.1983)),
		0.0,
		var1,
		0.0
	)
	var0 = vm.f32(1.0471976)
	var1 = vm.f32(-6.2831855)
	var1 = vm.f32(var1 / 3.0)
	event.place_dungeon_monster(
		509,
		vm.f32(268.802) + vm.f32(vm.sin(var0) * vm.f32(46.1983)),
		772.7575,
		vm.f32(-322.002) + vm.f32(vm.cos(var0) * vm.f32(46.1983)),
		0.0,
		var1,
		0.0
	)
	var0 = vm.f32(-6.2831855)
	var0 = vm.f32(var0 / 3.0)
	var1 = vm.f32(1.0471976)
	event.place_dungeon_monster(
		509,
		vm.f32(268.802) + vm.f32(vm.sin(var0) * vm.f32(46.1983)),
		772.7575,
		vm.f32(-322.002) + vm.f32(vm.cos(var0) * vm.f32(46.1983)),
		0.0,
		var1,
		0.0
	)
	var0 = vm.f32(-1.0471976)
	var1 = vm.f32(6.2831855)
	var1 = vm.f32(var1 / 3.0)
	event.place_dungeon_monster(
		509,
		vm.f32(268.802) + vm.f32(vm.sin(var0) * vm.f32(46.1983)),
		772.7575,
		vm.f32(-322.002) + vm.f32(vm.cos(var0) * vm.f32(46.1983)),
		0.0,
		var1,
		0.0
	)
	var1 = vm.f32(-1.0471976)
	var0 = vm.f32(6.2831855)
	var0 = vm.f32(var0 / 3.0)
	event.place_dungeon_monster(
		509,
		vm.f32(268.802) + vm.f32(vm.sin(var0) * vm.f32(46.1983)),
		772.7575,
		vm.f32(-322.002) + vm.f32(vm.cos(var0) * vm.f32(46.1983)),
		0.0,
		var1,
		0.0
	)
	vm.wait(1)
end

return helper_ad8b424a
