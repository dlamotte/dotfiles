local mash = {"ctrl", "alt", "cmd"}

hs.hotkey.bind(mash, "W", function()
    hs.alert.show("hello world")
end)

hs.hotkey.bind(mash, "M", function()
    device = hs.audiodevice.findDeviceByName('Built-in Microphone')
    is_muted = device:muted()

    if is_muted then
        device:setMuted(not is_muted)
        hs.alert.show(' mic unmuted')
    end
end,
function()
    device = hs.audiodevice.findDeviceByName('Built-in Microphone')
    is_muted = device:muted()

    if not is_muted then
        device:setMuted(not is_muted)
        hs.alert.show(' mic muted')
    end
end
)

hs.hotkey.bind(mash, "U", function()
    device = hs.audiodevice.findDeviceByName('Built-in Microphone')
    is_muted = device:muted()

    if is_muted then
        device:setMuted(not is_muted)
        hs.alert.show(' mic unmuted')
    end
end)
