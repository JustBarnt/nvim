-- Visualizes C/C++ struct and class memory layouts - field offsets, padding, alignment.
-- In a floating window.
return {
  "J-Cowsert/classlayout.nvim",
  enabled = not vim.g.vsneo,
  ft = { "c", "cpp" },
  opts = {},
}
