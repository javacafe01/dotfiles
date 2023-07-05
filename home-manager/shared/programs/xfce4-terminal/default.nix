{ config, nix-colors, ... }:
{
  xdg.configFile = {
    "xfce4/terminal/terminalrc".text =
      import ./terminalrc.nix {
        theme = config.colorScheme;
        htrs = nix-colors.lib-core.conversions.hexToRGBString ",";
      };
  };
}
