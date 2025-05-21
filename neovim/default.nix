{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraLuaConfig = builtins.readFile ./init.lua;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      {
        type = "lua";
        plugin = plenary-nvim;
      }
      {
        type = "lua";
        plugin = lush-nvim;
      }
      {
        type = "lua";
        plugin = bluloco-nvim;
        config = ''
          require('bluloco').setup {
            transparent = true,
          }
          vim.cmd("colorscheme bluloco")
        '';
      }
      {
        type = "lua";
        plugin = nvim-lspconfig;
        # TODO: The nvim-lspconfig docs indicate that the configuration
        # templates can be made to work with the new vim.lsp.enable /
        # vim.lsp.config API. However, everything else I researched suggested
        # that one either drops nvim-lspconfig to use the new API, or if one
        # does not want to maintain configurations for all their LSPs, they
        # must continue to use the "deprecated" lspconfig.foo.setup{} syntax.
        config = ''
          require('lspconfig')
          require('lspconfig').biome.setup{
            cmd = {"npx", "biome", "lsp-proxy"},
          }
          require('lspconfig').gopls.setup{}
          require('lspconfig').jdtls.setup{}
          require('lspconfig').tinymist.setup{}
          require('lspconfig').svelte.setup{}
          require('lspconfig').tailwindcss.setup{}
          require('lspconfig').volar.setup{}
          require('lspconfig').harper_ls.setup {
            settings = {
              ["harper-ls"] = {
                linters = {
                  AnA = true,
                  CorrectNumberSuffix = true,
                  LongSentences = false,
                  Matcher = false,
                  RepeatedWords = true,
                  SentenceCapitalization = false,
                  Spaces = false,
                  SpellCheck = false,
                  SpelledNumbers = false,
                  ToDoHyphen = false,
                  UnclosedQuotes = true,
                  WrongQuotes = false
                }
              }
            },
          }
          require('lspconfig').ruff.setup{}
        '';
      }
      {
        type = "lua";
        plugin = nvim-treesitter.withAllGrammars;
        config = ''
          require('nvim-treesitter.configs').setup({
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
             },
             incremental_selection = {
               enable = true,
               keymaps = {
                 init_selection = '<CR>',
                 scope_incremental = '<CR>',
                 node_incremental = '<TAB>',
                 node_decremental = '<S-TAB>',
               },
             },
            indent = { enable = true },
          })
        '';
      }
      {
        type = "lua";
        plugin = telescope-nvim;
        config = ''
          require('telescope').setup{
            extensions = {
              ['ui-select'] = {
                require('telescope.themes').get_dropdown{}
              }
            },
            pickers = {
              find_files = {
                find_command = {'rg', '--files', '--sortr=modified'}
              }
            }
          }
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>b', builtin.buffers, {})
          vim.keymap.set('n', '<leader>f', builtin.find_files, {})
          vim.keymap.set('n', '<leader>g', builtin.git_status, {})
          vim.keymap.set('n', '<leader>l', builtin.live_grep, {})

          require('telescope').load_extension('fzf')
          require('telescope').load_extension('ui-select')
        '';
      }
      {
        type = "lua";
        plugin = telescope-fzf-native-nvim;
      }
      {
        type = "lua";
        plugin = telescope-ui-select-nvim;
      }
      {
        type = "lua";
        plugin = nvim-autopairs;
        config = ''
          require('nvim-autopairs').setup{
            disable_in_visualblock = false,
            enable_check_bracket_line = false,
          }
        '';
      }
      {
        type = "lua";
        plugin = typescript-tools-nvim;
        config = ''
          require('typescript-tools').setup{
            settings = {
              filetypes = {
                'javascript',
                'javascriptreact',
                'typescript',
                'typescriptreact',
                'vue',
              },
              tsserver_plugins = {
                '@vue/typescript-plugin',
                languages = { 'vue' },
              },
            },
          }
        '';
      }
    ];
  };
}
