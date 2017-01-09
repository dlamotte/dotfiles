local mash = {"ctrl", "alt", "cmd"}

hs.hotkey.bind(mash, "W", function()
    hs.alert.show("hello world")
end)

hs.hotkey.bind(mash, "M", function()
    is_changed = false
    for _, device in pairs(hs.audiodevice.allInputDevices()) do
        is_muted = device:muted()

        if is_muted then
            device:setMuted(not is_muted)
            is_changed = true
        end
    end

    if is_changed then
        hs.alert.show(' mic unmuted')
    end
end,
function()
    is_changed = false
    for _, device in pairs(hs.audiodevice.allInputDevices()) do
        is_muted = device:muted()

        if not is_muted then
            device:setMuted(not is_muted)
            is_changed = true
        end
    end

    if is_changed then
        hs.alert.show(' mic muted')
    end
end
)

hs.hotkey.bind(mash, "U", function()
    is_changed = false
    for _, device in pairs(hs.audiodevice.allInputDevices()) do
        is_muted = device:muted()

        if is_muted then
            device:setMuted(not is_muted)
            is_changed = true
        end
    end

    if is_changed then
        hs.alert.show(' mic unmuted')
    end
end)
