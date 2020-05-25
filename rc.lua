-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- * Initialize
-- Themes define colours, icons, font and wallpapers.
-- awful.spawn.with_shell("xrdb -merge ~/.Xresources")
beautiful.init(awful.util.getdir("config") .. "themes/gorgehousse/theme.lua")

local keys = require('keys')

require('titlebars')
require('bar_themes.gorgehousse')

-- * {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
                               -- Make sure we don't go into an endless error loop
                               if in_error then return end
                               in_error = true

                               naughty.notify({ preset = naughty.config.presets.critical,
                                                title = "Oops, an error happened!",
                                                text = tostring(err) })
                               in_error = false
    end)
end
-- }}}

-- * {{{ Variable definitions
-- All those values are globals because they're also used in
-- keys.lua for the bindings

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
floating_terminal = terminal .. " -c fst "
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
screen_lock = "i3lock-laptop.sh"
graphical_emacs = "emacsclient -n -c -a ''"
launcher = "dmenu_run -h 35"
info = "htop"
info_cmd = floating_terminal .. " -e " .. info
music_player = "ncmpcpp"
music_player_cmd = floating_terminal .. " -e " .. music_player
browser = "firefox"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- * {{{ Menu
-- ** Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                              { "open terminal", terminal },
                              { "Emacs", graphical_emacs }
}
                       })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- ** Menubar configuration
app_folders = {"/usr/share/applications/", "/usr/local/share/applications/", "~/.local/share/applications/"}
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- * Wallpaper
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
        -- Wallpaper
        set_wallpaper(s)

        local names = { "main", "www", "term", "read", "office", "irc", "7", "8", "9" }
        local l = awful.layout.suit  -- Just to save some typing: use an alias.
        local layouts = { l.floating, l.tile, l.tile, l.max, l.max,
            l.floating, l.tile.left, l.floating, l.floating }

        -- Each screen has its own tag table.
        awful.tag(names, s, layouts)

end)
-- }}}

-- * {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- ** All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = keys.clientkeys,
                     buttons = keys.clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
      }
    },

    -- ** Floating clients.
    { rule_any = {
          instance = {
              "DTA",  -- Firefox addon DownThemAll.
              "copyq",  -- Includes session name in class.
              "pinentry",
          },
          class = {
              "Arandr",
              "Blueman-manager",
              "Gpick",
              "Kruler",
              "MessageWin",  -- kalarm.
              "Sxiv",
              "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
              "Wpa_gui",
              "veromix",
              "xtightvncviewer",
              "fst"},

          -- Note that the name property shown in xprop might be set slightly after creation of the client
          -- and the name shown there might not match defined rules here.
          name = {
              "Event Tester",  -- xev.
          },
          role = {
              "AlarmWindow",  -- Thunderbird's calendar.
              "ConfigManager",  -- Thunderbird's about:config.
              "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
          }
    }, properties = { floating = true }},

    -- ** Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
                 }, properties = { titlebars_enabled = true }
    },

    -- ** EXAMPLE Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- * {{{ Signals
-- ** Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function (c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup
            and not c.size_hints.user_position
        and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- ** Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
                          c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- * {{{ Autostart
awful.spawn.with_shell("~/.config/awesome/autostart.sh")
-- }}}
