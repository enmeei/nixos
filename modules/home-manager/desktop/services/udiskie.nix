{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.modules.desktop.services.udiskie;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.services.udiskie = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable the udiskie service.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.udiskie = {
      enable = true;
    };

    # Else, it wont start.
    # This is not supplied by wayland.
    systemd.user.targets.tray = {
      Unit = {
        Description = "Home manager system tray";
        Requires = [
          "graphical-session-pre.target"
        ];
      };
    };

  };
}