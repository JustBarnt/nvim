local M = {}

M.layout = {
  custom_telescope = {
    -- A borderless layout with a vertical split with a preview on the right.
    -- - Based on the default `telescope` layout.
    -- - Replaces `rounded` with `solid` borders.
    reverse = true,
    layout = {
      box = 'horizontal',
      backdrop = false,
      width = 0.8,
      height = 0.9,
      border = 'none',
      {
        box = 'vertical',
        { win = 'list', title = ' Results ', title_pos = 'center', border = 'solid' },
        { win = 'input', height = 1, border = 'solid', title = '{title} {live} {flags}', title_pos = 'center' },
      },
      {
        win = 'preview',
        title = '{preview:Preview}',
        width = 0.45,
        border = 'solid',
        title_pos = 'center',
      },
    },
  },
  custom_telescope_vertical = {
    -- A borderless layout with a vertical split with a preview on the top.
    -- - Based on the `my_telescope` layout.
    reverse = true,
    layout = {
      box = 'vertical',
      backdrop = false,
      width = 0.8,
      height = 0.9,
      border = 'none',
      {
        win = 'preview',
        title = '{preview:Preview}',
        height = 0.4,
        border = 'solid',
        title_pos = 'center',
      },
      { win = 'list', title = ' Results ', title_pos = 'center', border = 'solid' },
      { win = 'input', height = 1, border = 'solid', title = '{title} {live} {flags}', title_pos = 'center' },
    },
  },
  custom_telescope_vertical_no_preview = {
    -- A borderless layout with a vertical split without a preview on.
    -- - Based on the `my_telescope_vertical` layout.
    reverse = true,
    layout = {
      box = 'vertical',
      backdrop = false,
      width = 0.8,
      height = 0.9,
      border = 'none',
      { win = 'list', title = ' Results ', title_pos = 'center', border = 'solid' },
      { win = 'input', height = 1, border = 'solid', title = '{title} {live} {flags}', title_pos = 'center' },
    },
  }
}

return M
