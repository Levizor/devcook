{ self, ... }:
{
  flake.nixosModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.devcook;
    in
    {
      options.services.devcook = {
        enable = lib.mkEnableOption "devcook website";

        domain = lib.mkOption {
          type = lib.types.str;
          default = "localhost";
          description = "The domain name to serve the website on.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 8080;
          description = "The port for Nginx to listen on.";
        };

        package = lib.mkOption {
          type = lib.types.package;
          default = self.packages.${pkgs.system}.default;
          description = "The devcook package to use.";
        };
      };

      config = lib.mkIf cfg.enable {
        services.nginx = {
          enable = true;
          virtualHosts.${cfg.domain} = {
            root = cfg.package;
            listen = [
              {
                addr = "127.0.0.1";
                port = cfg.port;
              }
            ];
          };
        };
      };
    };
}
