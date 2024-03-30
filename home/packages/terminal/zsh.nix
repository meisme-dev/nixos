{ libs, config, pkgs, ... }:

{
  # Customize ZSh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    dotDir = ".config/zsh";

    # Set some aliases for convenience
    shellAliases = {
      cat = "bat --style auto";
      grep = "rg";
    };

    # Manage plugins without oh-my-zsh
    plugins = [
      {
        name = "fzf-zsh-plugin";
        src = pkgs.fetchFromGitHub {
          owner = "unixorn";
          repo = "fzf-zsh-plugin";
          rev = "43f0e1b7686113e9b0dcc108b120593f992dad4a";
          sha256 = "TfTIPwF2DaJKmsj3QGG1tXoRJxM3If5yMEP2WAfQvhE=";
        };
      }
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "afc5afd15fe093bfd96faa521abe0255334c85b0";
          sha256 = "npflZ7sr2yTeLQZIpozgxShq3zbIB5WMIZwMv8rkLJg=";
        };
      }
    ];

    # Needed for zsh-autocomplete to work properly
    initExtra = ''
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      bindkey "''${key[Up]}" up-line-or-search
    '';
  };

  # Enable the starship prompt
  programs.starship = {
    enable = true;
  };
}
