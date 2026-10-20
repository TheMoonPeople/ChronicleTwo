--!strict
-- dungeon/act_script/f03a.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1512c7e0 = require("@lib/action/helper_1512c7e0")
local helper_1eb83da1 = require("@lib/action/helper_1eb83da1")
local helper_37f14ce7 = require("@lib/action/helper_37f14ce7")
local helper_42e38fa0 = require("@lib/action/helper_42e38fa0")
local helper_9a354ac4 = require("@lib/action/helper_9a354ac4")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the character up when its script is initialised.
function script.init()
	local monster_id: s32 = 0
	monster_id = action.GetMonsId() or monster_id
	if monster_id == 176 then
		action.SetDmg2("dcol0", "dcol1", "モンスター剣", 2.5, 1.0, "攻撃１", 0.3, 0.45)
		action.SetDmg2("dcol0", "dcol1", "モンスター剣", 2.5, 1.0, "攻撃２", 0.3, 0.42)
		action.SwEffect(0, "攻撃１", 0.3, 0.35, "dcol0", "dcol1", 60, 10, 10)
		action.SwEffect(0, "攻撃２", 0.3, 0.35, "dcol0", "dcol1", 60, 10, 10)
	end
	if monster_id == 177 then
		action.SetDmg2("dcol0", "dcol1", "モンスター剣", 2.5, 1.0, "攻撃１", 0.42, 0.52)
		action.SetDmg2("dcol2", "", "モンスター攻撃", 2.5, 1.0, "攻撃２", 0.4, 0.5)
		action.SwEffect(0, "攻撃１", 0.38, 0.43, "dcol0", "dcol1", 60, 10, 10)
	end
	if monster_id == 180 then
		action.SetDmg2("dcol0", "dcol1", "モンスター剣", 2.5, 1.0, "攻撃１", 0.35, 0.45)
		action.SetDmg2("dcol0", "dcol1", "モンスター剣", 2.5, 1.0, "攻撃２", 0.3, 0.4)
		action.SwEffect(0, "攻撃１", 0.3, 0.36, "dcol0", "dcol1", 60, 10, 10)
		action.SwEffect(0, "攻撃２", 0.3, 0.35, "dcol0", "dcol1", 60, 10, 10)
	end
	if monster_id == 183 then
		action.SetDmg2("dcol0", "dcol1", "モンスター剣", 2.5, 1.0, "攻撃１", 0.35, 0.45)
		action.SetDmg2("dcol0", "dcol1", "モンスター剣", 2.5, 1.0, "攻撃２", 0.3, 0.4)
		action.SwEffect(0, "攻撃１", 0.3, 0.36, "dcol0", "dcol1", 60, 10, 10)
		action.SwEffect(0, "攻撃２", 0.3, 0.35, "dcol0", "dcol1", 60, 10, 10)
	end
	if monster_id == 186 or monster_id == 187 then
		action.SetDmg2("dcol0", "dcol2", "モンスター剣", 2.5, 1.0, "攻撃１", 0.52, 0.63)
		action.SetDmg2("dcol1", "dcol3", "モンスター剣", 2.5, 1.0, "攻撃１", 0.52, 0.63)
		action.SetDmg2("dcol0", "dcol2", "モンス攻撃S", 2.5, 1.0, "攻撃２", 0.27, 0.39)
		action.SetDmg2("dcol1", "dcol3", "モンス攻撃S", 2.5, 1.0, "攻撃２", 0.48, 0.51)
	end
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
			helper_1eb83da1()
		end
		if prog >= 200 and prog < 299 then
			action.SetTrgAngle(40.0, 5.0)
			helper_9a354ac4()
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
