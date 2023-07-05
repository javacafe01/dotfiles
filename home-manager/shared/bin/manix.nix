{ pkgs, ... }:

''
  #> Syntax: bash
  ${pkgs.manix}/bin/manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | ${pkgs.fzf}/bin/fzf --preview="${pkgs.manix}/bin/manix '{}'" | xargs ${pkgs.manix}/bin/manix
''
