{ config, pkgs, ... }:

{
  imports = [ ./neovim ./fish ./zsh ];

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
    bat
    numbat
    typst
  ] ++ import ./neovim/lsp_packages.nix pkgs;

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
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";
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
      delta.enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        merge.tool = "nvimdiff";
      };
      userEmail = "byron.n.sharman@gmail.com";
      userName = "byronsharman";
    };

    keepassxc = {
      enable = true;
      settings = {
        Browser.Enabled = true;
        SSHAgent.Enabled = true;
      };
    };

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };
  };
}
