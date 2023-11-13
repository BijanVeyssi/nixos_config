#! /run/current-system/sw/bin/bash

ENTRIES="Cancel Clone Right Left Above Off"

PRIMARY="eDP-1"
SECONDARY="HDMI-1"

PRIMARY_INFOS=$(xrandr | grep -C 1 "$PRIMARY")
SECONDARY_INFOS=$(xrandr | grep -C 1 "$SECONDARY")

PRIMARY_MODE=$(echo "$PRIMARY_INFOS" | sed --expression='s/[[:space:]]*\([0-9]\+x[0-9]\+\).*/\1/g' | tail -1)
SECONDARY_MODE=$(echo "$SECONDARY_INFOS" | sed --expression='s/[[:space:]]*\([0-9]\+x[0-9]\+\).*/\1/g' | tail -1)

PRIMARY_RATE=$(echo "$PRIMARY_INFOS" | sed --expression='s/[[:space:]]*[0-9]\+x[0-9]\+[[:space:]]*\([0-9]\+\).*/\1/g' |tail -1)
SECONDARY_RATE=$(echo "$SECONDARY_INFOS" | sed --expression='s/[[:space:]]*[0-9]\+x[0-9]\+[[:space:]]*\([0-9]\+\).*/\1/g' |tail -1)

SEL="$(printf '%s\n' $ENTRIES | rofi -dmenu -p "Monitor Setup:" -i)"

if [ -z "$SEL" ] || [ "$SEL" = "Cancel" ]; then
    exit 0
fi

pkill .polybar-wrappe
bspc config bottom_padding 0
bspc config top_padding 0
bspc config right_padding 0
bspc config left_padding 0

if [ "$SEL" = "Off" ]; then
    xrandr --output "$PRIMARY" --primary \
           --output "$SECONDARY" --off
    bspc monitor "$PRIMARY" -d 1 2 3 4 5 6 7 8 9 10
    bspc monitor "$SECONDARY" -r
    bspc wm --adopt-orphans
    polybar mainbar &
    feh --bg-fill ~/.config/nixos_config/background.jpg
elif [ "$SEL" = "Clone" ]; then
    xrandr --output "$PRIMARY" --primary --mode "$PRIMARY_MODE" --rate "$PRIMARY_RATE" \
           --output "$SECONDARY" --mode "$SECONDARY_MODE" --rate "$SECONDARY_RATE"
    polybar mainbar &
    feh --bg-fill ~/.config/nixos_config/background.jpg
else
    case "$SEL" in
        "Above")
            xrandr --output "$PRIMARY" --primary --mode "$PRIMARY_MODE" --rate "$PRIMARY_RATE" \
                   --output "$SECONDARY" --mode "$SECONDARY_MODE" --rate "$SECONDARY_RATE" --above "$PRIMARY"
            ;;
        "Right")
            xrandr --output "$PRIMARY" --primary --mode "$PRIMARY_MODE" --rate "$PRIMARY_RATE" \
                   --output "$SECONDARY" --mode "$SECONDARY_MODE" --rate "$SECONDARY_RATE" --right-of "$PRIMARY"
            ;;
        "Left")
            xrandr --output "$PRIMARY" --primary --mode "$PRIMARY_MODE" --rate "$PRIMARY_RATE" \
                   --output "$SECONDARY" --mode "$SECONDARY_MODE" --rate "$SECONDARY_RATE" --left-of "$PRIMARY"
            ;;
        *)
            exit 1
            ;;
    esac
    bspc monitor "$PRIMARY" -d 1 7 8 9 10
    bspc monitor "$SECONDARY" -d 2 3 4 5 6
    polybar bottom_bar &
    polybar top_bar &
    feh --bg-fill ~/.config/nixos_config/background.jpg
fi
