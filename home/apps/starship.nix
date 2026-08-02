{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    settings = {
      # FIRST LINE/ROW: Info & Status
      username = {
        # Inherits terminal's dynamic purple accent
        format = "[힐러](bold purple) @ ";
        show_always = true;
        style_root = "bold red";
      };

      hostname = {
        disabled = false;
        # Inherits terminal's dynamic red accent
        format = "[판도라](bold red) in ";
        ssh_only = false;
        ssh_symbol = " ";
      };

      directory = {
        style = "bold yellow";
        truncate_to_repo = true;
        truncation_length = 0;
        truncation_symbol = "레포: ";
        read_only = "";
      };

      git_metrics = {
        disabled = false;
        added_style = "bold green";
        format = "[+$added]($added_style)/[-$deleted]($deleted_style) ";
      };

      sudo = {
        disabled = false;
      };

      git_status = {
        ahead = "\${count}";
        behind = "\${count}";
        deleted = "x";
        diverged = "\${ahead_count}\${behind_count}";
        style = "text";
      };

      git_branch = {
        symbol = " ";
        style = "bold green";
      };

      nix_shell = {
        format = "via [$symbol(($name))]($style) ";
        symbol = " ";
      };

      cmd_duration = {
        disabled = false;
        style = "bold magenta";
        format = "took [$duration]($style)";
        show_milliseconds = true;
        show_notifications = true;
        min_time_to_notify = 30000;
      };

      # SECOND LINE/ROW: Prompt
      battery = {
        charging_symbol = "";
        disabled = true;
        discharging_symbol = "";
        full_symbol = "";
        display = [
          {
            disabled = false;
            style = "bold red";
            threshold = 15;
          }
          {
            disabled = true;
            style = "bold yellow";
            threshold = 50;
          }
          {
            disabled = true;
            style = "bold green";
            threshold = 90;
          }
        ];
      };

      status = {
        disabled = false;
        format = "[$symbol$status_common_meaning$status_signal_name$status_maybe_int]($style)";
        map_symbol = true;
        pipestatus = true;
        symbol = "✖";
        not_executable_symbol = "";
        not_found_symbol = "";
        sigint_symbol = "󰟾";
        signal_symbol = "";
      };

      os = {
        disabled = false;
        format = " [$symbol]($style)";
        style = "bold purple";
        symbols = {
          Alpaquita = " ";
          Alpine = " ";
          AlmaLinux = " ";
          Amazon = " ";
          Android = " ";
          Arch = " ";
          Artix = " ";
          CentOS = " ";
          Debian = " ";
          DragonFly = " ";
          Emscripten = " ";
          EndeavourOS = " ";
          Fedora = " ";
          FreeBSD = " ";
          Garuda = "󰛓 ";
          Gentoo = " ";
          HardenedBSD = "󰞌 ";
          Illumos = "󰈸 ";
          Kali = " ";
          Linux = " ";
          Mabox = " ";
          Macos = " ";
          Manjaro = " ";
          Mariner = " ";
          MidnightBSD = " ";
          Mint = " ";
          NetBSD = " ";
          NixOS = " ";
          OpenBSD = "󰈺 ";
          openSUSE = " ";
          OracleLinux = "󰌷 ";
          Pop = " ";
          Raspbian = " ";
          Redhat = " ";
          RedHatEnterprise = " ";
          RockyLinux = " ";
          Redox = "󰀘 ";
          Solus = "󰠳 ";
          SUSE = " ";
          Ubuntu = " ";
          Unknown = " ";
          Void = " ";
          Windows = "󰍲 ";
        };
      };

      character = {
        error_symbol = "";
        success_symbol = "[❯](bold green)";
      };

      # Language & Tool Symbols
      git_commit.tag_symbol = "  ";
      golang.symbol = " ";
      guix_shell.symbol = " ";
      haskell.symbol = " ";
      haxe.symbol = " ";
      hg_branch.symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      kotlin.symbol = " ";
      lua.symbol = " ";
      memory_usage.symbol = "󰍛 ";
      meson.symbol = "󰔷 ";
      nim.symbol = "󰆥 ";
      nodejs.symbol = " ";
      ocaml.symbol = " ";
      package.symbol = "󰏗 ";
      perl.symbol = " ";
      php.symbol = " ";
      pijul_channel.symbol = " ";
      python.symbol = " ";
      rlang.symbol = "󰟔 ";
      ruby.symbol = " ";
      rust.symbol = "󱘗 ";
      scala.symbol = " ";
      swift.symbol = " ";
      zig.symbol = " ";
      gradle.symbol = " ";
    };
  };
}