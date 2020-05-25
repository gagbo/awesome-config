-- This uses the global client class : https://awesomewm.org/doc/api/classes/client.html
-- luacheck: globals client

-- * titlebars.lua -- Title Bars configuration
-- * Requires
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local titlebars = {}

-- * Mouse buttons
titlebars.buttons =
    gears.table.join(
    -- ** Left button
    -- move
    -- (Double tap - Toggle maximize) -- A little BUGGY
    awful.button(
        {},
        1,
        function()
            local c = _G.mouse.object_under_pointer()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)

            -- local function single_tap()
            --   awful.mouse.client.move(c)
            -- end
            -- local function double_tap()
            --   gears.timer.delayed_call(function()
            --       c.maximized = not c.maximized
            --   end)
            -- end
            -- helpers.single_double_tap(single_tap, double_tap)
            -- helpers.single_double_tap(nil, double_tap)
        end
    ),
    -- ** Middle button - close
    awful.button(
        {},
        2,
        function()
            local window_to_kill = _G.mouse.object_under_pointer()
            window_to_kill:kill()
        end
    ),
    -- ** Right button - resize
    awful.button(
        {},
        3,
        function()
            local c = _G.mouse.object_under_pointer()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
            -- awful.mouse.resize(c, nil, {jump_to_corner=true})
        end
    ),
    -- ** Side button up - toggle floating
    awful.button(
        {},
        9,
        function()
            local c = _G.mouse.object_under_pointer()
            client.focus = c
            c:raise()
            --awful.placement.centered(c,{honor_workarea=true})
            c.floating = not c.floating
        end
    ),
    -- ** Side button down - toggle ontop
    awful.button(
        {},
        8,
        function()
            local c = _G.mouse.object_under_pointer()
            client.focus = c
            c:raise()
            c.ontop = not c.ontop
        end
    )
)

-- * Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
    "request::titlebars",
    function(c)
        -- ** buttons for the titlebar
        local buttons = titlebars.buttons

        awful.titlebar(c):setup {
            {
                -- ** Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout = wibox.layout.fixed.horizontal
            },
            {
                -- ** Middle
                {
                    -- *** Title
                    align = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout = wibox.layout.flex.horizontal
            },
            {
                -- ** Right
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    end
)

return titlebars
