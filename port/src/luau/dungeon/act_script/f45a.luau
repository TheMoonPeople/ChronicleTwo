--!strict
-- dungeon/act_script/f45a.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1512c7e0 = require("@lib/action/helper_1512c7e0")
local helper_1eb83da1 = require("@lib/action/helper_1eb83da1")
local helper_37f14ce7 = require("@lib/action/helper_37f14ce7")
local helper_42e38fa0 = require("@lib/action/helper_42e38fa0")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the character up when its script is initialised.
function script.init()
	local monster_id: s32 = 0
	monster_id = action.GetMonsId() or monster_id
	if monster_id == 224 then
		action.SetDmg2("dcol0", "dcol1", "モンスター剣", 2.5, 1.0, "攻撃１", 0.2, 0.25)
		action.SetDmg2("dcol0", "dcol1", "モンスター剣", 2.5, 1.0, "攻撃１", 0.4, 0.5)
	end
	if monster_id == 228 then
		action.SetDmg2("dcol0", "", "モンスター攻撃", 3.0, 1.0, "攻撃１", 0.28, 0.35)
	end
	if monster_id == 232 then
		action.SetDmg2("dcol0", "dcol1", "モンスター剣", 3.0, 1.0, "攻撃１", 0.45, 0.7)
	end
	if monster_id == 236 then
		action.SetDmg2("dcol0", "dcol1", "モンスター剣", 2.5, 1.0, "攻撃１", 0.48, 0.56)
	end
	if monster_id == 240 then
		action.SetDmg2("dcol0", "", "モンスター攻撃", 3.0, 1.0, "攻撃１", 0.3, 0.5)
	end
	print("MONS_ID = ", monster_id)
end

--- Runs the character's normal behaviour.
function script.loop()
	local prog: s32 = 0
	local var3: s32 = 0
	action.ProgSet(0)
	while true do
		prog = action.ProgGet() or prog
		if prog >= 100 and prog < 199 then
			action.SetTrgAngle(40.0, 5.0)
			helper_1eb83da1()
		end
		prog = action.ProgGet() or prog
		if prog == 0 then
			action.RunMainMove()
			var3 = action.GetBtn_2(50) or var3
			if var3 ~= 0 then
				prog = 100
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
