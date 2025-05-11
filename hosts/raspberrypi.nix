{ config, pkgs, ... }:

{
  imports = [ ];

  system.stateVersion = "23.11";

  networking.hostName = "raspberrypi";
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  time.timeZone = "Europe/Berlin";

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "nixos"; # 🔐 Nur für Tests
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    wget
  ];

  services.openssh.enable = true;

  # USB-Stick auf /media/filme mounten
  fileSystems."/media/filme" = {
    device = "/dev/sda1";
    fsType = "auto";
    options = [ "nofail" "x-systemd.automount" ];
  };

  # WLAN Access Point mit interner Karte
  networking = {
    wireless.enable = false;
    interfaces.wlan0.useDHCP = false;
    interfaces.wlan0.ipv4.addresses = [{
      address = "192.168.4.1";
      prefixLength = 24;
    }];
    hostapd = {
      enable = true;
      interface = "wlan0";
      ssid = "PiNAS";
      wpaPassphrase = "raspberry123";
    };
  };
}
