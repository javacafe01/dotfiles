return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
        html = {},
        cssls = {},
        tsserver = {},
        ccls = { offset_encoding = "utf-8" },
        nil_ls = {},
      },
    },
  },
}
