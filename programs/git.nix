{ pkgs, ...}:

{
  programs.git = {
    enable = true;
    userEmail = "bijan.veyssi-galmiche@epita.fr";
    userName = "bijan.veyssi-galmiche";
    signing = {
        signByDefault = false;
        key = "055C32062C20D8AD471CC9F9905BB3EB3013C88F";
    };
    extraConfig = {
        pull = {
            ff = "only";
            rebase = true;
        };
    };
  };
}
