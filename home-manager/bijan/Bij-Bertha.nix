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

  wayland.windowManager.hyprland.settings = {
    # The hardware cursor plane misplaces the pointer hotspot here: the text
    # cursor selects from its top-left corner rather than its centre, and the
    # pointer vanishes whenever it stops moving. Composite it in software.
    cursor.no_hardware_cursors = true;

    # The external screen sits to the left of the built-in panel. The shared
    # hyprland feature maps workspaces onto these two names.
    "$MONITOR_L" = "DP-5";
    "$MONITOR_R" = "DP-4";

    monitor = [
      "$MONITOR_L,preferred,auto-left,1"
      "$MONITOR_R,preferred,auto,1"
    ];

    workspace = [
      "1  ,monitor:$MONITOR_L,persistent:true,default:true"
      "2  ,monitor:$MONITOR_R,persistent:true,default:true"
      "3  ,monitor:$MONITOR_R,persistent:true,default:true"
      "4  ,monitor:$MONITOR_R,persistent:true,default:true"
      "5  ,monitor:$MONITOR_R,persistent:true,default:true"
      "6  ,monitor:$MONITOR_R,persistent:true,default:true"
      "7  ,monitor:$MONITOR_L,persistent:true,default:true"
      "8  ,monitor:$MONITOR_L,persistent:true,default:true"
      "9  ,monitor:$MONITOR_L,persistent:true,default:true"
      "10 ,monitor:$MONITOR_L,persistent:true,default:true"
      "11 ,monitor:$MONITOR_R,persistent:true,default:true"
      "12 ,monitor:$MONITOR_R,persistent:true,default:true"
      "13 ,monitor:$MONITOR_R,persistent:true,default:true"
      "14 ,monitor:$MONITOR_R,persistent:true,default:true"
      "15 ,monitor:$MONITOR_R,persistent:true,default:true"
      "16 ,monitor:$MONITOR_R,persistent:true,default:true"
      "17 ,monitor:$MONITOR_R,persistent:true,default:true"
      "18 ,monitor:$MONITOR_R,persistent:true,default:true"
      "19 ,monitor:$MONITOR_R,persistent:true,default:true"
      "20 ,monitor:$MONITOR_R,persistent:true,default:true"
    ];
  };

  programs.git = {
    enable = true;
    settings = {
      user.email = "bijan@veyssi.com";
      user.name = "Bijan VEYSSI";
      signing = {
        key = "1266060BB6B7E2CC734DE81407413967E61B8129";
      };
      tag.gpgSign = true;
      commit.gpgSign = true;
      extraConfig = {
        pull = {
          rebase = true;
        };
      };
    };
  };
}
