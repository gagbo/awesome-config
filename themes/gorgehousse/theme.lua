-------------------------------
-- Gorgehousse awesome theme --
-------------------------------

local awful = require("awful")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()
local dpi = xresources.apply_dpi

local themes_path = "~/.config/awesome/themes/"

local theme = {}

theme.screen_width = awful.screen.focused().geometry.width

-- Get colors from .Xresources
theme.xbackground = xrdb.background or "#0C0C14"
theme.xforeground = xrdb.foreground or "#CEDBE5"
theme.xcolor0 = xrdb.color0 or "#0D0D16"
theme.xcolor1 = xrdb.color1 or "#B74A40"
theme.xcolor2 = xrdb.color2 or "#99B740"
theme.xcolor3 = xrdb.color3 or "#B7892D"
theme.xcolor4 = xrdb.color4 or "#2461B7"
theme.xcolor5 = xrdb.color5 or "#672DB7"
theme.xcolor6 = xrdb.color6 or "#2DACB7"
theme.xcolor7 = xrdb.color7 or "#899299"
theme.xcolor8 = xrdb.color8 or "#2D2D4C"
theme.xcolor9 = xrdb.color9 or "#E55C50"
theme.xcolor10 = xrdb.color10 or "#C0E550"
theme.xcolor11 = xrdb.color11 or "#E5AC39"
theme.xcolor12 = xrdb.color12 or "#2D7AE5"
theme.xcolor13 = xrdb.color13 or "#8139E5"
theme.xcolor14 = xrdb.color14 or "#39D7E5"
theme.xcolor15 = xrdb.color15 or "#E5F4FF"

theme.widget_main_color = theme.xcolor6 or "#74aeab"
theme.widget_red = theme.xcolor1
theme.widget_yellow = theme.xcolor3
theme.widget_green = theme.xcolor2
theme.widget_black = theme.xbackground
theme.widget_transparent = "#00000000"

theme.dark_gradient = {
    -- From darkest to dark
    "#0C0C14",
    "#0D0D16",
    "#1E1E33",
    "#2D2D4C"
}

theme.font = "KoHo 12"

theme.bg_dark = theme.dark_gradient[1]
theme.bg_normal = theme.dark_gradient[2]
theme.bg_focus = theme.dark_gradient[4]
theme.bg_urgent = theme.xcolor1
theme.bg_minimize = theme.xcolor8
theme.bg_systray = theme.dark_gradient[1]

theme.fg_normal = theme.xforeground
theme.fg_focus = theme.xforeground
theme.fg_urgent = theme.xcolor3
theme.fg_minimize = theme.xcolor8

theme.useless_gap = dpi(2)
theme.screen_margin = dpi(2)

theme.border_width = dpi(2)
theme.border_radius = dpi(2)
theme.border_normal = theme.xcolor8
theme.border_focus = theme.xcolor3
theme.border_marked = theme.xcolor1

theme.wibar_height = dpi(40)
--theme.wibar_opacity = 0.7
theme.wibar_border_color = theme.dark_gradient[1]
theme.wibar_border_width = 0
theme.wibar_border_radius = theme.border_radius
theme.wibar_width = theme.screen_width - theme.screen_margin * 4 - theme.wibar_border_width * 2

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
theme.taglist_bg_focus = theme.xcolor4
theme.taglist_fg_focus = theme.xforeground
theme.taglist_bg_urgent = theme.xcolor9
theme.taglist_fg_urgent = theme.xforeground
theme.taglist_fg_empty = theme.dark_gradient[4]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
theme.titlebar_bg_normal = theme.dark_gradient[1]
theme.titlebar_fg_normal = theme.dark_gradient[4]
theme.titlebar_bg_focus = theme.dark_gradient[3]
theme.titlebar_fg_focus = theme.xforeground
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal

-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
theme.prompt_font = "KoHo 14"
-- hotkeys_[bg|fg|border_width|border_color
--          shape|opacity|modifiers_fg|label_bg
--          label_fg|group_margin|font|description_font]
-- Example:

theme.wallpaper = "~/Pictures/wallpapers/Uru-IBO.png"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

theme = theme_assets.recolor_layout(theme, theme.fg_normal)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "gorgehousse/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
local titlebar_folder = themes_path .. "gorgehousse/titlebar"
theme.titlebar_close_button_normal = titlebar_folder .. "/close_normal.png"
theme.titlebar_close_button_focus = titlebar_folder .. "/close_focus.png"

theme.titlebar_minimize_button_normal = titlebar_folder .. "/minimize_normal.png"
theme.titlebar_minimize_button_focus = titlebar_folder .. "/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = titlebar_folder .. "/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = titlebar_folder .. "/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = titlebar_folder .. "/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = titlebar_folder .. "/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = titlebar_folder .. "/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = titlebar_folder .. "/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = titlebar_folder .. "/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = titlebar_folder .. "/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = titlebar_folder .. "/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = titlebar_folder .. "/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = titlebar_folder .. "/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = titlebar_folder .. "/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = titlebar_folder .. "/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = titlebar_folder .. "/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = titlebar_folder .. "/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = titlebar_folder .. "/maximized_focus_active.png"

-- You can use your own layout icons like this:
local layout_folder = themes_path .. "gorgehousse/layouts"
theme.layout_fairh = layout_folder .. "/fairhw.png"
theme.layout_fairv = layout_folder .. "/fairvw.png"
theme.layout_floating = layout_folder .. "/floatingw.png"
theme.layout_magnifier = layout_folder .. "/magnifierw.png"
theme.layout_max = layout_folder .. "/maxw.png"
theme.layout_fullscreen = layout_folder .. "/fullscreenw.png"
theme.layout_tilebottom = layout_folder .. "/tilebottomw.png"
theme.layout_tileleft = layout_folder .. "/tileleftw.png"
theme.layout_tile = layout_folder .. "/tilew.png"
theme.layout_tiletop = layout_folder .. "/tiletopw.png"
theme.layout_spiral = layout_folder .. "/spiralw.png"
theme.layout_dwindle = layout_folder .. "/dwindlew.png"
theme.layout_cornernw = layout_folder .. "/cornernww.png"
theme.layout_cornerne = layout_folder .. "/cornernew.png"
theme.layout_cornersw = layout_folder .. "/cornersww.png"
theme.layout_cornerse = layout_folder .. "/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
