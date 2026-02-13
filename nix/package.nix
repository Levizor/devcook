{ inputs, ... }:
{
  perSystem =
    {
      config,
      self',
      inputs',
      pkgs,
      system,
      ...
    }:
    {
      packages.default = pkgs.stdenv.mkDerivation {
        name = "devcook";
        src = ../.;

        nativeBuildInputs = [ pkgs.hugo ];

        buildPhase = ''
          hugo --minify
        '';

        installPhase = ''
          mkdir -p $out
          cp -r public/* $out/
        '';
      };
    };
}
