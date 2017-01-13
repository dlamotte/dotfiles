local mash = {"ctrl", "alt", "cmd"}
local mb_mic = hs.menubar.new()
mb_mic:priority(0)

local icon_muted = hs.image.imageFromASCII(table.concat({
    '................',
    '..S..F....F.....',
    '.R..............',
    '................',
    '................',
    '................',
    '.....A....B.....',
    '................',
    '.....H....H.....',
    '.....F....F.....',
    '..1..D....C..8..',
    '..2..........7..',
    '.......HH.......',
    '...3........6...',
    '......J..K....P.',
    '.......45....Q..',
    '................',
    '.......ML.......'}, '\n'),
    {{
        strokeColor = {alpha = 1},
        fillColor   = {alpha = 0},
        strokeWidth = 2,
        shouldClose = false,
--        antialias = false
    },
    {
        shouldClose = true
    }}
)
local icon_unmuted = hs.image.imageFromASCII(table.concat({
    '................',
    '.....F....F.....',
    '................',
    '................',
    '................',
    '................',
    '.....A....B.....',
    '................',
    '.....H....H.....',
    '.....F....F.....',
    '..1..D....C..8..',
    '..2..........7..',
    '.......HH.......',
    '...3........6...',
    '......J..K......',
    '.......45.......',
    '................',
    '.......ML.......'}, '\n'),
    {{
        strokeColor = {alpha = 1},
        fillColor   = {alpha = 0},
        strokeWidth = 2,
        shouldClose = false,
--        antialias = false
    },
    {
        shouldClose = true
    }}
)

mb_mic:setIcon(icon_unmuted)

hs.hotkey.bind(mash, "W", function()
    hs.alert.show("hello world")
end)

hs.hotkey.bind({'ctrl', 'alt'}, "M", function()
    is_changed = false
    for _, device in pairs(hs.audiodevice.allInputDevices()) do
        is_muted = device:inputMuted()

        if is_muted then
            device:setInputMuted(false)
            is_changed = true
        end
    end

    if is_changed then
        hs.alert.show(' mic unmuted')
        mb_mic:setIcon(icon_unmuted)
    end
end,
function()
    is_changed = false
    for _, device in pairs(hs.audiodevice.allInputDevices()) do
        is_muted = device:inputMuted()

        if not is_muted then
            device:setInputMuted(true)
            is_changed = true
        end
    end

    if is_changed then
        hs.alert.show(' mic muted')
        mb_mic:setIcon(icon_muted)
    end
end
)

hs.hotkey.bind({'ctrl', 'alt'}, "U", function()
    is_changed = false
    for _, device in pairs(hs.audiodevice.allInputDevices()) do
        is_muted = device:inputMuted()

        if is_muted then
            device:setInputMuted(false)
            is_changed = true
        end
    end

    if is_changed then
        hs.alert.show(' mic unmuted')
        mb_mic:setIcon(icon_unmuted)
    end
end)
