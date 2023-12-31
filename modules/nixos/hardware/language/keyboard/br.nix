{ pkgs, config, inputs, lib, ... }:


let
  cfg = config.modules.hardware.language.keyboard.br;
in
{
  options.modules.hardware.language.keyboard.br = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # This sets some sensible
    # defaults for the keyboard configuration.
    services.xserver = {
      layout = "br";
    };
    # This sets up the tty.
    # Not generally used, but good.
    console.keyMap = "br-abnt2";
  };
}
