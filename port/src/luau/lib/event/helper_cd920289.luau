--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")

--- Helper function.
local function helper_cd920289(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8f31f334(3)
		end
		if at <= 2 then
			helper_6c719c99(1090280)
		end
		if at <= 3 then
			helper_6c719c99(1090290)
		end
		if at <= 4 then
			helper_6c719c99(1090300)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-271.29, 59.56, -1912.06)
	event.CmrsSetRef(-269.4, 60.62, -1886.34)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, -257.07, 36.72, -1857.99)
	event.ObjsSetRot(2, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(1, 35)
	event.ObjsSetPos(3, -281.38, 36.72, -1863.87)
	event.ObjsSetRot(3, 0.0, 2.92, 0.0)
	event.ObjsSetMotion(3, "ボルネオを見る", 6)
	event.ObjsNextMotion(3, "ボルネオを見るL", 0)
	helper_8f31f334(3)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(3, "口パク")
	helper_6c719c99(1090280)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "トムを見る", 2)
	event.ObjsNextMotion(2, "トムを見るL")
	event.SetPakuAnim(2, "口パク")
	helper_6c719c99(1090290)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "了解っす", 6)
	event.SetPakuAnim(3, "口パク")
	helper_6c719c99(1090300)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
end

return helper_cd920289
