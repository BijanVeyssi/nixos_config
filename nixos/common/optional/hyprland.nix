{ pkgs, ... }:

{
  # Enable the wayland windowing system.
  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
  };

  # Graphical greeter, which also drives both outputs from boot.
  services.displayManager.regreet.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # PAM service used by betterlockscreen's i3lock-color (configured per-user
  # via home-manager's services.screen-locker).
  security.pam.services.i3lock.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    pavucontrol
    qutebrowser
  ];
}
