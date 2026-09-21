{ config, pkgs, ... }:

{
  imports = [
    ./global

    ./features/cli
    ./features/desktop/common
    ./features/desktop/hyprland
    ./features/dev
    ./features/fonts
    ./features/themes
  ];

  home.packages = with pkgs; [
    asciidoctor
    can-utils
    daemontools
    icecream
    slack
  ];

  # Slack is a work tool, so its Hyprland wiring lives with the package rather
  # than in the shared desktop features.
  wayland.windowManager.hyprland.settings = {
    exec-once = [ "slack" ];

    windowrule = [
      {
        name = "slack";
        match = {
          # Electron reports "Slack" under Wayland but "slack" via XWayland.
          class = "(?i)slack";
        };
        workspace = "8";
      }
    ];
  };

  systemd.user.services.mdmd = {
    Unit = {
      Description = "Munic Device Manager Daemon";

      # Ask for graphical interface and the dbus socket.
      Wants = "graphical-session.target dbus.socket mdmd.socket xdg-desktop-autostart.target";
      After = "graphical-session.target dbus.socket mdmd.socket xdg-desktop-autostart.target";
    };
    Service = {
      Sockets = "mdmd.socket";
      StandardInput = "socket";
      StandardError = "journal";
      Environment = [
        "PATH=/run/wrappers/bin/:${config.home.profileDirectory}/bin/:/run/current-system/sw/bin/"
        "TERM=alacritty"
      ];
      ExecStart = "${config.home.homeDirectory}/mdmd/target/debug/mdmd";
      Type = "simple";
      Restart = "always";
      RestartSec = "1s";
      TimeoutSec = "180";
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.sockets.mdmd = {
    Socket = {
      ListenFIFO = "%t/mdmd/mdmd.stdin";
      Service = "mdmd.service";
    };
    Install.WantedBy = [ "sockets.target" ];
  };
}
