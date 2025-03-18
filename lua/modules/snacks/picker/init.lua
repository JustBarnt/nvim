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
  },
  custom_select = {
    -- A borderless layout for the select picker.
    -- Initial height of the inner root box is item count + 2
    -- https://github.com/folke/snacks.nvim/blob/70afc4225ac8ae3e6c8af88d205b03991a173af3/lua/snacks/picker/select.lua#L37
    -- FIX: Workaround to simulate a input box with solid border:
    --      - in root box: (input + box) + list)
    --      +----------+
    --      |          | <- root box border top
    --      +--------++|
    --      | >      ||| <- input box no top or bottom border
    --      +--------+||
    --      |         || <- box border bottom
    --      +---------+|
    --      | 1.      || <- list box no border
    --      | 2.      ||
    --      +---------++
    layout = {
      backdrop = false,
      width = 0.5,
      min_width = 80,
      height = 0.4,
      min_height = 1,
      border = 'top',
      title = '{title}',
      box = 'vertical', -- root box
      {
        box = 'vertical',
        border = 'bottom', -- inner box top border = 1 line
        height = 1,
        { win = 'input', title = '{title}', height = 1, border = 'hpad' }, -- input = 1 line
      },
      { win = 'list', border = 'none' }, -- list = #items lines
    },
  }
}

return M
