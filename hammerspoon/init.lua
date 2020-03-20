function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

logger = hs.logger.new('main')

-- `window_state_rects` are `{x,y,w,l}` `hs.geometry.unitrect` tables defining those states
_window_state_name_to_rect = {
    -- two decimal places required for `window_state_rect_strings` to match
    left_half         = {0.00,0.00,0.50,1.00},
    middle_half       = {0.25,0.00,0.50,1.00},
    right_half        = {0.50,0.00,0.50,1.00},
    left_third        = {0.00,0.00,0.33,1.00},
    middle_third      = {0.335,0.00,0.33,1.00},
    right_third       = {0.67,0.00,0.33,1.00},
    left_twothird     = {0.00,0.00,0.66,1.00},
    middle_twothird   = {0.175,0.00,0.66,1.00},
    right_twothird    = {0.34,0.00,0.66,1.00},
    middle_threequart = {0.125,0.00,0.75,1.00},
    max               = {0.00,0.00,1.00,1.00},
}


function adjust_current_window(window_state_name)
    -- logger.e("Window state name".. window_state_name)
    local win = hs.window.focusedWindow()
    -- logger.e("Doing window".. win:id())
    if not win then return end
    local move_to_rect = _window_state_name_to_rect[window_state_name]
    win:move(move_to_rect)
    -- logger.e("Done!")
end

-- max
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "h", function()
    adjust_current_window("max")
end)
-- twothird left
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "n", function()
    adjust_current_window("left_twothird")
end)
-- twothird right
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "m", function()
    adjust_current_window("right_twothird")
end)
-- half left
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "u", function()
    adjust_current_window("left_half")
end)
-- middle three quarters
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "i", function()
    adjust_current_window("middle_threequart")
end)
-- half right
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "o", function()
    adjust_current_window("right_half")
end)
-- third left
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "j", function()
    adjust_current_window("left_third")
end)
-- third center
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "k", function()
    adjust_current_window("middle_third")
end)
-- third right
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "l", function()
    adjust_current_window("right_third")
end)

-- Toggle sound devices
function cycle_audio_input()
    logger.i(dump(hs.audiodevice.current(true)))  -- true for input
    logger.i(dump(hs.audiodevice.allInputDevices()))
    all_devices = hs.audiodevice.allInputDevices()
    local index={}
    local count = 0
    for k,v in pairs(all_devices) do
        index[v:name()] = k
        count = count + 1
    end
    logger.i(dump(index))
    local input_name = hs.audiodevice.defaultInputDevice():name()
    logger.i("Audio Input is "..input_name)
    if index[input_name] == count then
        new_device = all_devices[1]
    else
        new_device = all_devices[index[input_name] + 1]
    end

    new_device:setDefaultInputDevice()
    local input_name = hs.audiodevice.defaultInputDevice():name()
    logger.i("Audio Input is now using "..input_name)
    hs.notify.new({title="Hammerspoon", informativeText="Audio Input now is "..input_name}):send()
end
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "[", function()
    cycle_audio_input()
end)
function cycle_audio_output()
    logger.i(dump(hs.audiodevice.current(true)))  -- true for output
    logger.i(dump(hs.audiodevice.allOutputDevices()))
    all_devices = hs.audiodevice.allOutputDevices()
    local index={}
    local count = 0
    for k,v in pairs(all_devices) do
        index[v:name()] = k
        count = count + 1
    end
    logger.i(dump(index))
    local output_name = hs.audiodevice.defaultOutputDevice():name()
    logger.i("Audio Output is "..output_name)
    if index[output_name] == count then
        new_device = all_devices[1]
    else
        new_device = all_devices[index[output_name] + 1]
    end

    new_device:setDefaultOutputDevice()
    local output_name = hs.audiodevice.defaultOutputDevice():name()
    logger.i("Audio Output is now using "..output_name)
    hs.notify.new({title="Hammerspoon", informativeText="Audio Output now is "..output_name}):send()
end
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "]", function()
    cycle_audio_output()
end)

-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
--   hs.alert.show("Hello World!")

--   hs.notify.new({title="Hammerspoon 2", informativeText="Hello World 2"}):send()
-- end)

-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
--   local win = hs.window.focusedWindow()
--   local f = win:frame()

--   f.x = f.x - 10
--   win:setFrame(f)
-- end)
