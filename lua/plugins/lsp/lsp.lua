return {
	{
		-- TODO: Automatically install servers based of filetype?
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				registries = { "github:mason-org/mason-registry", "github:crashdummyy/mason-registry" }
			})
		end
	},
}
