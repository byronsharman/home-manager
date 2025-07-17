lsp_opts = {
  biome = {
    cmd = {"npx", "biome", "lsp-proxy"},
  },
  clangd = {},
  gopls = {},
  nil_ls = {},
  pyright = {},
  ruff = {},
  svelte = {},
  tailwindcss = {},
  tinymist = {},
  volar = {},

  harper_ls = {
    settings = {
      ["harper-ls"] = {
        linters = {
          LongSentences = false,
          Matcher = false,
          SentenceCapitalization = false,
          Spaces = false,
          SpellCheck = false,
          SpelledNumbers = false,
          ToDoHyphen = false,
        },
      },
    },
  },
}

lspconfig = require('lspconfig')

capabilities = require('blink.cmp').get_lsp_capabilities()
for server, config in pairs(lsp_opts) do
  lspconfig[server].setup(
    vim.tbl_extend('keep', config, { capabilities = capabilities })
  )
end
