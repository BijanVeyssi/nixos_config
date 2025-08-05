{ pkgs, ... }:

{
  programs.git = {
    lfs = {
      enable = true;
    };
    enable = true;
    userEmail = "bijan@veyssi.com";
    userName = "Bijan Veyssi";
    signing = {
      signByDefault = true;
      key = "82944C5317A1CBB0BF42E5A19EAA8A7A13908C6B";
    };
    extraConfig = {
      pull = {
        rebase = true;
      };
    };
  };
}
