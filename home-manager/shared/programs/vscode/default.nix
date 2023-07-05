{ config, inputs, pkgs, ... }:

let
  marketplace-extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
    koihik.vscode-lua-format
    ms-python.isort
    ms-python.python
    ms-python.vscode-pylance
    rvest.vs-code-prettier-eslint
    sndst00m.markdown-github-dark-pack
  ];
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    extensions = with pkgs.vscode-extensions; [
      b4dm4n.vscode-nixpkgs-fmt
      esbenp.prettier-vscode
      jnoortheen.nix-ide
      ms-vscode.cpptools
      ms-toolsai.jupyter
      ms-toolsai.jupyter-renderers
      ms-toolsai.jupyter-keymap
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      mkhl.direnv
      sumneko.lua
      xaver.clang-format
    ] ++ marketplace-extensions;

    mutableExtensionsDir = true;

    userSettings = {
      Lua.misc.executablePath = "${pkgs.sumneko-lua-language-server}/bin/lua-language-server";

      "[c]".editor.defaultFormatter = "xaver.clang-format";
      "[cpp]".editor.defaultFormatter = "xaver.clang-format";
      "[css]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[html]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[javascript]".editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
      "[lua]".editor.defaultFormatter = "Koihik.vscode-lua-format";
      "[nix]".editor.defaultFormatter = "B4dM4n.nixpkgs-fmt";
      "[python]".editor.formatOnType = true;

      editor = {
        cursorBlinking = "smooth";
        fontFamily = "'monospace', monospace";
        formatOnSave = true;
        lineNumbers = "on";
        minimap.enabled = false;
        smoothScrolling = true;

        bracketPairColorization = {
          enabled = true;
          independentColorPoolPerBracketType = true;
        };
      };

      jupyter.askForKernelRestart = false;
      nix.serverPath = "${pkgs.nil}/bin/nil";

      platformio-ide = {
        useBuiltinPIOCore = false;
        useBuiltinPython = false;
      };

      terminal.integrated = {
        cursorBlinking = true;
        cursorStyle = "line";
        fontFamily = "'monospace', monospace";
        smoothScrolling = true;
      };

      window = {
        menuBarVisibility = "toggle";
        nativeTabs = true;
        titleBarStyle = "native";
      };

      workbench = {
        colorTheme = "Default Dark+ Experimental";
        list.smoothScrolling = true;
        smoothScrolling = true;
      };
    };
  };
}
