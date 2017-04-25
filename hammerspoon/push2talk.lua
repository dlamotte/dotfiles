local Push2Talk = {}
Push2Talk.__index = Push2Talk

Push2Talk.icon_muted = hs.image.imageFromASCII(table.concat({
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
Push2Talk.icon_unmuted = hs.image.imageFromASCII(table.concat({
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

function Push2Talk.new(key_mod, key_push2talk, key_unmute)
    local self = setmetatable({}, Push2Talk)
    self.mb = nil
    self.key_mod = key_mod
    self.key_push2talk = key_push2talk
    self.key_unmute = key_unmute
    self.timer = hs.timer.doEvery(10, function() self:alert_unmuted() end)

    self.style = hs.fnutils.copy(hs.alert.defaultStyle)
    self.style.fillColor = {
        alpha = 0.7,
        red = 1
    }
    self.style.strokeColor = {
        alpha = 1,
        red = 1
    }
    return self
end

function Push2Talk:bind()
    hs.hotkey.bind(self.key_mod, self.key_push2talk,
        function()
            self:unmute()
        end,
        function()
            self:mute()
        end
    )

    hs.hotkey.bind(self.key_mod, self.key_unmute,
        function()
            self:unmute()
        end
    )
end

function Push2Talk:mute(force)
    is_changed = force or false
    for _, device in pairs(hs.audiodevice.allInputDevices()) do
        is_muted = device:inputMuted()

        if not is_muted then
            device:setInputMuted(true)
            is_changed = true
        end
    end

    if is_changed then
        hs.alert.show(' mic muted')
        self.mb:setIcon(self.icon_muted)
        self.timer:stop()
    end

    return is_changed
end

function Push2Talk:alert_unmuted()
    hs.alert.show(' mic unmuted', self.style)
end

function Push2Talk:start()
    if self.mb == nil then
        self.mb = hs.menubar.new()
    end

    self.mb:priority(hs.menubar.priorities.system - 1)
    self:bind()
    self:mute(true)
end

function Push2Talk:unmute()
    is_changed = false
    for _, device in pairs(hs.audiodevice.allInputDevices()) do
        is_muted = device:inputMuted()

        if is_muted then
            device:setInputMuted(false)
            is_changed = true
        end
    end

    if is_changed then
        self:alert_unmuted()
        self.mb:setIcon(self.icon_unmuted)
        self.timer:start()
    end

    return is_changed
end

return Push2Talk
