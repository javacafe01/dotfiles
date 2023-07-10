{ inputs, outputs, lib, config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.avrdude
    pkgs.platformio
  ];

  services.udev.packages = [ pkgs.platformio ];
}
