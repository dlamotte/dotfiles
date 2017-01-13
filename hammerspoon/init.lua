hs.hotkey.bind({'ctrl', 'alt'}, 'R',
    function()
        hs.reload()
    end
)

local HOME = os.getenv('HOME')

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
