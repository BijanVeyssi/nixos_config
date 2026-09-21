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

  wayland.windowManager.hyprland.settings = {
    # The legacy KMS this host is pinned to cannot pass a hotspot to the
    # hardware cursor plane, so composite the cursor in software instead.
    cursor.no_hardware_cursors = true;

    # The external screen sits to the left of the built-in panel.
    "$MONITOR_L" = "HDMI-A-1";
    "$MONITOR_R" = "eDP-1";

    monitor = [
      "$MONITOR_L,preferred,auto-left,1"
      "$MONITOR_R,preferred,auto,1"
    ];

    workspace = [
      "1  ,monitor:$MONITOR_R,persistent:true,default:true"
      "2  ,monitor:$MONITOR_L,persistent:true,default:true"
      "3  ,monitor:$MONITOR_L,persistent:true,default:true"
      "4  ,monitor:$MONITOR_L,persistent:true,default:true"
      "5  ,monitor:$MONITOR_L,persistent:true,default:true"
      "6  ,monitor:$MONITOR_L,persistent:true,default:true"
      "7  ,monitor:$MONITOR_R,persistent:true,default:true"
      "8  ,monitor:$MONITOR_R,persistent:true,default:true"
      "9  ,monitor:$MONITOR_R,persistent:true,default:true"
      "10 ,monitor:$MONITOR_R,persistent:true,default:true"
      "11 ,monitor:$MONITOR_L,persistent:true,default:true"
      "12 ,monitor:$MONITOR_L,persistent:true,default:true"
      "13 ,monitor:$MONITOR_L,persistent:true,default:true"
      "14 ,monitor:$MONITOR_L,persistent:true,default:true"
      "15 ,monitor:$MONITOR_L,persistent:true,default:true"
      "16 ,monitor:$MONITOR_L,persistent:true,default:true"
      "17 ,monitor:$MONITOR_L,persistent:true,default:true"
      "18 ,monitor:$MONITOR_L,persistent:true,default:true"
      "19 ,monitor:$MONITOR_L,persistent:true,default:true"
      "20 ,monitor:$MONITOR_L,persistent:true,default:true"
    ];

    # Slack is a work tool, so its Hyprland wiring lives with the package rather
    # than in the shared desktop features.
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
