{ config, lib, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';

    shellAbbrs = {
      la = "ls -a";
      ll = "ls -la";

      vim = "nvim";

      ccf =
        "gcc -Wextra -Wall -Werror -std=c99 -pedantic -fsanitize=address -o main";
      cppf = "g++ -Wextra -Wall -Werror -std=c++17 -pedantic -o main";
      valgrind-full =
        "valgrind --leak-check=full --show-leak-kinds=all --leak-resolution=high --track-origins=yes --vgdb=yes";

      gd = "git diff";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
    };

    shellAliases = {
      gl = "git log --all --decorate --oneline --graph --color=always";
      gs = "git status -s";
      gsw = "git switch";

      zathura = "zathura --fork";

      nix-shell = "nix-shell --command fish";

      rm = "rm -I";
      mv = "mv -i";
      cp = "cp -i";
    };

    plugins = [{
      name = "z";
      src = pkgs.fetchFromGitHub {
        owner = "jethrokuan";
        repo = "z";
        rev = "45a9ff6d0932b0e9835cbeb60b9794ba706eef10";
        sha256 = "pWkEhjbcxXduyKz1mAFo90IuQdX7R8bLCQgb0R+hXs4=";
      };
    }];
  };
}
