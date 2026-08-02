{ pkgs, inputs, ... }:

let
vscodeMarketplace = inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = with vscodeMarketplace; [
        jnoortheen.nix-ide
        esbenp.prettier-vscode
        ms-python.black-formatter
        golang.go
        rust-lang.rust-analyzer
        yzhang.markdown-all-in-one
        redhat.vscode-yaml
        redhat.ansible
        ms-vscode.powershell
        dbaeumer.vscode-eslint
        usernamehw.errorlens
        streetsidesoftware.code-spell-checker
        qwtel.sqlite-viewer
        miguelsolorio.fluent-icons
      ];

      keybindings = [
        { key = "ctrl+shift+a"; command = "workbench.action.toggleActivityBarVisibility"; }
        { key = "ctrl+shift+b"; command = "workbench.action.toggleSidebarVisibility"; }
        { key = "ctrl+shift+x"; command = "workbench.view.extensions"; }
        { key = "ctrl+shift+e"; command = "workbench.view.explorer"; when = "!explorerViewletVisible"; }
        { key = "ctrl+shift+e"; command = "workbench.action.toggleSidebarVisibility"; when = "explorerViewletVisible"; }
        { key = "ctrl+t"; command = "workbench.action.terminal.toggleTerminal"; }
      ];

      userSettings = {
        # Nix Config
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.serverSettings" = { "nil" = { "formatting" = { "command" = [ "nixfmt" ]; }; }; };

        # Typography
        "editor.fontSize" = 18;
        "editor.fontFamily" = "AnonymicePro Nerd Font";
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "AnonymicePro Nerd Font";
        "terminal.integrated.fontSize" = 14;

        # UI & Layout
        "workbench.editor.showTabs" = "single";
        "editor.stickyScroll.enabled" = false;
        "window.zoomLevel" = 0.5;
        "workbench.layoutControl.enabled" = false;
        "workbench.statusBar.visible" = false;
        "workbench.sideBar.location" = "right";
        "window.menuBarVisibility" = "hidden";
        "workbench.startupEditor" = "none";
        "editor.minimap.enabled" = false;
        "editor.formatOnSave" = true;

        # -------------------------------------------------------------------
        # Blur & Transparency Overrides
        # Makes structural elements 100% transparent so Hyprland backdrop blur shines through
        # -------------------------------------------------------------------
        "workbench.colorCustomizations" = {
          "editor.background" = "#00000000";
          "sideBar.background" = "#00000000";
          "activityBar.background" = "#00000000";
          "statusBar.background" = "#00000000";
          "titleBar.activeBackground" = "#00000000";
          "titleBar.inactiveBackground" = "#00000000";
          "panel.background" = "#00000000";
          "terminal.background" = "#00000000";
          "editorGutter.background" = "#00000000";
          "breadcrumb.background" = "#00000000";
        };

        # Disable AI & Telemetry
        "chat.disableAIFeatures" = true;
        "telemetry.telemetryLevel" = "off";
        "telemetry.feedback.enabled" = false;

        # Auto Save & Files
        "files.autoSave" = "onWindowChange";
        "extensions.ignoreRecommendations" = true;
        "git.autofetch" = true;

        "search.exclude" = {
          "**/node_modules" = true;
          "**/bower_components" = true;
          "**/*.code-search" = true;
        };
      };
    };
  };
}