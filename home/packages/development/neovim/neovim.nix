{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovide
  ];

  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    globals.mapleader = " ";

    colorschemes.poimandres = {
      enable = true;
    };

    plugins = {
      alpha = {
        enable = true;
        layout = [
          {
            type = "padding";
            val = 4;
          }
          {
            type = "text";
            val = [
                    "                                                     "
                    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ "
                    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ "
                    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ "
                    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ "
                    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ "
                    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ "
                    "                                                     "
            ];
            opts = {
              position = "center";
              spacing = 1;
            };
          }
          {
            type = "padding";
            val = 4;
          }
          {
            type = "group";
            val = [
              {
                type = "button";
                val = " New file";
                opts = {
                  keymap = [ "n" "e" "<cmd>ene<cr>" {noremap = true; silent = true; nowait = true;} ];
                  shortcut = "e";
                  position = "center";
                  width = 50;
                  align_shortcut = "right";
                  cursor = 2;
                };
                on_press.__raw = "function() vim.cmd[[ene]] end";
              }
              {
                type = "button";
                val = "󰈞 Find file";
                opts = {
                  keymap = [ "n" "f" "<cmd>Telescope find_files<cr>" {noremap = true; silent = true; nowait = true;} ];
                  shortcut = "f";
                  position = "center";
                  width = 50;
                  align_shortcut = "right";
                  cursor = 2;
                };
                on_press.__raw = "function() vim.cmd[[Telescope find_files]] end";
              }
              {
                type = "button";
                val = " Recent files";
                opts = {
                  keymap = [ "n" "r" "<cmd>Telescope oldfiles<cr>" {noremap = true; silent = true; nowait = true;} ];
                  shortcut = "r";
                  position = "center";
                  width = 50;
                  align_shortcut = "right";
                  cursor = 2;
                };
                on_press.__raw = "function() vim.cmd[[Telescope oldfiles]] end";
              }
              {
                type = "button";
                val = " Restore Session";
                opts = {
                  keymap = [ "n" "s" "<cmd>Telescope session-lens<cr>" {noremap = true; silent = true; nowait = true;} ];
                  shortcut = "s";
                  position = "center";
                  width = 50;
                  align_shortcut = "right";
                  cursor = 2;
                };
                on_press.__raw = "function() vim.cmd[[Telescope session-lens]] end";
              }
              {
                type = "button";
                val = " Quit Neovim";
                opts = {
                keymap = [ "n" "q" "<cmd>qa <CR>" {noremap = true; silent = true; nowait = true;} ];
                shortcut = "q";
                position = "center";
                width = 50;
                align_shortcut = "right";
                cursor = 2;
              };
              on_press.__raw = "function() vim.cmd[[qa]] end";
            }
          ];
          opts = {
            spacing = 2;
          };
        }
      ];
    };

    auto-session = {
      enable = true;
      autoRestore.enabled = false;
      autoSave.enabled = true;
    };

    clangd-extensions.enable = true;

    cmp = {
      enable = true;
      settings = {
        mapping = {
          "<cr>" = "cmp.mapping.confirm({ select=true })";
          "<tab>" = "cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })";
        };

        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';

        preselect = "cmp.PreselectMode.None";
        sources = [
          {
            name = "nvim_lsp";
          }
          {
            name = "luasnip";
          }
          {
            name = "path";
          }
          {
            name = "buffer";
          }
        ];
      };
    };

    comment.enable = true;
    cursorline.enable = true;
    floaterm.enable = true;
    gitsigns.enable = true;

    lsp = {
      enable = true;
      servers = {
        clangd.enable = true;
        dartls.enable = true;
        nil_ls.enable = true;
        lua-ls.enable = true;
        kotlin-language-server.enable = true;
        java-language-server.enable = true;
      };
    };
   
    lsp-format.enable = true;

    lualine = {
      enable = true;
      globalstatus = true;
      sectionSeparators.left = "";
      sectionSeparators.right = "";
    };

    luasnip.enable = true;
    
    mini = {
      enable = true;
      modules.indentscope = {
        symbol = "│";
      };
    };

    nix.enable = true;
    noice.enable = true;
    notify.enable = true;
    nvim-colorizer.enable = true;
    
    nvim-tree = {
      enable = true;
      filters.dotfiles = true;
      hijackCursor = true;
      syncRootWithCwd = true;
      view.width = 36;
    };

    telescope.enable = true;
    todo-comments.enable = true;
    treesitter-context.enable = true;
    treesitter-refactor.enable = true;
    treesitter-textobjects.enable = true;

    treesitter = { 
      enable = true;
      disabledLanguages = [ "dart" ];
    };
    which-key.enable = true;
  };

  keymaps = [
    {
      action = "<cmd>FloatermToggle<cr>";
      key = "<C-/>";
      mode = [ "" "t" ];
    }
    {
      action = "<cmd>Telescope buffers<cr>";
      key = "<leader>b";
      options.desc = "Show open buffers";
    }
    {
      action = "<cmd>Telescope find_files<cr>";
      key = "<leader>f";
      options.desc = "Show files in current directory";
    }
    {
      action = "<cmd>Telescope live_grep<cr>";
      key = "<leader>/";
      options.desc = "Search in current directory";
    }
    {
      action = "<cmd>Telescope session-lens<cr>";
      key = "<leader>s";
      options.desc = "View past sessions";
    }
    {
      action = "<cmd>BufferLineCycleNext<cr>";
      key = "<leader>l";
      options.desc = "Go to next tab";
    }
    {
      action = "<cmd>BufferLineCyclePrev<cr>";
      key = "<leader>h";
      options.desc = "Go to previous tab";
    }
    {
      action = "<cmd>BufferLineCloseLeft<cr>";
      key = "<leader>C";
      options.desc = "Close all tabs to the left";
    }
    {
      action = "<cmd>BufferLineCloseRight<cr>";
      key = "<leader>c";
      options.desc = "Close all tabs to the right";
    }
    {
      action = "<cmd>bp | sp | bn | bd<cr>";
      key = "<leader>q";
      options.desc = "Close current tab";
    }
    {
      action = "<cmd>NvimTreeToggle<cr>";
      key = "<leader>t";
      options.desc = "Toggle the filesystem tree";
    }

    {
      action = "<nop>";
      key = "<space>";
      options = {
        silent = true;
        noremap = true;
      };
    }
  ];
    
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };

    #extraPlugins = with pkgs; [
    #  (vimUtils.buildVimPlugin {
    #    name = "everforest";
    #    src = fetchFromGitHub {
    #      owner = "neanias";
    #      repo = "everforest-nvim";
    #      rev = "eedb19079c6bf9d162f74a5c48a6d2759f38cc76";
    #      hash = "sha256-/k6VBzXuap8FTqMij7EQCh32TWaDPR9vAvEHw20fMCo=";
    #    };
    #  })
    #];

    extraConfigLua = builtins.readFile ./config.lua; 
  };
  
  home.sessionVariables = {
    NEOVIDE_FRAME = "none";
  };
}
