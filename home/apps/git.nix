{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # Git Core Configuration
  # -------------------------------------------------------------------------
  programs.git = {
    enable = true;

    settings = {
      user.name = "0xhealer";
      user.email = "healer284@proton.me";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
    };
  };

  # -------------------------------------------------------------------------
  # GitHub CLI
  # -------------------------------------------------------------------------
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  # -------------------------------------------------------------------------
  # Lazygit (TUI Git Client)
  # -------------------------------------------------------------------------
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showIcons = true;
        showFileTree = true;
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "bat --paging=never";
        };
      };
    };
  };
}