local Layout = {}
Layout.__index = Layout

function Layout.new(hotkeys, layouts)
    local self = setmetatable({}, Layout)
    self.hotkeys = hotkeys
    self.layout = nil
    self.layouts = layouts
    self.log = hs.logger.new("layout", "info")
    return self
end

function Layout:action(name)
    local win = hs.window.focusedWindow()
    local screen = win:screen()
    local frame = screen:frame()
    local winFrame = screen:absoluteToLocal(win:frame())
    local update = false
    local split = 2

    frame = screen:absoluteToLocal(frame)

    if self.isg9(screen) then
        split = 3
    end

    local section = frame.w / split
    local currentSection = math.floor((winFrame.x1 + 10) / section)

    if name == 'full' then
        update = true

    elseif name == 'focus' then
        col = math.floor(screen:frame().w / 5)
        frame.w = col * 3
        frame.x1 = col
        frame.x2 = frame.x1 + frame.w
        update = true

    elseif name == 'push-right' then
        frame.w = math.floor(frame.w / split)
        frame.x1 = math.floor(frame.w * math.min(currentSection + 1, split))
        update = true

    elseif name == 'push-left' then
        frame.w = math.floor(frame.w / split)
        frame.x1 = math.floor(frame.w * math.max(currentSection - 1, 0))
        update = true

    end

    if update then
        frame = screen:localToAbsolute(frame)
        win:setFrame(frame, 0)
    end
end

function Layout:bind()
    for _, d in ipairs(self.hotkeys) do
        if d.action then
            hs.hotkey.bind(d.mod, d.key, function()
                self:action(d.action)
            end)
        elseif d.layout then
            hs.hotkey.bind(d.mod, d.key, function()
                self.layout = d.layout
                self:render()
            end)
        end
    end
end

function Layout:detect()
    local screens = self:screens()
    local dim = ""

    for _, screen in ipairs(self:screens()) do
        local frame = screen:fullFrame()
        if string.len(dim) > 0 then
            dim = dim .. "+"
        end
        dim = dim .. tostring(math.tointeger(frame.w)) .. "x" .. tostring(math.tointeger(frame.h))
    end

    self.layout = dim

    self.log.i("detected layout " .. self.layout)
end

function Layout.isLaptopScreen(screen)
    local frame = screen:fullFrame()

    return frame.w == 1680 and frame.h == 1050
end

function Layout.isExternalScreen(screen)
    local frame = screen:fullFrame()

    return frame.w == 1920 and frame.h == 1080
end

function Layout.isg9(screen)
    local frame = screen:fullFrame()

    return frame.w == 5120 and frame.h == 1440
end

function Layout:identify()
    -- identify screens, useful for debugging
    for i, screen in ipairs(self:screens()) do
        hs.alert.show(
            i .. ' -> ' .. screen:id(),
            hs.alert.defaultStyle,
            screen
        )
    end
end

function Layout:render(onlyapp)
    local screens = self:screens()
    for _, def in ipairs(self.layouts) do
        local app = hs.application.get(def.app)
        local layout = def.layouts[self.layout]

        if onlyapp and app ~= onlyapp then
            app = nil
        end

        if app then
            for _, win in ipairs(app:allWindows()) do
                local screen = screens[layout[1]]
                local position = layout[2]

                if def.windows then
                    local title = win:title()
                    for _, defwin in ipairs(def.windows) do
                        if (defwin.re and string.match(title, defwin.re))
                            or (defwin.noteq and title ~= defwin.noteq) then

                            screen = screens[defwin.layouts[self.layout][1]]
                            position = defwin.layouts[self.layout][2]
                            break
                        end
                    end
                end

                if not screen then
                    screen = screens[1]
                end

                win:moveToScreen(screen, 0)
                local frame = screen:frame()
                local new = screen:frame()
                local update = false

                if position == 'full' then
                    update = true

                elseif position == 'half-left' then
                    new.w = new.w / 2
                    update = true

                elseif position == 'half-right' then
                    new.w = new.w / 2
                    new.x1 = new.x1 + new.w
                    update = true

                elseif position == 'third-left' then
                    new.w = new.w / 3
                    update = true

                elseif position == 'third-mid' then
                    new.w = new.w / 3
                    new.x1 = new.x1 + new.w
                    update = true

                elseif position == 'third-mid-wide' then
                    new.w = new.w / 5
                    new.x1 = new.x1 + new.w
                    new.x2 = frame.x2 - new.w
                    update = true

                elseif position == 'third-right' then
                    new.w = new.w / 3
                    new.x1 = new.x1 + new.w * 2
                    update = true

                elseif position == 'fullish-bottom' then
                    new.x1 = new.x1 + 100
                    new.x2 = frame.x2 - 100
                    new.y1 = new.y2 - 200
                    update = true

                elseif position == 'halfish-right-bottom' then
                    new.x1 = new.x1 + 100
                    new.x2 = frame.x2 / 2 - 200
                    new.y1 = new.y1 + new.y2 - 200
                    update = true

                elseif position == 'midish-top' then
                    new.x1 = new.x1 + 100
                    new.x2 = frame.x2 / 2 - 200
                    new.y1 = 300
                    update = true

                elseif position == 'jabber' then
                    new.x1 = frame.x2 - 450
                    new.w = 450
                    update = true

                elseif position == 'jabber-convo' then
                    new.x2 = frame.x2 - 455
                    update = true

                elseif position == 'jabber-convo-half-right' then
                    new.x1 = frame.x2 / 2
                    new.x2 = frame.x2 - 455
                    update = true

                end

                if update then
                    win:setFrame(new, 0)
                end
            end
        end
    end
end

function Layout:screens()
    -- sort screens in position order (left to right)
    local iter = hs.fnutils.sortByKeyValues(
        hs.screen.allScreens(),
        function(a, b)
            local ax, ay = a:position()
            local bx, by = b:position()
            -- true = a should appear before b
            return ax < bx
        end
    )

    local screens = {}
    local i = 1
    for _, screen in iter do
        screens[i] = screen
        i = i + 1
    end

    return screens
end

function Layout:start()
    self:bind()
    self:detect()
    self:render()

    self.screen_watcher = hs.screen.watcher.new(function()
        self:detect()
        self:render()
    end)
    self.screen_watcher:start()

    self.app_watcher = hs.application.watcher.new(
        function(appname, evtype, app)
            if app and evtype == hs.application.watcher.launched then
                self:render(app)
            end
        end
    )
    self.app_watcher:start()
end

return Layout
