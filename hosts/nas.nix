// filepath: vscode-vfs://github/luftkeks/nixTest/hosts/nas.nix
{
  # Allgemeine NAS-Konfiguration
  services.samba = {
    enable = true;
    config = {
      workgroup = "NAS";
      server string = "Raspberry Pi NAS";
      interfaces = ["eth0"];
      log file = "/var/log/samba/%m.log";
      max log size = 1000;

      # Freigaben definieren
      shares = {
        "media" = {
          path = "/srv/media";
          browseable = true;
          read only = false;
          guest ok = yes;
          writable = yes;
        };

        "backups" = {
          path = "/srv/backups";
          browseable = true;
          read only = false;
          guest ok = yes;
          writable = yes;
        };
      };
    };
  };

  # Festplatten für Medien und Backups
  fileSystems."/srv/media" = {
    device = "/dev/sda3";
    format = "ext4";
    mountOptions = ["rw"];
  };

  fileSystems."/srv/backups" = {
    device = "/dev/sda4";
    format = "ext4";
    mountOptions = ["rw"];
  };
}