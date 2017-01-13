push2talk = require('push2talk').new({'ctrl', 'alt'}, 'M', 'U')
push2talk:start()

local mash = {"ctrl", "alt", "cmd"}
hs.hotkey.bind(mash, "W", function()
    hs.alert.show("hello world")
end)
