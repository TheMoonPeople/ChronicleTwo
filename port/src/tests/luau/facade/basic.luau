local vm = require("@lib/vm")

local counter = 0

return {
    setup = function()
        return 7
    end,
    [100] = function()
        counter += 1
        action.set_program_value(counter)
    end,
    [200] = function()
        action.set_program_value(1)
        vm.wait()
        action.set_program_value(2)
        vm.wait()
        action.set_program_value(3)
    end,
}
