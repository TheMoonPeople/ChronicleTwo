local script = {}

-- An integer range must reach the handler as an integer and come back as one; a fractional range stays a float.
function script.event_3()
    local whole = event.get_random_number_int(10)
    local fraction = event.get_random_number(6.25)
    event.call_command(1, whole or -1, fraction or -1)
end

return script
