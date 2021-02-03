local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local apps = require('configuration.apps')
local dpi = require('beautiful').xresources.apply_dpi

local left_panel = function(screen)
  local action_bar_width = dpi(0)
  local panel_content_width = dpi(400)

  local panel =
    wibox {
    screen = screen,
    width = action_bar_width,
    height = screen.geometry.height,
    x = screen.geometry.x,
    y = screen.geometry.y,
    ontop = false,
    bg = beautiful.background.hue_800,
    fg = beautiful.fg_normal
  }

  panel.opened = false

  panel:struts(
    {
      left = action_bar_width
    }
  )

  local backdrop =
    wibox {
    ontop = false,
    screen = screen,
    bg = '#00000000',
    type = 'dock',
    x = screen.geometry.x,
    y = screen.geometry.y,
    width = screen.geometry.width,
    height = screen.geometry.height
  }
  backdrop:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:toggle()
        end
      )
    )
  )

  panel:setup {
    layout = wibox.layout.align.horizontal,
    nil,
    {
      id = 'panel_content',
      bg = beautiful.background.hue_900,
      widget = wibox.container.background,
      visible = false,
      forced_width = panel_content_width,
      {
        require('layout.left-panel.dashboard')(screen, panel),
        layout = wibox.layout.stack
      }
    },
    require('layout.left-panel.action-bar')(screen, panel, action_bar_width)
  }
  --return panel
end

return left_panel
