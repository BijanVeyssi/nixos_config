{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    bind = [
      # Close active window
      "$mod, Q, killactive"

      # Select workspace
      "$mod, 1,         workspace, 1"
      "$mod, 2,         workspace, 2"
      "$mod, 3,         workspace, 3"
      "$mod, 4,         workspace, 4"
      "$mod, 5,         workspace, 5"
      "$mod, 6,         workspace, 6"
      "$mod, 7,         workspace, 7"
      "$mod, 8,         workspace, 8"
      "$mod, 9,         workspace, 9"
      "$mod, 0,         workspace, 10"
      "$mod, KP_End,    workspace, 11"
      "$mod, KP_Down,   workspace, 12"
      "$mod, KP_Next,   workspace, 13"
      "$mod, KP_Left,   workspace, 14"
      "$mod, KP_Begin,  workspace, 15"
      "$mod, KP_Right,  workspace, 16"
      "$mod, KP_Home,   workspace, 17"
      "$mod, KP_Up,     workspace, 18"
      "$mod, KP_Prior,  workspace, 19"
      "$mod, KP_Insert, workspace, 20"

      # Previous workspace
      "$mod, tab, workspace, previous"

      # Move window to workspace, do not switch workspace
      "$mod SHIFT, 1,           movetoworkspacesilent, 1"
      "$mod SHIFT, 2,           movetoworkspacesilent, 2"
      "$mod SHIFT, 3,           movetoworkspacesilent, 3"
      "$mod SHIFT, 4,           movetoworkspacesilent, 4"
      "$mod SHIFT, 5,           movetoworkspacesilent, 5"
      "$mod SHIFT, 6,           movetoworkspacesilent, 6"
      "$mod SHIFT, 7,           movetoworkspacesilent, 7"
      "$mod SHIFT, 8,           movetoworkspacesilent, 8"
      "$mod SHIFT, 9,           movetoworkspacesilent, 9"
      "$mod SHIFT, 0,           movetoworkspacesilent, 10"
      "$mod SHIFT, KP_End,      movetoworkspacesilent, 11"
      "$mod SHIFT, KP_Down,     movetoworkspacesilent, 12"
      "$mod SHIFT, KP_Next,     movetoworkspacesilent, 13"
      "$mod SHIFT, KP_Left,     movetoworkspacesilent, 14"
      "$mod SHIFT, KP_Begin,    movetoworkspacesilent, 15"
      "$mod SHIFT, KP_Right,    movetoworkspacesilent, 16"
      "$mod SHIFT, KP_Home,     movetoworkspacesilent, 17"
      "$mod SHIFT, KP_Up,       movetoworkspacesilent, 18"
      "$mod SHIFT, KP_Prior,    movetoworkspacesilent, 19"
      "$mod SHIFT, KP_Insert,   movetoworkspacesilent, 20"

      "$mod CTRL SHIFT, J, movecurrentworkspacetomonitor, l"
      "$mod CTRL SHIFT, semicolon, movecurrentworkspacetomonitor, r"

      "$mod, F, fullscreen"
      "$mod, M, fullscreen, 1" # Keep gaps and bar (bspwm monocle mode)
      "$mod, S, togglefloating"

      # Show window on all workspace (floating only)
      "$mod, Y, pin"

      "$mod, J, movefocus, l"
      "$mod, semicolon, movefocus, r"
      "$mod, L, movefocus, u"
      "$mod, K, movefocus, d"

      "$mod SHIFT, J, swapwindow, l"
      "$mod SHIFT, semicolon, swapwindow, r"
      "$mod SHIFT, L, swapwindow, u"
      "$mod SHIFT, K, swapwindow, d"

      # Exit hyprland
      "$mod ALT, Q, exit"

      "$mod, Return, exec, alacritty"
      "$mod SHIFT, Return, exec, ./scripts/mdmc.sh"
      "$mod, D, exec, wofi -I --show drun"
      "$mod, X, exec, wofi-power-menu"

      # Notifications
      "$mod, N, exec, dunstctl action"
      "$mod SHIFT, N, exec, dunstctl close"
      "$mod CTRL SHIFT, N, exec, dunstctl close-all"

      # Clipboard
      "$mod, V, exec, cliphist list | rofi -modi clipboard:/etc/profiles/per-user/bijan/bin/cliphist-rofi -show clipboard -show-icons"
    ];

    binde = [
      "$mod CTRL, J, resizeactive, -10 0"
      "$mod CTRL, semicolon, resizeactive, 10 0"
      "$mod CTRL, L, resizeactive, 0 -10"
      "$mod CTRL, K, resizeactive, 0 10"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    bindel = [
      # Raise/Lower audio volume
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"

      # Raise/Lower brightness
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
    ];

    bindl = [
      # Toggle mute
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

      # Media
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioStop, exec, playerctl stop"
    ];
  };
}
