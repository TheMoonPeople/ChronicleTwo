--!strict
--- Helpers that test georama analysis progress and related story conditions.

local vm = require("@lib/vm")
local wait = vm.module("@lib/event/wait")

local georama = {}

--- Returns 1 when georama analysis flag 103 is set, save flag 270 is clear and character 1 can be changed to.
function georama.can_start_event_270()
	local save_flag: s32 = 0
	local analysis_flag: s32 = 0
	local change_state: s32 = 0
	analysis_flag = event.get_georama_analysis_flag(103) or analysis_flag
	if analysis_flag == 0 then
		return 0
	end
	save_flag = event.get_save_flag(270) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	change_state = event.get_character_change_state(1) or change_state
	if change_state == 0 then
		return 0
	end
	return 1
end

--- Returns 1 when georama analysis flag 103 and save flag 270 are set, save flag 272 is clear and character 1 can be changed to.
function georama.can_start_event_272()
	local save_flag: s32 = 0
	local analysis_flag: s32 = 0
	local change_state: s32 = 0
	analysis_flag = event.get_georama_analysis_flag(103) or analysis_flag
	if analysis_flag == 0 then
		return 0
	end
	save_flag = event.get_save_flag(270) or save_flag
	if save_flag == 0 then
		return 0
	end
	save_flag = event.get_save_flag(272) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	change_state = event.get_character_change_state(1) or change_state
	if change_state == 0 then
		return 0
	end
	return 1
end

--- Returns 1 when georama analysis flag 104 is set, save flag 275 is clear and character 1 can be changed to.
function georama.can_start_event_275()
	local save_flag: s32 = 0
	local analysis_flag: s32 = 0
	local change_state: s32 = 0
	analysis_flag = event.get_georama_analysis_flag(104) or analysis_flag
	if analysis_flag == 0 then
		return 0
	end
	save_flag = event.get_save_flag(275) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	change_state = event.get_character_change_state(1) or change_state
	if change_state == 0 then
		return 0
	end
	return 1
end

--- Returns 1 when georama analysis flag 103 and save flag 260 are set, save flag 280 is clear and character 1 can be changed to.
function georama.can_start_event_280()
	local save_flag: s32 = 0
	local analysis_flag: s32 = 0
	local change_state: s32 = 0
	analysis_flag = event.get_georama_analysis_flag(103) or analysis_flag
	if analysis_flag == 0 then
		return 0
	end
	save_flag = event.get_save_flag(260) or save_flag
	if save_flag == 0 then
		return 0
	end
	save_flag = event.get_save_flag(280) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	change_state = event.get_character_change_state(1) or change_state
	if change_state == 0 then
		return 0
	end
	return 1
end

--- Returns 1 when analysis flag 206 is set and save flag 364 is still clear.
function georama.can_start_event_364()
	local save_flag: s32 = 0
	if georama.is_analysis_flag_206_set() == 0 then
		return 0
	end
	save_flag = event.get_save_flag(364) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	return 1
end

--- Returns 1 when analysis flag 207 is set, save flag 368 is clear and a character change is available.
function georama.can_start_event_368()
	local save_flag: s32 = 0
	local change_state: s32 = 0
	if georama.is_analysis_flag_207_set() == 0 then
		return 0
	end
	save_flag = event.get_save_flag(368) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	change_state = event.get_character_change_state(1) or change_state
	if change_state == 0 then
		return 0
	end
	return 1
end

--- Returns 1 when analysis flag 209 is set, save flag 372 is clear and a character change is available.
function georama.can_start_event_372()
	local save_flag: s32 = 0
	local change_state: s32 = 0
	if georama.is_analysis_flag_209_set() == 0 then
		return 0
	end
	save_flag = event.get_save_flag(372) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	change_state = event.get_character_change_state(1) or change_state
	if change_state == 0 then
		return 0
	end
	return 1
end

--- Returns 1 when analysis group 1 is complete, save flag 376 is clear and a character change is available.
function georama.can_start_event_376()
	local save_flag: s32 = 0
	local change_state: s32 = 0
	if georama.is_analysis_group_1_complete() == 0 then
		return 0
	end
	save_flag = event.get_save_flag(376) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	change_state = event.get_character_change_state(1) or change_state
	if change_state == 0 then
		return 0
	end
	return 1
end

--- Returns 1 when analysis flag 301 is set, save flag 456 is clear and a character change is available.
function georama.can_start_event_456()
	local save_flag: s32 = 0
	local change_state: s32 = 0
	if georama.is_analysis_flag_301_set() == 0 then
		return 0
	end
	save_flag = event.get_save_flag(456) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	change_state = event.get_character_change_state(1) or change_state
	if change_state == 0 then
		return 0
	end
	return 1
end

--- Returns 1 when analysis flag 302 is set, save flag 460 is clear and a character change is available.
function georama.can_start_event_460()
	local save_flag: s32 = 0
	local change_state: s32 = 0
	if georama.is_analysis_flag_302_set() == 0 then
		return 0
	end
	save_flag = event.get_save_flag(460) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	change_state = event.get_character_change_state(1) or change_state
	if change_state == 0 then
		return 0
	end
	return 1
end

--- Returns 1 when analysis group 2 is complete, save flag 468 is clear and a character change is available.
function georama.can_start_event_468()
	local save_flag: s32 = 0
	local change_state: s32 = 0
	if georama.is_analysis_group_2_complete() == 0 then
		return 0
	end
	save_flag = event.get_save_flag(468) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	change_state = event.get_character_change_state(1) or change_state
	if change_state == 0 then
		return 0
	end
	return 1
end

--- Returns 1 when analysis flag 403 is set and save flag 548 is still clear.
function georama.can_start_event_548()
	local save_flag: s32 = 0
	if georama.is_analysis_flag_403_set() == 0 then
		return 0
	end
	save_flag = event.get_save_flag(548) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	return 1
end

--- Returns 1 when analysis flag 406 is set and save flag 552 is still clear.
function georama.can_start_event_552()
	local save_flag: s32 = 0
	if georama.is_analysis_flag_406_set() == 0 then
		return 0
	end
	save_flag = event.get_save_flag(552) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	return 1
end

--- Returns 1 when analysis flag 410 is set and save flag 556 is still clear.
function georama.can_start_event_556()
	local save_flag: s32 = 0
	if georama.is_analysis_flag_410_set() == 0 then
		return 0
	end
	save_flag = event.get_save_flag(556) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	return 1
end

--- Returns 1 when analysis group 3 is complete, save flag 560 is clear and a character change is available.
function georama.can_start_event_560()
	local save_flag: s32 = 0
	local change_state: s32 = 0
	if georama.is_analysis_group_3_complete() == 0 then
		return 0
	end
	save_flag = event.get_save_flag(560) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	change_state = event.get_character_change_state(1) or change_state
	if change_state == 0 then
		return 0
	end
	return 1
end

--- Returns 0 because its placeholder condition is never met.
function georama.can_start_placeholder_event_a()
	local _ = if georama.is_placeholder_condition_met() == 0 then 1 else 0
	local _ = if georama.is_placeholder_condition_met() == 0 then 1 else 0
	return 0
end

--- Returns 0 because its placeholder condition is never met.
function georama.can_start_placeholder_event_b()
	local _ = if georama.is_placeholder_condition_met() == 0 then 1 else 0
	local _ = if georama.is_placeholder_condition_met() == 0 then 1 else 0
	return 0
end

--- Returns 0 because its placeholder condition is never met.
function georama.can_start_placeholder_event_c()
	local _ = if wait.background_load_skipping() == 0 then 1 else 0
	local _ = if wait.background_load_skipping() == 0 then 1 else 0
	return 0
end

--- Returns 1 when the analysis of map 0 reaches 100 percent, save flag 285 is clear and character 1 can be changed to.
function georama.can_trigger_full_analysis_event()
	local analysis_percent: s32 = 0
	local save_flag: s32 = 0
	local change_state: s32 = 0
	analysis_percent = event.get_georama_analysis_percent(0) or analysis_percent
	if analysis_percent < 100 then
		return 0
	end
	save_flag = event.get_save_flag(285) or save_flag
	if save_flag ~= 0 then
		return 0
	end
	change_state = event.get_character_change_state(1) or change_state
	if change_state == 0 then
		return 0
	end
	return 1
end

--- Returns the georama analysis flag 206.
function georama.is_analysis_flag_206_set()
	local analysis_flag: s32 = 0
	analysis_flag = event.get_georama_analysis_flag(206) or analysis_flag
	return analysis_flag
end

--- Returns the georama analysis flag 207.
function georama.is_analysis_flag_207_set()
	local analysis_flag: s32 = 0
	analysis_flag = event.get_georama_analysis_flag(207) or analysis_flag
	return analysis_flag
end

--- Returns the georama analysis flag 209.
function georama.is_analysis_flag_209_set()
	local analysis_flag: s32 = 0
	analysis_flag = event.get_georama_analysis_flag(209) or analysis_flag
	return analysis_flag
end

--- Returns the georama analysis flag 301.
function georama.is_analysis_flag_301_set()
	local analysis_flag: s32 = 0
	analysis_flag = event.get_georama_analysis_flag(301) or analysis_flag
	return analysis_flag
end

--- Returns the georama analysis flag 302.
function georama.is_analysis_flag_302_set()
	local analysis_flag: s32 = 0
	analysis_flag = event.get_georama_analysis_flag(302) or analysis_flag
	return analysis_flag
end

--- Returns the georama analysis flag 305.
function georama.is_analysis_flag_305_set()
	local analysis_flag: s32 = 0
	analysis_flag = event.get_georama_analysis_flag(305) or analysis_flag
	return analysis_flag
end

--- Returns the georama analysis flag 403.
function georama.is_analysis_flag_403_set()
	local analysis_flag: s32 = 0
	analysis_flag = event.get_georama_analysis_flag(403) or analysis_flag
	return analysis_flag
end

--- Returns the georama analysis flag 406.
function georama.is_analysis_flag_406_set()
	local analysis_flag: s32 = 0
	analysis_flag = event.get_georama_analysis_flag(406) or analysis_flag
	return analysis_flag
end

--- Returns the georama analysis flag 410.
function georama.is_analysis_flag_410_set()
	local analysis_flag: s32 = 0
	analysis_flag = event.get_georama_analysis_flag(410) or analysis_flag
	return analysis_flag
end

--- Returns 1 when georama analysis group 1 has reached 100 percent.
function georama.is_analysis_group_1_complete()
	local percent: s32 = 0
	percent = event.get_georama_analysis_percent(1) or percent
	if percent < 100 then
		return 0
	end
	return 1
end

--- Returns 1 when georama analysis group 2 has reached 100 percent.
function georama.is_analysis_group_2_complete()
	local percent: s32 = 0
	percent = event.get_georama_analysis_percent(2) or percent
	if percent < 100 then
		return 0
	end
	return 1
end

--- Returns 1 when georama analysis group 3 has reached 100 percent.
function georama.is_analysis_group_3_complete()
	local percent: s32 = 0
	percent = event.get_georama_analysis_percent(3) or percent
	if percent < 100 then
		return 0
	end
	return 1
end

--- Returns 0 because the placeholder condition is never met.
function georama.is_placeholder_condition_met()
	local result: s32 = 0
	return result
end

return georama
