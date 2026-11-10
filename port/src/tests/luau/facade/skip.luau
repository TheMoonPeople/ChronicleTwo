local script = {}
local skip_site = nil

-- Stops the program at a wait in skip mode, or suspends until resumed.
local function wait(site)
    if vmhost.skipping() then
        error({ site = site }, 0)
    end
    coroutine.yield()
    if vmhost.skipping() then
        error({ site = site }, 0)
    end
end

-- Runs a body as a skippable section; a wait in skip mode lands in skip, which then ends the skip.
local function section(body, skip)
    local ok, err = pcall(body)
    if not ok then
        if type(err) ~= "table" or err.site == nil then
            error(err, 0)
        end
        if skip then
            skip(err.site)
        end
        if vmhost.skip_end() then
            coroutine.yield()
        end
        return
    end
    vmhost.skip_end()
end

script[1] = function()
    section(function()
        event.call_command(1, 1)
        wait(10)
        event.call_command(1, 2)
        wait(11)
        event.call_command(1, 3)
    end, function(site)
        event.call_command(1, 100 + site)
        skip_site = site
    end)
    event.call_command(1, 99)
    return skip_site or 0
end

script[2] = function()
    section(function()
        event.call_command(1, 5)
    end)
    event.call_command(1, 7)
end

script[3] = function()
    wait(1)
    event.call_command(1, 8)
end

-- Reads a flag inside a skipped section (the call is dropped, so the output is nil) and again after it (the handler answers).
script[4] = function()
    local skipped_nil = 0
    section(function()
        wait(1)
    end, function()
        local value = event.get_save_flag(3)
        if value == nil then
            skipped_nil = 1
        end
    end)
    local answered = event.get_save_flag(3)
    return skipped_nil * 10 + (if answered == 77 then 1 else 0)
end

return script
