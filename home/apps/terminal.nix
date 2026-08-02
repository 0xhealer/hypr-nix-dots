{ pkgs, ... }:

{
   # Zoxide (Smart `cd` alternative)
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  # Fzf (Fuzzy Finder)
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # Bat (`cat` clone with syntax highlighting)
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };

  # Eza (`ls` replacement with icons)
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };
}