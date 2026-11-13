--!strict
--- Bit-flag helpers for event state words.

local vm = require("@lib/vm")
local georama = vm.module("@lib/event/georama")
local starlight_temple = vm.module("@lib/event/starlight_temple")

local flag = {}

--- Clears from a value every bit that is also set in a mask and returns the result.
function flag.clear_bits(value: s32, mask: s32)
	local bit_mask: s32 = 0
	bit_mask = 1
	for i = 0, 31 do
		if (if vm.i32(bit32.band(value, bit_mask)) ~= 0 then vm.i32(bit32.band(mask, bit_mask)) else 0) ~= 0 then
			value = vm.i32(value - bit_mask)
		end
		bit_mask = vm.i32(bit_mask * 2)
	end
	return value
end

--- Stores the placeholder condition into flag 401 and clears flags 406 and 407.
function flag.reset_401_406_407()
	starlight_temple.ignore_character_activation(401, georama.is_placeholder_condition_met())
	local _ = if georama.is_placeholder_condition_met() == 0 then 1 else 0
	starlight_temple.ignore_character_activation(406, 0)
	local _ = if georama.is_placeholder_condition_met() == 0 then 1 else 0
	starlight_temple.ignore_character_activation(407, 0)
end

--- Resume-path counterpart of clear_bits that subtracts the shared bits from the value.
function flag.resume_clear_bits(value: s32, mask: s32)
	local i: s32 = 0
	local bit_mask: s32 = 0
	bit_mask = 1
	i = 0
	local _ = vm.i32(bit32.band(value, bit_mask))
	value = vm.i32(value - bit_mask)
	local _ = vm.i32(bit32.band(mask, bit_mask))
	bit_mask = bit_mask * 2
	local _ = i < 32
	i = i + 1
	return value
end

--- Stores the placeholder condition into flags 307, 308 and 311 to 314.
function flag.store_307_to_314()
	starlight_temple.ignore_character_activation(307, georama.is_placeholder_condition_met())
	starlight_temple.ignore_character_activation(308, georama.is_placeholder_condition_met())
	starlight_temple.ignore_character_activation(311, georama.is_placeholder_condition_met())
	starlight_temple.ignore_character_activation(312, georama.is_placeholder_condition_met())
	starlight_temple.ignore_character_activation(313, georama.is_placeholder_condition_met())
	starlight_temple.ignore_character_activation(314, georama.is_placeholder_condition_met())
end

--- Reads the placeholder condition and then stores flags 307, 308 and 311 to 314.
function flag.sync_307_to_314()
	local _ = georama.is_placeholder_condition_met()
	local _ = if georama.is_placeholder_condition_met() == 0 then 1 else 0
	flag.store_307_to_314()
end

--- Reads the placeholder condition and then resets the 401, 406 and 407 flag group.
function flag.sync_401_406_407()
	local _ = georama.is_placeholder_condition_met()
	flag.reset_401_406_407()
end

--- Updates the temple georama flags through the placeholder flag setters.
function flag.update_temple_flags()
	starlight_temple.forward_analysis_flags()
end

return flag
