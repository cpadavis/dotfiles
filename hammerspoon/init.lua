-- hs.loadSpoon("WindowHalfsAndThirds")

-- spoon.WindowHalfsAndThirds:bindHotkeys(
--  {
--     left_half   = { {"ctrl", "alt", "cmd"}, "Left" },
--     right_half  = { {"ctrl", "alt", "cmd"}, "Right" },
--     third_left  = { {"ctrl", "alt", "cmd"}, "Up" },
--     third_right = { {"ctrl", "alt", "cmd"}, "Down" },
--     -- top_half    = { {"ctrl", "alt", "cmd"}, "Up" },
--     -- bottom_half = { {"ctrl", "alt", "cmd"}, "Down" },
--     -- third_up    = { {"ctrl", "alt", "cmd"}, "Up" },
--     -- third_down  = { {"ctrl", "alt", "cmd"}, "Down" },
--     -- top_left    = { {"ctrl",        "cmd"}, "1" },
--     -- top_right   = { {"ctrl",        "cmd"}, "2" },
--     -- bottom_left = { {"ctrl",        "cmd"}, "3" },
--     -- bottom_right= { {"ctrl",        "cmd"}, "4" },
--     max_toggle  = { {"ctrl", "alt", "cmd"}, "f" },
--     max         = { {"ctrl", "alt", "cmd", "shift"}, "Up" },
--     undo        = { {"ctrl", "alt", "cmd"}, "z" },
--     center      = { {"ctrl", "alt", "cmd"}, "c" },
--     larger      = { {"ctrl", "alt", "cmd", "shift"}, "Right" },
--     smaller     = { {"ctrl", "alt", "cmd", "shift"}, "Left" },
--  }
-- )

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
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "l", function()
    adjust_current_window("max")
end)
-- twothird left
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "y", function()
    adjust_current_window("left_twothird")
end)
-- twothird center
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "u", function()
    adjust_current_window("middle_twothird")
end)
-- twothird right
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "i", function()
    adjust_current_window("right_twothird")
end)
-- half left
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "h", function()
    adjust_current_window("left_half")
end)
-- half center
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "j", function()
    adjust_current_window("middle_half")
end)
-- half right
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "k", function()
    adjust_current_window("right_half")
end)
-- third left
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "b", function()
    adjust_current_window("left_third")
end)
-- third center
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "n", function()
    adjust_current_window("middle_third")
end)
-- third right
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "m", function()
    adjust_current_window("right_third")
end)


-- Twothird left
-- Twothird center
-- Twothird right

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
