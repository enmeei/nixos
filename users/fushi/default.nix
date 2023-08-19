{ lib, pkgs, config, options, ... }:

with lib;
with lib.my;

let
  user = "fushi";
in
{
  users.users."${user}" = {
    group = "users";
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" ];
    description = "My personal account.";
    hashedPassword = "$6$YNJGW9lqQz5ccudx$NZnn/GlUXbeoyu6mD7/LLuqVMCd4v8pDmW0xEpMLXcv9gcFqZ24NDpkJxxgCCXbLkSCBiLJ9UdqUBKll4BvAO/";
  };

  home-manager.users.${user} = { pkgs, config, ... }: {

    modules = {
      desktop = {
        browsers = {
          default = "firefox";
          firefox.enable = true;
        };
      };
      editors = {
        nvim = {
          enable = true;
          nyoom.enable = true;
        };
        default = "nvim";
      };
    };

    home.stateVersion = "23.11";
  };
}
