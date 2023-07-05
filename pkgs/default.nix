# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { }, inputs }: {
  # example = pkgs.callPackage ./example { };
  rounded-sbe = pkgs.callPackage ./rounded-sbe.nix {
    src = inputs.rounded-sbe;
    version = "999-master";
  };

  sfmonoNerdFontLig = pkgs.callPackage ./sfmonoNerdFontLig.nix {
    src = inputs.sfmonoNerdFontLig;
    version = "999-master";
  };
}
