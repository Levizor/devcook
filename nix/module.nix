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

        dataDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/devcook";
          description = "The directory where the website content and repo will be stored.";
        };

        package = lib.mkOption {
          type = lib.types.package;
          default = self.packages.${pkgs.system}.default;
          description = "The devcook package to use (used if autoUpdate is false).";
        };

        autoUpdate = {
          enable = lib.mkEnableOption "automatic updates via git pull";

          interval = lib.mkOption {
            type = lib.types.str;
            default = "15min";
            description = "Systemd calendar interval for checking updates.";
          };

          gitRepo = lib.mkOption {
            type = lib.types.str;
            default = "https://github.com/Levizor/devcook.git";
            description = "Git repository URL to pull from.";
          };
        };
      };

      config = lib.mkIf cfg.enable {
        systemd.tmpfiles.rules = lib.mkIf cfg.autoUpdate.enable [
          "d ${cfg.dataDir} 0750 nginx nginx - -"
        ];

        systemd.services.devcook-updater = lib.mkIf cfg.autoUpdate.enable {
          description = "Update devcook website from git";
          path = with pkgs; [
            git
            hugo
            coreutils
          ];
          serviceConfig = {
            Type = "oneshot";
            User = "nginx";
            WorkingDirectory = cfg.dataDir;
          };
          script = ''
            if [ ! -d "repo/.git" ]; then
              rm -rf repo
              git clone "${cfg.autoUpdate.gitRepo}" repo
            else
              cd repo
              git pull
              cd ..
            fi

            cd repo
            hugo --minify --destination ../public_new

            cd ..
            if [ -d "public_new" ]; then
              rm -rf public_old
              if [ -d "public" ]; then
                mv public public_old
              fi
              mv public_new public
            fi
          '';
        };

        systemd.timers.devcook-updater = lib.mkIf cfg.autoUpdate.enable {
          description = "Timer for devcook auto-updater";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "5m";
            OnUnitActiveSec = cfg.autoUpdate.interval;
          };
        };

        services.nginx = {
          enable = true;
          virtualHosts.${cfg.domain} = {
            root = if cfg.autoUpdate.enable then "${cfg.dataDir}/public" else cfg.package;

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

