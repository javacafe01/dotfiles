{ config, discordPackage, ... }:
let theme = config.colorScheme;
in
{
  programs.discocss = {
    enable = true;
    inherit discordPackage;

    css = import ./discord-css.nix { inherit theme; };
  };
}
