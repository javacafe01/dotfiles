# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:

{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.discocss.hmModule
    inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    (import ../shared/programs/bat { inherit config; })
    (import ../shared/programs/direnv { inherit config; })
    (import ../shared/programs/exa { inherit config; })

    (import ../shared/programs/firefox {
      inherit config pkgs;
      package = pkgs.firefox;

      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        ublock-origin
        octotree
      ];
    })

    (import ../shared/programs/git { inherit config lib pkgs; })
    (import ../shared/programs/htop { inherit config; })
    (import ../shared/programs/starship { inherit config; })
    (import ../shared/programs/vscode { inherit config inputs pkgs; })

    (import ../shared/programs/discord {
      inherit config; discordPackage = pkgs.discord;
    })

    (import ../shared/programs/zsh { inherit config pkgs inputs; colorIt = false; })
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      inputs.nixpkgs-f2k.overlays.stdenvs
      inputs.nur.overlay

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })

      (final: prev:
        {
          discord = prev.discord.override { withOpenASAR = true; };
          neovim = inputs.neovim-nightly.packages.${final.system}.default;
          ripgrep = prev.ripgrep.override { withPCRE2 = true; };
        })
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  colorScheme = inputs.nix-colors.colorSchemes.tomorrow-night;

  fonts.fontconfig.enable = true;

  home = {
    activation = {
      installNvimConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
          ln -s "/etc/nixos/config/nvim" "${config.home.homeDirectory}/.config/nvim" 
        fi
      '';
    };

    file = {
      # Amazing Phinger Icons
      ".icons/default".source =
        "${pkgs.phinger-cursors}/share/icons/phinger-cursors";

      ".local/bin/updoot" = {
        # Upload and get link
        executable = true;
        text = import ../shared/bin/updoot.nix { inherit pkgs; };
      };

      ".local/bin/panes" = {
        executable = true;
        text = import ../shared/bin/panes.nix { };
      };

      ".local/bin/preview.sh" = {
        # Preview script for fzf tab
        executable = true;
        text = import ../shared/bin/preview.nix { inherit pkgs; };
      };

      ".tree-sitter".source = pkgs.runCommand "grammars" { } ''
        mkdir -p $out/bin
        ${
          lib.concatStringsSep "\n" (lib.mapAttrsToList (name: src:
            "name=${name}; ln -s ${src}/parser $out/bin/\${name#tree-sitter-}.so")
            pkgs.tree-sitter.builtGrammars)
        };
      '';
    };

    homeDirectory = "/home/javacafe01";

    packages = lib.attrValues {
      inherit (pkgs)
        mpc_cli
        neovim
        playerctl
        trash-cli
        xdg-user-dirs
        zoom-us

        # Language servers
        ccls
        clang
        clang-tools
        nil
        rust-analyzer
        shellcheck
        sumneko-lua-language-server

        # Formatters
        black
        ktlint
        nixpkgs-fmt
        rustfmt
        shfmt
        stylua

        # Extras
        deadnix
        editorconfig-core-c
        fd
        gnuplot
        gnutls
        imagemagick
        sdcv
        sqlite
        statix
        ripgrep;

      inherit (pkgs.luajitPackages)
        jsregexp;

      inherit (pkgs.nodePackages_latest)
        prettier
        prettier_d_slim
        bash-language-server
        pyright;
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];

    sessionVariables = {
      BROWSER = "${pkgs.firefox}/bin/firefox";
      EDITOR = "${pkgs.neovim}/bin/nvim";
      GOPATH = "${config.home.homeDirectory}/Extras/go";
      RUSTUP_HOME = "${config.home.homeDirectory}/.local/share/rustup";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    username = "javacafe01";
  };

  programs = {
    home-manager.enable = true;
    mpv.enable = true;
  };

  services.playerctld.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  xdg = {
    enable = true;

    configFile = {
      "nvim/parser/c.so".source =
        "${pkgs.tree-sitter.builtGrammars.tree-sitter-c}/parser";
      "nvim/parser/lua.so".source =
        "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
      "nvim/parser/rust.so".source =
        "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
      "nvim/parser/python.so".source =
        "${pkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";
      "nvim/parser/nix.so".source =
        "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
    };

    userDirs = {
      enable = true;
      documents = "${config.home.homeDirectory}/Documents";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  xresources.extraConfig = import ../shared/x/resources.nix { theme = config.colorScheme; };
}
