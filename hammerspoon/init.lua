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

layout = require('layout').new(
    {
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
            app = 'Gitify',
            layouts = {
                laptop              = {1, 'full'},
                laptop_external     = {2, 'half-right'},
                external            = {1, 'half-right'},
                external2           = {2, 'half-right'},
                laptop_g9           = {2, 'third-right'},
                g9                  = {1, 'third-right'},
            }
        },
        {
            app = 'Google Chrome',
            layouts = {
                laptop              = {1, 'full'},
                laptop_external     = {2, 'half-left'},
                external            = {1, 'half-right'},
                external2           = {2, 'half-left'},
                laptop_g9           = {2, 'third-left'},
                g9                  = {1, 'third-left'},
            },
            windows = {
                {
                    re = "(personal)",
                    layouts = {
                        laptop              = {1, 'full'},
                        laptop_external     = {2, 'half-left'},
                        external            = {1, 'half-right'},
                        external2           = {2, 'half-left'},
                        laptop_g9           = {1, 'full'},
                        g9                  = {1, 'third-left'},
                    }
                }
            }
        },
        {
            app = 'iTerm2',
            layouts = {
                laptop              = {1, 'full'},
                laptop_external     = {1, 'full'},
                external            = {1, 'half-left'},
                external2           = {1, 'half-right'},
                laptop_g9           = {2, 'third-mid'},
                g9                  = {1, 'third-mid'},
            }
        },
        {
            app = 'Slack',
            layouts = {
                laptop              = {1, 'full'},
                laptop_external     = {2, 'half-right'},
                external            = {1, 'half-left'},
                external2           = {2, 'half-right'},
                laptop_g9           = {2, 'third-right'},
                g9                  = {1, 'third-right'},
            }
        },
        {
            app = 'zoom.us',
            layouts = {
                laptop              = {1, 'full'},
                laptop_external     = {2, 'half-right'},
                external            = {1, 'half-left'},
                external2           = {2, 'half-right'},
                laptop_g9           = {2, 'third-mid-wide'},
                g9                  = {1, 'third-mid-wide'},
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
