# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:

{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModules.default
    inputs.vscode-server.nixosModules.home

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    (import ../shared/programs/bat { inherit config; })
    (import ../shared/programs/direnv { inherit config; })
    (import ../shared/programs/exa { inherit config; })
    (import ../shared/programs/git { inherit config lib pkgs; })
    (import ../shared/programs/htop { inherit config; })
    (import ../shared/programs/starship { inherit config; })

    (import ../shared/programs/zsh {
      inherit config pkgs inputs;
      colorIt = true;
    })
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

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })

      (final: prev:
        {
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

  gtk = {
    enable = true;
    font.name = "sans-serif";
  };

  home = {
    activation = {
      installNvimConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
          ln -s "/etc/nixos/config/nvim" "${config.home.homeDirectory}/.config/nvim" 
        fi
      '';
    };

    file = {
      ".local/bin/updoot" = {
        # Upload and get link
        executable = true;
        text = import ../shared/bin/updoot.nix { inherit pkgs; };
      };

      ".local/bin/preview.sh" = {
        # Preview script for fzf tab
        executable = true;
        text = import ../shared/bin/preview.nix { inherit pkgs; };
      };
    };

    homeDirectory = "/home/javacafe01";

    packages = lib.attrValues {
      inherit (pkgs)
        dbus
        dconf
        glxinfo
        go
        neovim
        pandoc
        popsicle
        sqlite
        trash-cli
        xdg-user-dirs

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
        luaFormatter
        nixpkgs-fmt
        rustfmt
        shfmt

        # Extras
        editorconfig-core-c
        fd
        gnuplot
        gnutls
        imagemagick
        sdcv
        ripgrep;

      inherit (pkgs.gnome)
        nautilus;

      inherit (pkgs.nodePackages_latest)
        prettier
        prettier_d_slim
        pyright;
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];

    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
      GOPATH = "${config.home.homeDirectory}/Extras/go";
      RUSTUP_HOME = "${config.home.homeDirectory}/.local/share/rustup";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    username = "javacafe01";
  };

  programs.home-manager.enable = true;

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    vscode-server = {
      enable = true;
      enableFHS = true;
    };
  };

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
}
# This is your home-manager configuration file
