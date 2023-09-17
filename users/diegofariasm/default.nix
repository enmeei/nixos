{ config, pkgs, ... }:

let user = "diegofariasm";
in
{

  sops = {
    age = {
      # Age key location.
      # Might change it to the /etc/dotfiles folder.
      # Does it get copied to the nix store?
      keyFile = "/etc/dotfiles/age/diegofariasm";
    };
    defaultSopsFile = ./secrets/user.yaml;
    secrets = {
      password = { };
    };
  };

  users.users."${user}" = {
    group = "users";
    shell = pkgs.zsh;
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" ];
    passwordFile = config.sops.secrets.password.path;
  };


  programs.zsh.enable = true;

  home-manager.users.${user} = { pkgs, config, ... }: {
    # Secrets related to this account.
    # Don't go snooping around
    sops = {
      age = {
        # Age key location.
        # Might change it to the /etc/dotfiles folder.
        # Does it get copied to the nix store?
        keyFile = "/etc/dotfiles/age/diegofariasm";
      };
      defaultSopsFile = ./secrets/ssh.yaml;
      secrets = {
        diegofariasm.path = "${config.home.homeDirectory}/.ssh/id_rsa";
        diegofariasm_pub.path = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
      };
    };

    modules = {
      shell = {
        zsh.enable = true;
        fzf.enable = true;
        direnv.enable = true;
        starship.enable = true;
      };
      desktop = {
        apps = {
          media = {
            vlc.enable = true;
            nomacs.enable = true;
          };
          thunar.enable = true;
        };
        browsers = {
          default = "firefox";
          firefox.enable = true;
        };
        term = {
          default = {
            name = "kitty";
            command = "kitty --single-instance";
          };
          kitty.enable = true;
        };
      };
      editors = {
        code.enable = true;
        nvim = {
          enable = true;
          nyoom.enable = true;
        };
        default = "nvim";
      };
      theme.active = "oxocarbon";
    };
  };
}