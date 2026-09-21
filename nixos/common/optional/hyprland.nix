{ pkgs, ... }:

{
  # Enable the wayland windowing system.
  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
  };

  # The HDMI link drops every ~8s under aquamarine's atomic modesetting while
  # being stable under Xorg's legacy KMS on the same cable. Force legacy.
  environment.sessionVariables.AQ_DRM_NO_ATOMIC = "1";

  # Graphical greeter, which also drives both outputs from boot.
  services.displayManager.regreet.enable = true;

  # regreet runs under cage, which is wlroots rather than aquamarine, so it
  # needs the wlroots spelling of the flag above or the greeter flaps too.
  systemd.services.greetd.environment.WLR_DRM_NO_ATOMIC = "1";

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
