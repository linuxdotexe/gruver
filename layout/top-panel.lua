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
local textclock = wibox.widget.textclock('<span font="BlexMono Nerd Font Mono 10">%I:%M %p</span>')
textclock.forced_height = 10

local clock_widget = wibox.container.margin(textclock, dpi(9), dpi(9), dpi(9), dpi(8))
-- Add a calendar (credits to kylekewley for the original code)
local month_calendar = awful.widget.calendar_popup.month({
  start_sunday = false,
  week_numbers = true
})
month_calendar:attach(textclock)
-- ROBBED from https://git.sr.ht/~cnx/dotfiles/tree/d96622187e7886c889f04f553e449c4088ea76c0/item/awesome/.config/awesome/rc.lua
local myplayer_text = wibox.widget.textbox()
awful.spawn.with_line_callback(
  "playerctl --follow metadata --format ' {{artist}} <{{status}}> {{title}}'",
  {stdout = function (line)
     myplayer_text:set_text(line:gsub('<Playing>', '|'):gsub('<.+>', '|'))
   end}
)
 local menu_icon =
    wibox.widget {
    icon = icons.menu,
    size = dpi(18),
    widget = mat_icon
  }
  local home_button = 
  wibox.widget{
      wibox.widget{
          menu_icon,
          widget = clickable_container
      },
      bg = "#282828",
      widget = wibox.container.background
  }
  home_button:buttons(
          gears.table.join(
                  awful.button(
                      {},
                      1,
                      nil,
                      function()
                          awful.spawn.with_shell('awesome restart --replace')
                      end
                      )
              )
      )
local seper_tex = wibox.widget{
    text = '|',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}
local systray = wibox.widget.systray()
systray:set_horizontal(true)
systray:set_base_size(24)
systray.forced_height = 24
beautiful.systray_icon_spacing = dpi(7)
local add_button = mat_icon_button(mat_icon(icons.plus, dpi(18)))
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
    offsetx = dpi(25)
  end
  local panel =
    wibox(
    {
      ontop = true,
      screen = s,
      height = dpi(25),
      width = s.geometry.width,
      stretch = false,
      bg = beautiful.background.hue_800,
      fg = beautiful.fg_normal,
      struts = {
        top = dpi(25)
      }
    }
  )

  panel:struts(
    {
      top = dpi(25)
    }
  )

 panel:setup {
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      -- Create a taglist widget
      home_button,
      seper_tex,
      --TagList(s),
      TaskList(s),
      --add_button
    },
    nil,
    {
      layout = wibox.layout.fixed.horizontal,
      myplayer_text,
      todo_widget(),
      wibox.container.margin(systray, dpi(3), dpi(3), dpi(6), dpi(3)),
      textclock,
      require('widget.battery'),
    }
  }

  return panel
end

return TopPanel 
