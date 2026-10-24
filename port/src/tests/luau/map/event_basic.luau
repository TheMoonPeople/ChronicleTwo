local script = {}

function script.setup()
    event.Ext(1, 50)
end

function script.event_3()
    event.Ext(1, 1)
    coroutine.yield()
    event.Ext(1, 2)
end

return script
