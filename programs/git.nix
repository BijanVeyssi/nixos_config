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
      key = "9C3052F0860EFA47F251FF4C6BA2C997FA537282";
    };
    extraConfig = {
      pull = {
        rebase = true;
      };
    };
  };
}
