#! /run/current-system/sw/bin/bash

ENTRIES="Cancel Clone Right Left Above Off"

PRIMARY="eDP-1-1"
SECONDARY="HDMI-0"

PRIMARY_MODE=$(xrandr | grep -C 1 "$PRIMARY" | sed --expression='s/[[:space:]]*\([0-9]\+x[0-9]\+\).*/\1/g' | tail -1)
SECONDARY_MODE=$(xrandr | grep -C 1 "$SECONDARY" | sed --expression='s/[[:space:]]*\([0-9]\+x[0-9]\+\).*/\1/g' | tail -1)

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
    feh --bg-fill  ~/Pictures/ror2.jpg
elif [ "$SEL" = "Clone" ]; then
    xrandr --output "$PRIMARY" --primary --mode "$PRIMARY_MODE" \
           --output "$SECONDARY" --mode "$SECONDARY_MODE"
    polybar mainbar &
    feh --bg-fill  ~/Pictures/ror2.jpg
else
    case "$SEL" in
        "Above")
            xrandr --output "$PRIMARY" --primary --mode "$PRIMARY_MODE"\
                   --output "$SECONDARY" --mode "$SECONDARY_MODE" --above "$PRIMARY"
            ;;
        "Right")
            xrandr --output "$PRIMARY" --primary --mode "$PRIMARY_MODE" \
                   --output "$SECONDARY" --mode "$SECONDARY_MODE" --right-of "$PRIMARY"
            ;;
        "Left")
            xrandr --output "$PRIMARY" --primary --mode "$PRIMARY_MODE" \
                   --output "$SECONDARY" --mode "$SECONDARY_MODE" --left-of "$PRIMARY"
            ;;
        *)
            exit 1
            ;;
    esac
    bspc monitor "$PRIMARY" -d 2 3 4 5
    bspc monitor "$SECONDARY" -d 1 6 7 8 9 10
    polybar bottom_bar &
    polybar top_bar &
    feh --bg-fill  ~/Pictures/ror2.jpg
fi
