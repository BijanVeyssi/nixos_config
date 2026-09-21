{ ... }:

{
  # Configure keymap in X11
  services.xserver.xkb = {
    options = "caps:escape";
    layout = "us";
  };
  services.xserver.autoRepeatDelay = 220;
  services.xserver.autoRepeatInterval = 35;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
}
