local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local TaskList = require('widget.task-list')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')
local mat_icon_button = require('widget.material.icon-button')
local mat_icon = require('widget.material.icon')
local TagList = require('widget.tag-list')
local dpi = require('beautiful').xresources.apply_dpi
local spotify_widget = require('widgetsFromGitHub.awesome-wm-widgets.spotify-widget.spotify')
local todo_widget = require('widgetsFromGitHub.awesome-wm-widgets.todo-widget.todo')
local icons = require('theme.icons')

-- Clock / Calendar 12AM/PM fornat
local textclock = wibox.widget.textclock('<span font="BlexMono Nerd Font Mono 10">%I:%M %p - %d.%m.%Y</span>')
textclock.forced_height = 10

local clock_widget = wibox.container.margin(textclock, dpi(9), dpi(9), dpi(9), dpi(8))
-- Add a calendar (credits to kylekewley for the original code)
local month_calendar = awful.widget.calendar_popup.month({
  start_sunday = false,
  week_numbers = true
})
month_calendar:attach(textclock)

local systray = wibox.widget.systray()
systray:set_horizontal(true)
systray:set_base_size(24)
local add_button = mat_icon_button(mat_icon(icons.plus, dpi(24)))
add_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn(
          awful.screen.focused().selected_tag.defaultApp,
          {
            tag = _G.mouse.screen.selected_tag,
            placement = awful.placement.bottom_right
          }
        )
      end
    )
  )
)

-- Create an imagebox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
local LayoutBox = function(s)
  local layoutBox = clickable_container(awful.widget.layoutbox(s))
  layoutBox:buttons(
    awful.util.table.join(
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
  return layoutBox
end

local TopPanel = function(s, offset)
  local offsetx = 0
  if offset == true then
    offsetx = dpi(30)
  end
  local panel =
    wibox(
    {
      ontop = true,
      screen = s,
      height = dpi(30),
      width = s.geometry.width,
      --x = s.geometry.x + offsetx,
      --y = s.geometry.y,
      stretch = false,
      bg = beautiful.background.hue_800,
      fg = beautiful.fg_normal,
      struts = {
        top = dpi(30)
      }
    }
  )

  panel:struts(
    {
      top = dpi(30)
    }
  )

  panel:setup {
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      -- Create a taglist widget
      TagList(s),
      TaskList(s),
      add_button
    },
    nil,
    {
      layout = wibox.layout.fixed.horizontal,
      spotify_widget({
              font = 'BlexMono Nerd Font Mono 9',
              show_tooltip = false,
              dim_when_paused = false,
              play_icon = '/usr/share/icons/gruvbox-dark-icons-gtk/24x24/apps/spotify.svg',
              pause_icon = '/usr/share/icons/gruvbox-dark-icons-gtk/24x24/panel/spotify-indicator.svg'
          }),
      todo_widget(),
      wibox.container.margin(systray, dpi(10), dpi(10)),
      require('widget.battery'),
      textclock,
      --LayoutBox(s),
    }
  }

  return panel
end

return TopPanel
