local Outlook = {}
Outlook.__index = Outlook

Outlook.script_label = [[
tell application "Microsoft Outlook"
    set selectedMessages to current messages
    if selectedMessages is {} then
        return
    end if

    repeat with theMessage in selectedMessages
        set category of theMessage to {category "%s"}
    end repeat
end tell
]]
Outlook.script_label_none = [[
tell application "Microsoft Outlook"
    set selectedMessages to current messages
    if selectedMessages is {} then
        return
    end if

    repeat with theMessage in selectedMessages
        set category of theMessage to {}
    end repeat
end tell
]]

function Outlook.bind(scripts)
    for _, d in ipairs(scripts) do
        hs.hotkey.bind(d.mod, d.key,
            function()
                local app = hs.window.focusedWindow():application()
                if app:title() ~= 'Microsoft Outlook' then
                    return
                end

                if d.label == nil then
                    hs.osascript.applescript(Outlook.script_label_none)
                else
                    hs.osascript.applescript(string.format(Outlook.script_label, d.label))
                end
            end
        )
    end
end

return Outlook
