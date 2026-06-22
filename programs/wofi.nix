{ config, lib, pkgs, ... }:

{
  programs.wofi = {
    enable = true;
    settings = {
      prompt = "";
      insensitive = true;
    };
    style = with config.theme; ''
      window {
        background-color: #${colors.bg_dark};
        margin: 0px;
        border: 1px solid #${colors.purple};
        border-radius: 5px;
        font-family: Hack Nerd Font;
        font-size: 13px;
      }

      #input {
        margin: 5px;
        color: #${colors.fg};
        background-color: #${colors.bg};
      }

      #inner-box {
        background-color: #${colors.bg_dark};
        margin: 5px;
      }

      #outer-box {
        margin: 5px;
        background-color: #${colors.bg_dark};
      }

      #text {
        margin: 3px;
        color: #${colors.fg};
      } 

      #entry:selected {
        background-color: #${colors.bg_selection};
      }

      #text:selected {
        background-color: #${colors.bg_selection};
      }
    '';
  };
}
