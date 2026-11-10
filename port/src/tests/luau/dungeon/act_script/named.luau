local vm = require("@lib/vm")

local script = {}

function script.setup()
    return 3
end

function script.init()
    action.set_program_value(100)
end

function script.loop()
    action.set_program_value(200)
    vm.wait()
    action.set_program_value(201)
end

-- Program 100 is named init, so this numeric key must never run.
script[100] = function()
    action.set_program_value(-1)
end

return script
