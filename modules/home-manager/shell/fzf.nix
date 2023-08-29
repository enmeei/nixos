{ config, lib, ... }:

let
  cfg = config.modules.shell.fzf;
in
{
  options.modules.shell.fzf = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable fzf.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}