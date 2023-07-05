{ config, isWayland ? "false", ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = import ./settings.nix { inherit isWayland; theme = config.colorScheme; };
  };
}
