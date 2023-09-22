{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.services.podman;
in
{
  options.modules.services.podman = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
      };
      docker.enable = false;
    };

    environment = {
      systemPackages = with pkgs; [
        docker-client
        docker
      ];
    };
  };
}
