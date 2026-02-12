{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    rec {
      devShells.dev = pkgs.mkShell {
        buildInputs = with pkgs; [
          hugo
          git
        ];
      };

      devShells.default = devShells.dev;
    };
}
