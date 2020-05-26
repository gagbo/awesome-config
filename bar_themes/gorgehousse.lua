-- * bar_themes/gorgehousse.lua -- Personal Bar theme
-- This uses the global client class : https://awesomewm.org/doc/api/classes/client.html
-- luacheck: globals client
-- * Requires
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local lain = require("lain")

local widget_font = beautiful.font or "KoHo 12"

local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local volumebar_widget = require("awesome-wm-widgets.volumebar-widget.volumebar")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local weather_widget = require("awesome-wm-widgets.weather-widget.weather")
local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
local net_widgets = require("net_widgets")

local config = require("../config")
local secrets = require("secrets") or require("secrets-example")

-- * Widget definitions
-- ** Temp widget
local function getcputempfile()
    local file = io.popen("bash -c 'echo  /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input'")
    local stdout = file:read("*l")
    return stdout
end
local tempfile = getcputempfile()

local temp_widget =
    lain.widget.temp(
    {
        tempfile = tempfile,
        timeout = 10,
        settings = function()
            -- luacheck: globals coretemp_now widget
            widget:set_markup(" CPU : " .. coretemp_now .. "C ")
        end
    }
).widget

-- ** Sysload widget
local mysysload =
    lain.widget.sysload(
    {
        settings = function()
            -- luacheck: globals load_1 load_5 load_15 widget
            widget:set_markup(load_1 .. " " .. load_5 .. " " .. load_15 .. " ")
        end
    }
).widget

-- ** Network widgets
local net_wireless = net_widgets.wireless({interface = "wlp4s0"})

local net_wired =
    net_widgets.indicator(
    {
        interfaces = {"enp0s31f6"},
        timeout = 5
    }
)

-- ** Battery widget
local mybattery =
    batteryarc_widget(
    {
        font = widget_font,
        thickness = 3,
        charging_color = beautiful.widget_green
    }
)

-- ** Textclock widget
local mytextclock = wibox.widget.textclock("%a %d %b %H:%M:%S", 1)

-- ** Weather widget
local myweatherwidget =
    weather_widget(
    {
        api_key = secrets.weather_widget_api_key,
        city = config.weather_widget_city,
        units = config.weather_widget_units
    }
)

-- ** Brightness Widget
local mybrightnesswidget =
    brightness_widget(
    {
        get_brightness_cmd = "xbacklight -get",
        inc_brightness_cmd = "xbacklight -inc 4",
        dec_brightness_cmd = "xbacklight -dec 4",
        path_to_icon = "/usr/share/icons/hicolor/scalable/status/symbolic/display-brightness-symbolic.svg",
        font = widget_font
    }
)

-- ** Volume Bar Widget
local myvolumebarwidget = volumebar_widget()

-- ** CPU Widget
local mycpuwidget = cpu_widget()

-- ** RAM Widget
local myramwidget = ram_widget()

-- * Wibox for each screen and add it
local taglist_buttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(t)
            t:view_only()
        end
    ),
    awful.button(
        {config.modkey},
        1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button(
        {config.modkey},
        3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button(
        {},
        4,
        function(t)
            awful.tag.viewnext(t.screen)
        end
    ),
    awful.button(
        {},
        5,
        function(t)
            awful.tag.viewprev(t.screen)
        end
    )
)

local tasklist_buttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate", "tasklist", {raise = true})
            end
        end
    ),
    awful.button(
        {},
        3,
        function()
            awful.menu.client_list({theme = {width = 250}})
        end
    ),
    awful.button(
        {},
        4,
        function()
            awful.client.focus.byidx(1)
        end
    ),
    awful.button(
        {},
        5,
        function()
            awful.client.focus.byidx(-1)
        end
    )
)

-- * Keyboard map indicator and switcher
-- local mykeyboardlayout = awful.widget.keyboardlayout()

-- * Bar definition
awful.screen.connect_for_each_screen(
    function(s)
        -- ** Create helper widgets
        -- *** Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt()
        -- *** Create an imagebox widget which will contain an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(
            gears.table.join(
                awful.button(
                    {},
                    1,
                    function()
                        awful.layout.inc(1)
                    end
                ),
                awful.button(
                    {},
                    3,
                    function()
                        awful.layout.inc(-1)
                    end
                ),
                awful.button(
                    {},
                    4,
                    function()
                        awful.layout.inc(1)
                    end
                ),
                awful.button(
                    {},
                    5,
                    function()
                        awful.layout.inc(-1)
                    end
                )
            )
        )
        -- *** Create a taglist widget
        s.mytaglist =
            awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            buttons = taglist_buttons
        }

        -- *** Create a tasklist widget
        s.mytasklist =
            awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons
        }

        -- ** Create the wibox
        s.mywibox = awful.wibar({position = "top", screen = s})

        -- ** Add widgets to the wibox
        s.mywibox:setup {
            {
                -- *** Left widgets
                layout = wibox.layout.fixed.horizontal,
                s.mytaglist,
                s.mypromptbox,
                mybrightnesswidget,
                myvolumebarwidget
            },
            s.mytasklist, -- *** Middle widget
            {
                -- *** Right widgets
                layout = wibox.layout.fixed.horizontal,
                myweatherwidget,
                net_wired,
                net_wireless,
                temp_widget,
                mysysload,
                mycpuwidget,
                myramwidget,
                -- mykeyboardlayout,
                mybattery,
                mytextclock,
                wibox.widget.systray(),
                s.mylayoutbox
            },
            layout = wibox.layout.align.horizontal
        }
    end
)
-- }}}
