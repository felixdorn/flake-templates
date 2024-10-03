{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = {nixpkgs, ...}: let
    forAllSystems = nixpkgs.lib.genAttrs ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
  in {
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        nativeBuildInputs = let
          php = pkgs.php83.buildEnv {
            extraConfig = ''
              memory_limit = 1G
            '';

            extensions = exts: exts.enabled ++ (with exts.all; [xdebug]);
          };
        in [php php.packages.composer];
      };
    });
  };
}
