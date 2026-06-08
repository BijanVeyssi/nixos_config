{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.email = "bijan.veyssi-galmiche@munic.io";
      user.name = "bijan.veyssi-galmiche";
      signing = {
        signByDefault = true;
        key = "0E68FB40CBAC9042223BB153301A84AAF9D9F6A8";
      };
      extraConfig = {
        pull = {
          rebase = true;
        };
      };
    };
  };
}
