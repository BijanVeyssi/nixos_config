{ pkgs, ...}:

{
  programs.git = {
    enable = true;
    userEmail = "bijan.veyssi-galmiche@epita.fr";
    userName = "bijan.veyssi-galmiche";
    signing = {
        signByDefault = true;
        key = "055C32062C20D8AD471CC9F9905BB3EB3013C88F";
    };
    extraConfig = {
        pull = {
            rebase = true;
        };
    };
  };
}
