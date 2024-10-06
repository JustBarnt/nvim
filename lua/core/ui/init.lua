return {
    "nvchad/volt",
    "nvim-lua/plenary.nvim",
    {
        "nvchad/ui",
        config = function()
            require("nvchad")
        end
    },
    {
        "nvchad/base46",
        build = function()
            require("base46").load_all_highlights()
        end
    },
}
