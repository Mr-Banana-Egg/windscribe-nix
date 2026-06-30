{
  description = "Windscribe VPN client for NixOS";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
    in
   {
     packages = nixpkgs.lib.genAttrs systems (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {

        windscribe = pkgs.callPackage ./package.nix { };
        default = self.packages.${system}.windscribe;

      overlays.default = final: _prev: {
        windscribe = final.callPackage ./package.nix { };
      };

      nixosModules = {
        windscribe = import ./module.nix;
        default = self.nixosModules.windscribe;
      };
    }
);
};

}
