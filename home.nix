{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "byron";
  home.homeDirectory = "/home/byron";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/byron/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    fzf = {
      enable = true;
      # enabling it manually allows me to disable Alt-C
      # see https://github.com/junegunn/fzf/issues/1238
      enableZshIntegration = false;
    };

    git = {
      enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        merge.tool = "nvimdiff";
      };
      userEmail = "byron.n.sharman@gmail.com";
      userName = "b-sharman";
    };

    neovim = {
      enable = true;
      extraLuaConfig = builtins.readFile neovim/init.lua;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        {
          type = "lua";
          plugin = nvim-lspconfig;
          config = ''
            require('lspconfig')
            require('lspconfig').svelte.setup{}
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
          plugin = plenary-nvim;
        }
        {
          type = "lua";
          plugin = telescope-nvim;
          config = ''
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>b', builtin.buffers, {})
            vim.keymap.set('n', '<leader>f', builtin.find_files, {})
            vim.keymap.set('n', '<leader>l', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>t', builtin.treesitter, {})
          '';
        }
        {
          type = "lua";
          plugin = typescript-tools-nvim;
          config = ''
            require('typescript-tools').setup{}
          '';
        }
      ];
    };

    zsh = {
      autosuggestion.enable = true;
      defaultKeymap = "viins";
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      initExtra = builtins.readFile zsh/init.sh;
      shellAliases = {
        du = "du -h";
        grep = "grep --color";
        ip = "ip -c";
        ls = "ls --color --group-directories-first";
      };
      syntaxHighlighting.enable = true;
    };
  };
}
