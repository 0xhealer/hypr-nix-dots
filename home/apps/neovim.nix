{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # Declarative Neovim Configuration
  # -------------------------------------------------------------------------
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # -----------------------------------------------------------------------
    # Neovim Plugins
    # -----------------------------------------------------------------------
    plugins = with pkgs.vimPlugins; [
      # Syntax Highlighting & Parsing
      (nvim-treesitter.withPlugins (p: with p; [
        nix
        lua
        vim
        bash
        json
        yaml
        markdown
        python
        rust
        go
      ]))

      # LSP & Completion
      nvim-lspconfig

      # Navigation & UI Tools
      telescope-nvim
      plenary-nvim
      nvim-web-devicons
      lualine-nvim
      gitsigns-nvim

      # Quality of Life
      vim-sleuth # Auto-detect indentation settings
    ];

    # -----------------------------------------------------------------------
    # Embedded Lua Configuration (init.lua)
    # -----------------------------------------------------------------------
    extraLuaConfig = ''
      -- Set mapleader to space before anything else
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      -- Options
      local opt = vim.opt
      opt.number = true
      opt.relativenumber = true
      opt.mouse = 'a'
      opt.showmode = false
      opt.clipboard = 'unnamedplus' -- Use Wayland clipboard
      opt.breakindent = true
      opt.undofile = true
      opt.ignorecase = true
      opt.smartcase = true
      opt.signcolumn = 'yes'
      opt.updatetime = 250
      opt.timeoutlen = 300
      opt.splitright = true
      opt.splitbelow = true
      opt.list = true
      opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
      opt.inccommand = 'split'
      opt.cursorline = true
      opt.scrolloff = 10
      opt.termguicolors = true
      opt.tabstop = 2
      opt.shiftwidth = 2
      opt.expandtab = true

      -- Keymaps
      local keymap = vim.keymap.set
      keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')
      keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
      keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
      keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic error' })

      -- Telescope Keybindings
      local builtin = require('telescope.builtin')
      keymap('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
      keymap('n', '<leader>fg', builtin.live_grep, { desc = 'Find by Grep' })
      keymap('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
      keymap('n', '<leader>fh', builtin.help_tags, { desc = 'Find Help' })

      -- Initialize Plugins
      require('gitsigns').setup()
      require('lualine').setup({
        options = {
          theme = 'auto',
          component_separators = "|",
          section_separators = "",
        }
      })

      -- LSP Configurations
      local lspconfig = require('lspconfig')

      -- Nix LSP (nixd)
      lspconfig.nixd.setup({
        cmd = { "nixd" },
        settings = {
          nixd = {
            formatting = { command = { "nixfmt" } },
          },
        },
      })

      -- Lua LSP (lua_ls)
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
          },
        },
      })
    '';
  };
}