local script = {}

function script.setup()
    event.call_command(1, 50)
end

function script.event_3()
    event.call_command(1, 1)
    coroutine.yield()
    event.call_command(1, 2)
end

return script
