{ pkgs }:

pkgs.writeShellApplication {
  name = "window-state.sh";
  runtimeInputs = with pkgs; [
    jq
  ];
  text = ''
    fullscreen=$(hyprctl -j activewindow | jq '.fullscreen')
    floating=$(hyprctl -j activewindow | jq '.floating')
    pinned=$(hyprctl -j activewindow | jq '.pinned')

    icon=""
    if [ "$fullscreen" != "0" ]; then
        icon=""
    elif [ "$pinned" = "true" ]; then
        icon=""
    elif [ "$floating" = "true" ]; then
        icon=""
    fi

    echo "$icon"
  '';
}
