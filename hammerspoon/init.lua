hs.logger.defaultLogLevel = "info"

-- first so when you break things, you can still reload with a hotkey
hs.hotkey.bind({'ctrl', 'alt'}, 'R',
    function()
        hs.reload()
    end
)

hs.hotkey.bind({'ctrl', 'alt'}, 'b',
    function()
        hs.brightness.set(100)
    end
)

hs.screen.watcher.new(function()
    hs.brightness.set(100)
end)

local external_laptop = "1920x1080+1728x1117"
local external_only = "1920x1080"
local g9 = "5120x1440"
local g9_external = "1728x1117+5120x1440"
local laptop_external = "1728x1117+1920x1080"
local laptop_only = "1728x1117"

layout = require('layout').new(
    {
        {mod = {'ctrl', 'cmd', 'shift'}, key = 'F', action = 'focus'},
        {mod = {'ctrl', 'cmd'}, key = 'F', action = 'full'},
        {mod = {'ctrl', 'cmd'}, key = 'L', action = 'push-right'},
        {mod = {'ctrl', 'cmd'}, key = 'H', action = 'push-left'},
        {mod = {'ctrl', 'alt'}, key = '1', layout = 'laptop'},
        {mod = {'ctrl', 'alt'}, key = '2', layout = 'external'},
        {mod = {'ctrl', 'alt'}, key = '3', layout = 'external2'},
        {mod = {'ctrl', 'alt'}, key = '4', layout = 'laptop_external'},
        {mod = {'ctrl', 'alt'}, key = '5', layout = 'laptop_g9'},
        {mod = {'ctrl', 'alt'}, key = '6', layout = 'g9'}
    },
    {
        {
            app = 'Google Chrome',
            layouts = {
                [laptop_only]       = {1, 'full'},
                laptop_external     = {2, 'half-left'},
                external            = {1, 'half-right'},
                external2           = {2, 'half-left'},
                laptop_g9           = {2, 'third-left'},
                [g9]                = {1, 'third-left'},
                [g9_external]       = {2, 'third-left'},
                [external_laptop]   = {2, 'full'},
                [laptop_external]   = {1, 'full'},
                [external_only]     = {1, 'full'},
            },
            windows = {
                {
                    re = "(personal)",
                    layouts = {
                        [laptop_only]       = {1, 'full'},
                        laptop_external     = {2, 'half-left'},
                        external            = {1, 'half-right'},
                        external2           = {2, 'half-left'},
                        laptop_g9           = {1, 'full'},
                        [g9]                = {1, 'third-left'},
                        [g9_external]       = {2, 'third-left'},
                        [external_laptop]   = {2, 'full'},
                        [laptop_external]   = {1, 'full'},
                        [external_only]     = {1, 'full'},
                    }
                }
            }
        },
        {
            app = 'iTerm2',
            layouts = {
                [laptop_only]       = {1, 'full'},
                laptop_external     = {1, 'full'},
                external            = {1, 'half-left'},
                external2           = {1, 'half-right'},
                laptop_g9           = {2, 'third-mid'},
                [g9]                = {1, 'third-mid'},
                [g9_external]       = {2, 'third-mid'},
                [external_laptop]   = {1, 'full'},
                [laptop_external]   = {2, 'full'},
                [external_only]     = {1, 'full'},
            }
        },
        {
            app = 'Ghostty',
            layouts = {
                [laptop_only]       = {1, 'full'},
                laptop_external     = {1, 'full'},
                external            = {1, 'half-left'},
                external2           = {1, 'half-right'},
                laptop_g9           = {2, 'third-mid'},
                [g9]                = {1, 'third-mid'},
                [g9_external]       = {2, 'third-mid'},
                [external_laptop]   = {1, 'full'},
                [laptop_external]   = {2, 'full'},
                [external_only]     = {1, 'full'},
            }
        },
        {
            app = 'Slack',
            layouts = {
                [laptop_only]       = {1, 'full'},
                laptop_external     = {2, 'half-right'},
                external            = {1, 'half-left'},
                external2           = {2, 'half-right'},
                laptop_g9           = {2, 'third-right'},
                [g9]                = {1, 'third-right'},
                [g9_external]       = {2, 'third-right'},
                [external_laptop]   = {2, 'full'},
                [laptop_external]   = {1, 'full'},
                [external_only]     = {1, 'full'},
            }
        },
        {
            app = 'zoom.us',
            layouts = {
                [laptop_only]       = {1, 'full'},
                laptop_external     = {2, 'half-right'},
                external            = {1, 'half-left'},
                external2           = {2, 'half-right'},
                laptop_g9           = {2, 'third-mid-wide'},
                [g9]                = {1, 'third-mid-wide'},
                [g9_external]       = {2, 'third-mid-wide'},
                [external_laptop]   = {2, 'full'},
                [laptop_external]   = {1, 'full'},
                [external_only]     = {1, 'full'},
            }
        },
        {
            app = 'Discord',
            layouts = {
                [g9]                = {1, 'third-right'},
                [g9_external]       = {2, 'third-right'},
                [external_laptop]   = {2, 'full'},
                [laptop_external]   = {1, 'full'},
                [external_only]     = {1, 'full'},
            }
        },
    }
)
layout:start()

-- push2talk = require('push2talk').new({'ctrl', 'alt'}, 'M', 'U')
-- push2talk:start()

-- require('outlook').bind({
--     {mod = {'alt'}, key = '1', label = 'Red'},
--     {mod = {'alt'}, key = '2', label = 'Yellow'},
--     {mod = {'alt'}, key = '3', label = 'Green'},
--     {mod = {'alt'}, key = '4', label = 'Blue'},
--     {mod = {'alt'}, key = '5', label = 'Purple'},
--     {mod = {'alt'}, key = '6', label = nil}
-- })
