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
        config = builtins.readFile ./lspconfig.lua;
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
        plugin = guess-indent-nvim;
        config = "require('guess-indent').setup{}";
      }
      {
        type = "lua";
        plugin = blink-cmp;
        config = "require('blink-cmp').setup{}";
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
                find_command = {
                  'rg',
                  '--files',
                  '--sortr=modified',
                  -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
                  '--hidden',
                  '--glob',
                  '!**/.git/*',
                },
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
