istats = os.getenv("HOME") .. "/bin/istats"

-- Get output of a bash command
function os.capture(cmd)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*line'))
  f:close()
  s = string.gsub(s, '%s*', '')
  return s
end

-- Update the fan and temp. Needs iStats CLI tool from homebrew.
function updateStats()
  local fanSpeed = os.capture(istats .. " fan speed --value-only")
  local batt = os.capture(istats .. " battery charge --value-only")
  statsMenu:setTitle(batt .. "% - " .. fanSpeed .. " RPM")
end

statsMenu = hs.menubar.new()
updateStats()

statsMenuTimer = hs.timer.new(20, updateStats)
statsMenuTimer:start()
