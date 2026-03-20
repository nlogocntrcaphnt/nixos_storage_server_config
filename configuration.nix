# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
	imports = [ 
	# Include the results of the hardware scan.
	./hardware-configuration.nix
	];

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.crashDump.enable = true;

	networking.hostName = "cryochamber"; # Define your hostname.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Enable networking
	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "Europe/Athens";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "el_GR.UTF-8";
		LC_IDENTIFICATION = "el_GR.UTF-8";
		LC_MEASUREMENT = "el_GR.UTF-8";
		LC_MONETARY = "el_GR.UTF-8";
		LC_NAME = "el_GR.UTF-8";
		LC_NUMERIC = "el_GR.UTF-8";
		LC_PAPER = "el_GR.UTF-8";
		LC_TELEPHONE = "el_GR.UTF-8";
		LC_TIME = "el_GR.UTF-8";
	};

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us";
		variant = "";
	};

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.polyphemus = {
		isNormalUser = true;
		description = "Constantine";
		extraGroups = [ "networkmanager" "wheel" "video" "render" ];
		packages = with pkgs; [

		];
	};

  # Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	boot.kernelPackages = pkgs.linuxPackages_latest;

	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	system.autoUpgrade.enable = true;
	system.autoUpgrade.dates = "weekly";

	nix.gc.automatic = true;
	nix.gc.dates = "daily";
	nix.gc.options = "--delete-older-than 7d";
	nix.settings.auto-optimise-store = true;

	services.getty = {
		autologinUser = "polyphemus";
		autologinOnce = true;
	};
	environment.loginShellInit = ''
	[[ "$(tty)" == /dev/ttyl ]] & sway
	'';

	security = {
		pam.services = {
			login = {
# startSession = true;
				enableGnomeKeyring = true;
			};
# gnome keyring even without display manager
			logind.enableGnomeKeyring = true;
# sshd.enableGnomeKeyring = true;
		};
		polkit = {
			enable = true;
		};
	};

	services.gvfs.enable = true;

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
#		extraPackages = with pkgs; [
#			libva
#			libva-utils
#			libva-vdpau-driver
#			libvdpau-va-gl
#		];
	};

	hardware.bluetooth = {
		enable = true;
		powerOnBoot = true;
		settings = {
			General = {
      # Shows battery charge of connected devices on supported
      # Bluetooth adapters. Defaults to 'false'.
				Experimental = true;
      # When enabled other devices can connect faster to us, however
      # the tradeoff is increased power consumption. Defaults to
      # 'false'.
				FastConnectable = true;
			};
			Policy = {
      # Enable all controllers when they are found. This includes
      # adapters present on start as well as adapters that are plugged
      # in later on. Defaults to 'true'.
				AutoEnable = true;
			};
		};
	};

	services.blueman.enable = true;

	hardware.logitech.wireless.enable = true;
	hardware.logitech.wireless.enableGraphical = true;



	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true;
		extraPackages = with pkgs; [
			wl-clipboard
			mako
			i3status
			libinput
			grim
			slurp
						
			foot

			wmenu
			dmenu
		];
		extraSessionCommands = ''
			export SDL_VIDEODRIVER=wayland
			export QT_QPA_PLATFORM=wayland
			export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
			export _JAVA_AWT_WM_NONREPARENTING=1
			export MOZ_ENABLE_WAYLAND=1
		'';
	};

	programs.xwayland.enable = true;
		
	services.pcscd.enable = true;
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
	};


	fonts.packages = with pkgs; [
		terminus_font
		noto-fonts
		noto-fonts-cjk-sans
	];
	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		firefox
		ungoogled-chromium

		pcmanfm
		ffmpegthumbnailer

		neovim
		git
		gnumake
		gedit
		
		killall

		rsync

		yt-dlp
		aria2
		nicotine-plus

		telegram-desktop
		discord

		newsboat

		mpv
		obs-studio
		mpd
		ncmpcpp
		zathura		

		gimp3

		htop
		lm_sensors

		glib
		unzip
		ntfs3g
		fuse3
		parted
		btrfs-progs
		smartmontools

		gnupg

		ffmpeg-full
		alsa-utils

		ollama-vulkan
		codex

		rtorrent

		fastfetch
		sherlock
	];
	
#	environment.variables = {
#		ROC_ENABLE_PRE_VEGA = "1";
#		VDPAU_DRIVER = "radeonsi";
#	};


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

