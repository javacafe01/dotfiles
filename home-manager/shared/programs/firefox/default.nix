{ config, pkgs, package, profiles, ... }:

{
  programs.firefox = {
    enable = true;
    inherit package;
    inherit profiles;
  };
}
