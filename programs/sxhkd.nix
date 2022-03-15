{
  services.sxhkd = {
    enable = true;
    keybindings = {
      # BSPWM
      "super + alt + {q,r}" = # Quit/Restart
        "bspc {quit,wm -r}";
      "super + {_,shift + }q" = # Close/Kill node
        "bspc node -{c,k}";
      "super + m" = # Toggle monocle
        "bspc desktop -l next";
      "super + {t,shift + t,s,f}" = # Node state
        "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
      "super + ctrl + {m,x,y,z}" = # Node flags
        "bspc node -g {marked,locked,sticky,private}";
      "super + {_,shift + }{h,j,k,l}" = # Focus/Swap node(s)
        "bspc node -{f,s} {west,south,north,east}";
      "super + {_,shift + }c" = # Focus next/previous node
        "bspc node -f {next,prev}.local.!hidden.window";
      "super + {grave,Tab}" = # Focus last node/desktop
        "bspc {node,desktop} -f last";
      "super + {_,shift + }{1,2,3,4,5,6,7,8,9,0}" = # Focus/Send to desktop
        "bspc {desktop -f,node -d} '{1,2,3,4,5,6,7,8,9,10}'";
      "super + ctrl + {h,j,k,l}" = # Preselect direction
        "bspc node -p {west,south,north,east}";
      "super + ctrl + {1-9}" = # Preselect ratio
        "bspc node -o 0.{1-9}";
      "super + ctrl + space" = # Cancel preselection
        "bspc node -p cancel";
      "super + alt + {h,j,k,l}" = # Resize outward
        "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
      "super + alt + shift + {h,j,k,l}" = # Resize inward
        "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
      "super + {Left,Down,Up,Right}" = # Move floating node
        "bspc node -v {-20 0,0 20,0 -20,20 0}";

      # Audio
      "XF86AudioRaiseVolume" = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume" = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioMute" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "XF86AudioPlay" = "playerctl play-pause";
      "XF86AudioNext" = "playerctl next";
      "XF86AudioPrev" = "playerctl previous";
      "XF86AudioStop" = "playerctl stop";

      # Brightness
      "XF86MonBrightnessUp" = "brightnessctl set 5%+";
      "XF86MonBrightnessDown" = "brightnessctl set 5%-";

      # Terminal
      "super + Return" = "alacritty";

      # Rofi
      "super + d" = "rofi -show drun -modi drun -show-icons";
      "super + F12" = "rofi -show emoji -modi emoji";
      "super + x" = "rofi -show power-menu -modi power-menu:rofi-power-menu";

      # Toggle status bar
      "super + shift + b" = "polybar-msg cmd toggle";

      # Invoke screenshot utility
      "Print" = "flameshot gui";
      "super + shift + s" = "flameshot gui";

      # Dual scren
      "super + p" = "~/.scripts/monitor_layout.sh";

      "shift + alt" = "~/.scripts/keyboard_layout.sh";
    };
  };
}
