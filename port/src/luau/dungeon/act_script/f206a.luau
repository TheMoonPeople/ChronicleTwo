--!strict
-- dungeon/act_script/f206a.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1512c7e0 = require("@lib/action/helper_1512c7e0")
local helper_37f14ce7 = require("@lib/action/helper_37f14ce7")
local helper_42e38fa0 = require("@lib/action/helper_42e38fa0")

--- Helper function.
local function helper_dcc()
	local var1: s32 = 0
	local prog: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local var8: f32 = 0
	prog = action.ProgGet() or prog
	if prog == 100 then
		action.SetMos("攻撃１in", -1, 6)
		vm.wait()
		var1 = action.GetMosStatus() or var1
		if var1 == 4 then
			var7 = action.GetAttkPoint(0) or var7
			do
				local out1, out2, out3 = action.GetObjectPos("dcol00")
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			action.EsmCreate_1("fox_銃弾")
			action.EsmSetVect1(-1, var4, var5, var6)
			action.EsmSetValue(-1, 0, var7)
			action.EsmCreate_1("マズルフラッシュ")
			action.SePlay(-1, 5)
			action.ProgSet(101)
		end
		return
	end
	if prog == 101 then
		action.SetMos("攻撃１out", -1, 6)
		vm.wait()
		var8 = action.NowMosWait() or var8
		if var8 >= vm.f32(0.224) and var8 < vm.f32(0.288) then
			action.SePlay(-1, 6)
		end
		var1 = action.GetMosStatus() or var1
		if var1 == 4 then
			action.ProgSet(0)
		end
		return
	end
end

--- Helper function.
local function helper_13fc()
	local var1: s32 = 0
	local prog: s32 = 0
	prog = action.ProgGet() or prog
	if prog == 200 then
		action.SetMos("避けin", -1, 6)
		vm.wait()
		var1 = action.GetMosStatus() or var1
		if var1 == 4 then
			action.ProgSet(201)
		end
		return
	end
	if prog == 201 then
		action.SetMos("避け攻撃", -1, 6)
		vm.wait()
		var1 = action.GetMosStatus() or var1
		if var1 == 4 then
			action.ProgSet(0)
		end
		return
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the character up when its script is initialised.
function script.init()
	action.SetDmg2("dcol00", "dcol01", "モンスター剣", 2.5, 1.0, "避け攻撃", 0.43, 0.6)
	action.SetMoveSpeed(3.2)
end

--- Runs the character's normal behaviour.
function script.loop()
	local prog: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	action.ProgSet(0)
	while true do
		prog = action.ProgGet() or prog
		if prog >= 100 and prog < 199 then
			action.SetTrgAngle(40.0, 5.0)
			helper_dcc()
		end
		if prog >= 200 and prog < 299 then
			action.SetTrgAngle(40.0, 5.0)
			helper_13fc()
		end
		prog = action.ProgGet() or prog
		if prog == 0 then
			action.RunMainMove()
			var3 = action.GetBtn_2(50) or var3
			var4 = action.GetBtn_2(51) or var4
			if var3 ~= 0 then
				prog = 100
			end
			if var4 ~= 0 then
				prog = 200
			end
			action.ProgSet(prog)
		end
		vm.wait()
	end
end

--- Reacts to a small hit.
script.on_small_damage = helper_1512c7e0

--- Holds the character in place.
script.on_hold = helper_1512c7e0

--- Reacts to a large hit.
script.on_large_damage = helper_42e38fa0

--- Follows up a melee hit that the character has landed.
-- Defined empty, so the engine runs this instead of its default.
function script.on_melee_hit() end

--- Runs the character's death.
script.on_death = helper_37f14ce7

return script
