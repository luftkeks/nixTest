{ config, pkgs, ... }:

{
  imports = [ ];

  system.stateVersion = "23.11";

  time.timeZone = "Europe/Berlin";

  # Grundlegende Netzwerkkonfiguration
  networking.interfaces.eth0.useDHCP = true;
  networking.hostName = "raspberrypi";

  # WLAN Access Point Konfiguration
  networking.wireless.enable = true;
  networking.interfaces.wlan0.useDHCP = false;
  networking.interfaces.wlan0.ipv4.addresses = [{
    address = "192.168.4.1";
    prefixLength = 24;
  }];

  services.hostapd = {
    enable = true;
    interface = "wlan0";
    ssid = "PiNAS";
    wpaPassphrase = "raspberry123";
    config = [
      "interface=wlan0"
      "driver=nl80211"
      "ssid=PiNAS"
      "hw_mode=g"
      "channel=7"
      "wmm_enabled=0"
      "macaddr_acl=0"
      "auth_algs=1"
      "ignore_broadcast_ssid=0"
    ];
  };

  # Benutzer konfigurieren
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel", "network" ];
    password = "nixos"; # 🔐 Nur für Tests
    shell = pkgs.shadowCmds userDetails.defaultShell;
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    wget
    openssh
    openvpn
  ];

  services.openssh.enable = true;

  # USB-Stick mounten
  fileSystems."/media/filme" = {
    device = "/dev/sda1";
    fsType = "auto";
    options = [ "nofail" "x-systemd.automount" ];
  };

  # Netzwerkdienste aktivieren
  services.netfilter.enable = true;
  networking.ipv4 forwarding = true;

  # Jellyfin Medienserver
  services.jellyfin = {
    enable = true;
    dataDir = "/media/filme";
  };

  # SMB Dateifreigabe
  services.samba = {
    enable = true;
    shares = {
      "Fotos" = {
        path = "/media/fotos";
        browseable = true;
        writable = true;
        validUsers = [ "nixos" ];
      };
      "Videos" = {
        path = "/media/filme";
        browseable = true;
        writable = true;
        validUsers = [ "nixos" ];
      };
      "Daten" = {
        path = "/media/daten";
        browseable = true;
        writable = true;
        validUsers = [ "nixos" ];
      };
    };
  };

  # Dummy-Daten erstellen
  systemd.tmpfiles.rules = [
    "d /media/fotos 0755 nixos nixos -"
    "d /media/daten 0755 nixos nixos -"
    "d /media/filme 0755 nixos nixos -"
  ];
}
