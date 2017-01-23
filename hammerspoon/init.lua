-- first so when you break things, you can still reload with a hotkey
hs.hotkey.bind({'ctrl', 'alt'}, 'R',
    function()
        hs.reload()
    end
)

layout = require('layout').new(
    {
        {mod = {'ctrl', 'cmd'}, key = 'F', action = 'full'},
        {mod = {'ctrl', 'cmd'}, key = 'L', action = 'push-right'},
        {mod = {'ctrl', 'cmd'}, key = 'H', action = 'push-left'},
        {mod = {'ctrl', 'alt'}, key = '1', layout = 'laptop'},
        {mod = {'ctrl', 'alt'}, key = '2', layout = 'thunderbolt'},
        {mod = {'ctrl', 'alt'}, key = '3', layout = 'thunderbolt2'}
    },
    {
        {
            app = 'Google Chrome',
            layouts = {
                laptop       = {1, 'full'},
                thunderbolt  = {1, 'half-left'},
                thunderbolt2 = {1, 'half-right'},
            }
        },
        {
            app = 'iTerm2',
            layouts = {
                laptop       = {1, 'full'},
                thunderbolt  = {1, 'half-right'},
                thunderbolt2 = {2, 'half-left'},
            }
        },
        {
            app = 'Microsoft Outlook',
            layouts = {
                laptop       = {1, 'full'},
                thunderbolt  = {1, 'half-left'},
                thunderbolt2 = {1, 'half-left'},
            },
            windows = {
                {re = '[0-9]+ Reminder', layouts = {
                    laptop       = {1, 'fullish-bottom'},
                    thunderbolt  = {1, 'halfish-right-bottom'},
                    thunderbolt2 = {1, 'halfish-right-bottom'},
                }}
            }
        },
        {
            app = 'Slack',
            layouts = {
                laptop       = {1, 'full'},
                thunderbolt  = {1, 'half-left'},
                thunderbolt2 = {1, 'half-left'},
            }
        },
        {
            app = 'Gitter',
            layouts = {
                laptop       = {1, 'full'},
                thunderbolt  = {1, 'half-left'},
                thunderbolt2 = {1, 'half-left'},
            }
        },
        {
            app = 'Sococo',
            layouts = {
                laptop       = {1, 'full'},
                thunderbolt  = {1, 'half-right'},
                thunderbolt2 = {2, 'half-right'},
            }
        },
        {
            app = 'Jabber',
            layouts = {
                laptop       = {1, 'jabber'},
                thunderbolt  = {1, 'jabber'},
                thunderbolt2 = {2, 'jabber'},
            },
            windows = {
                {noteq = 'Cisco Jabber', layouts = {
                    laptop       = {1, 'jabber-convo'},
                    thunderbolt  = {1, 'jabber-convo-half-right'},
                    thunderbolt2 = {2, 'jabber-convo-half-right'},
                }}
            }
        },
    }
)
layout:start()

push2talk = require('push2talk').new({'ctrl', 'alt'}, 'M', 'U')
push2talk:start()

require('outlook').bind({
    {mod = {'alt'}, key = '1', label = 'Red'},
    {mod = {'alt'}, key = '2', label = 'Yellow'},
    {mod = {'alt'}, key = '3', label = 'Green'},
    {mod = {'alt'}, key = '4', label = 'Blue'},
    {mod = {'alt'}, key = '5', label = 'Purple'},
    {mod = {'alt'}, key = '6', label = nil}
})
