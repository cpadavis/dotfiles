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

logger = hs.logger.new('main', 'debug')

hs.loadSpoon("SpoonInstall")
Install=spoon.SpoonInstall

-- `window_state_rects` are `{x,y,w,l}` `hs.geometry.unitrect` tables defining those states
_window_state_name_to_rect = {
    -- two decimal places required for `window_state_rect_strings` to match
    left_half         = {0.00,0.00,0.50,1.00},
    middle_half       = {0.25,0.00,0.50,1.00},
    right_half        = {0.50,0.00,0.50,1.00},
    left_third        = {0.00,0.00,0.33,1.00},
    middle_third      = {0.335,0.00,0.33,1.00},
    right_third       = {0.66,0.00,0.34,1.00},
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
function cycle_list(list, current_name, delta)
    -- given list, cycle to next entry
    local index={}
    local count = 0
    for k,v in ipairs(list) do
        count = count + 1
        logger.i(v:name(), k, count)
        index[v:name()] = k
    end
    logger.i("List:")
    logger.i(dump(list))
    logger.i("Index:")
    logger.i(dump(index))
    logger.i("Count:")
    logger.i(count)
    logger.i("Entry is "..current_name)
    local c = index[current_name]
    logger.i("c, count")
    logger.i(c, count)
    if c+delta > count then
        c = 1
    else
        c = c+delta
    end
    logger.i("next c, count")
    logger.i(c, count)
    logger.i("Selecting list entry:")
    logger.i(c)
    new_entry = list[c]
    return new_entry
end
function cycle_audio_input()
    logger.i("***** Doing Audio Input Change *****")
    logger.i(dump(hs.audiodevice.current(true)))  -- true for input
    logger.i(dump(hs.audiodevice.allInputDevices()))
    all_devices = hs.audiodevice.allInputDevices()
    local input_name = hs.audiodevice.defaultInputDevice():name()
    local device_name = input_name
    logger.i("Current Audio Input is "..input_name)

    local tries = 1
    while((input_name == device_name) and (tries < 5))
    do
        if tries > 1 then
            logger.i("***Trying attempt ..".. tries)
        end
        new_device = cycle_list(all_devices, device_name, tries)
        logger.i("new device "..new_device:name())
        new_device:setDefaultInputDevice()
        device_name = hs.audiodevice.defaultInputDevice():name()
        tries = tries + 1
    end

    logger.i("Audio Input is now using "..device_name)
    hs.notify.new({title="Hammerspoon", informativeText="Audio Input now is "..input_name}):send()
    logger.i("***** Ending Audio Input Change *****")
end
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "[", function()
    cycle_audio_input()
end)
function cycle_audio_output()
    logger.i("***** Doing Audio Output Change *****")
    logger.i(dump(hs.audiodevice.current(true)))  -- true for output
    logger.i(dump(hs.audiodevice.allOutputDevices()))
    all_devices = hs.audiodevice.allOutputDevices()

    local output_name = hs.audiodevice.defaultOutputDevice():name()
    local device_name = output_name
    logger.i("Current Audio Output is "..output_name)

    local tries = 1
    while((output_name == device_name) and (tries < 5))
    do
        if tries > 1 then
            logger.i("***Trying attempt ..".. tries)
        end
        new_device = cycle_list(all_devices, device_name, tries)
        logger.i("new device "..new_device:name())
        new_device:setDefaultOutputDevice()
        device_name = hs.audiodevice.defaultOutputDevice():name()
        tries = tries + 1
    end

    logger.i("Audio Output is now using "..device_name)
    hs.notify.new({title="Hammerspoon", informativeText="Audio Output now is "..output_name}):send()
    logger.i("***** Ending Audio Output Change *****")
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

Install:andUse("ToggleScreenRotation",
               {
                 hotkeys = { first = {{"ctrl", "alt", "cmd"}, "b"} }
               }
)
