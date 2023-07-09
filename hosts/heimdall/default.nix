{ pkgs
, config
, lib
, ...
}: {
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];
  ## Modules
  modules = {
    hardware = {
      audio.enable = true;
      fs = {
        enable = true;
        ssd.enable = true;
      };
    };
    desktop = {
      hypr.enable = true;
      media = {
        vlc.enable = true;
        nomacs.enable = true;
      };
      apps = {
        editors = {
          code.enable = true;
        };
	messengers = {
	  discord.enable = true;
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
          run = "kitty --single-instace";
        };
        kitty.enable = true;
      };
    };
    dev = {
      shell.enable = true;
      cc.enable = true;
      rust.enable = true;
      node.enable = true;
      python.enable = true;
    };
    editors = {
      default = "nvim";
      vim.enable = true;
    };
    shell = {
      zsh.enable = true;
      git.enable = true;
      tmux.enable = true;
      starship.enable = true;
    };
    services = {
      polkit.enable = true;
      ssh.enable = true;
      docker.enable = true;
    };
    theme.active = "nordic";
  };

  # Tty config
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-116n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "br-abnt2";
  };

  # This was used for river. Good to have it anyways, i guess
  environment.variables."XKB_DEFAULT_LAYOUT" = "br";

  networking.networkmanager.enable = true;
  # Local config
  programs.ssh.startAgent = true;
  services = {
    openssh.startWhenNeeded = true;
    xserver = {
      # Keyboard configuration
      layout = "br";
      autoRepeatDelay = 300;
      autoRepeatInterval = 20;
    };
  };

}
