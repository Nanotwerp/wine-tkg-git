{
  description = "Dev shell to compile Wine";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable-small";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      overlays = [ (import rust-overlay) ];

      forAllSystems = f: nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: f {
        pkgs = import nixpkgs { inherit system overlays; };
        system = system;
      });
    in
    {
      devShell = forAllSystems
        ({ system, pkgs }:
          pkgs.mkShell {
            packages = with pkgs; [
              stdenv
              autoconf
            ];
          }
        );
    };
}
