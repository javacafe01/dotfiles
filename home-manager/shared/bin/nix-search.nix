{ pkgs, ... }:

''
  #> Syntax: bash

  nix search "''${@:-nixpkgs}" ".*" |
        grep "^\* " | sed "s/^\* //;s/ (.*//" |
        sed -r "s/\x1b\[([0-9]{1,2}(;[0-9]{1,2})?)?m//g" |
        ${pkgs.fzf}/bin/fzf --preview="nix search nixpkgs '^{}$'"
''
