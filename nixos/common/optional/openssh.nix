{ ... }:

{
  services.openssh = {
    enable = true;
    extraConfig = ''
      PasswordAuthentication no
    '';
  };
}
