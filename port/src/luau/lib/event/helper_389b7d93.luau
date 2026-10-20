--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_389b7d93()
	local var0: f32 = 0
	local var1: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 0.0
			var1 = vm.f32(3.1415927)
			var0 = vm.f32(3.1415927)
			var1 = 0.0
			var0 = vm.f32(1.0471976)
			var1 = vm.f32(-6.2831855)
			var1 = vm.f32(var1 / 3.0)
			var0 = vm.f32(-6.2831855)
			var0 = vm.f32(var0 / 3.0)
			var1 = vm.f32(1.0471976)
			var0 = vm.f32(-1.0471976)
			var1 = vm.f32(6.2831855)
			var1 = vm.f32(var1 / 3.0)
			var1 = vm.f32(-1.0471976)
			var0 = vm.f32(6.2831855)
			var0 = vm.f32(var0 / 3.0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.LoadMonsterFile(501, 1)
	event.LoadMonsterFile(502, 0)
	event.LoadMonsterFile(503, 0)
	event.LoadMonsterFile(504, 0)
	event.LoadMonsterFile(505, 0)
	event.LoadMonsterFile(506, 0)
	event.LoadMonsterFile(507, 0)
	event.LoadMonsterFile(508, 0)
	event.LoadMonsterFile(509, 0)
	event.AutoSetMonster(501, 0, 0, 0)
	event.AutoSetMonster(502, 0, 0, 0)
	event.AutoSetMonster(503, 0, 0, 0)
	event.AutoSetMonster(504, 0, 0, 0)
	event.AutoSetMonster(505, 0, 0, 0)
	event.AutoSetMonster(506, 0, 0, 0)
	event.AutoSetMonster(507, 0, 0, 0)
	event.AutoSetMonster(508, 0, 0, 0)
	var0 = 0.0
	var1 = vm.f32(3.1415927)
	event.AutoSetMonster(
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
	event.AutoSetMonster(
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
	event.AutoSetMonster(
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
	event.AutoSetMonster(
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
	event.AutoSetMonster(
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
	event.AutoSetMonster(
		509,
		vm.f32(268.802) + vm.f32(vm.sin(var0) * vm.f32(46.1983)),
		772.7575,
		vm.f32(-322.002) + vm.f32(vm.cos(var0) * vm.f32(46.1983)),
		0.0,
		var1,
		0.0
	)
	if vm.wait() then
		return skip(2)
	end
end

return helper_389b7d93
