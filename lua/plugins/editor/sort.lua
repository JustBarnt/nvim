return {
  "sQVe/sort.nvim",
  opts = {
    -- List of delimiters, in descending order of priority, to automatically
    -- sort on.
    delimiters = {
      ",",
      "|",
      ";",
      ":",
      "s", -- Space.
      "t", -- Tab.
    },

    -- Enable natural sorting for motion operations by default.
    -- When true, sorts "item1,item10,item2" as "item1,item2,item10".
    -- When false, uses lexicographic sorting: "item1,item10,item2".
    natural_sort = true,

    -- Whitespace handling configuration.
    whitespace = {
      -- When whitespace before items is >= this many characters, it's considered
      -- alignment and is preserved. Otherwise, whitespace is normalized to be
      -- consistent when sorting changes item order.
      alignment_threshold = 3,
    },

    -- Default keymappings (set to false to disable).
    mappings = {
      operator = "go",
      textobject = {
        inner = "io",
        around = "ao",
      },
      motion = {
        next_delimiter = "]o",
        prev_delimiter = "[o",
      },
    },
  },
}
