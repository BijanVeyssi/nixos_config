{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "bijan.veyssi-galmiche@mobile-devices.fr";
    userName = "bijan.veyssi-galmiche";
    signing = {
      signByDefault = true;
      key = "302A8DE497948EB4ED4926A2690EDBE5EDA62FC3";
    };
    extraConfig = {
      pull = {
        rebase = true;
      };
    };
  };
}
