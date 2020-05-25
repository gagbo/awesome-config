local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")
local config = {}

-- ** Modkey
config.modkey = "Mod4"

-- ** User programs
-- This is used later as the default terminal and editor to run.
config.terminal = "alacritty"
config.floating_terminal = config.terminal .. " -c fst "
config.editor = os.getenv("EDITOR") or "vim"
config.editor_cmd = config.terminal .. " -e " .. config.editor
config.screen_lock = "i3lock-laptop.sh"
config.graphical_emacs = "emacsclient -n -c -a ''"
config.launcher = "dmenu_run -h 35"
config.info = "htop"
config.info_cmd = config.floating_terminal .. " -e " .. config.info
config.music_player = "ncmpcpp"
config.music_player_cmd = config.floating_terminal .. " -e " .. config.music_player
config.browser = "firefox"

-- ** Menus
config.myawesomemenu = {
    {"hotkeys", function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end},
    {"manual", config.terminal .. " -e man awesome"},
    {"edit config", config.editor_cmd .. " " .. awesome.conffile},
    {"restart", awesome.restart},
    {"quit", function()
            awesome.quit()
        end}
}

config.mymainmenu =
    awful.menu(
    {
        items = {
            {"awesome", config.myawesomemenu, beautiful.awesome_icon},
            {"open terminal", config.terminal},
            {"Emacs", config.graphical_emacs}
        }
    }
)

config.mylauncher =
    awful.widget.launcher(
    {
        image = beautiful.awesome_icon,
        menu = config.mymainmenu
    }
)


-- ** Menubar configuration
config.app_folders = {"/usr/share/applications/", "/usr/local/share/applications/", "~/.local/share/applications/"}

return config
