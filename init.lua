-- this needs brew install choose-gui

function map(func, array)
  local new_array = {}
  for i,v in ipairs(array) do
    new_array[i] = func(v)
  end
  return new_array
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  hs.reload()
end)
hs.alert.show("Config loaded")

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "space", function()
  filter = hs.window.filter.new(nil)
  windows = filter:getWindows()
  titleString = ""
  ids = {}
  currentIx = -1
  for i, window in ipairs(windows) do
    title = window:title()
    if not (title == "") then
      app = window:application()
      appName = app:name()
      fullTitle = appName .. " - " .. title
      currentIx = currentIx + 1
      ids[currentIx] = window:id()
      titleString = titleString .. fullTitle .. "\n"
    end
  end
  file = io.open("/tmp/window-list.txt", "w")
  file:write(titleString)
  file:close()
  proc = io.popen("/usr/local/bin/choose -i </tmp/window-list.txt", "r")
  choice = proc:read()
  proc:close()
  ix = tonumber(choice)
  if ix >= 0 then
    id = ids[ix]
    window = hs.window.get(id)
    window:focus()
    window:focus()
  end
end)
