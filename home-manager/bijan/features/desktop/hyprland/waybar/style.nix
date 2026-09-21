colors:

''
  /* Reset all styles */
  * {
    border: none;
    border-radius: 5px;
    min-height: 0;
    margin: 0.2em 0.3em 0.2em 0.3em;
  }

  /* The whole bar */
  #waybar {
    background: #${colors.bg_darker};
    font-family: "IosevkaNerdFont";
    font-size: 13px;
    font-weight: bold;
  }

  tooltip {
    background: #${colors.bg_darker}
  }

  tooltip label {
    color: #${colors.fg};
  }

  /* Modules */

  box.module {
    margin-left: 0;
    margin-right: 0;
  }

  label.module {
    background: #${colors.bg_dark};
    padding-left: 0.6em;
    padding-right: 0.6em;
  }

  #workspaces {
    background: #${colors.bg_dark};
    padding-right: 0.6em;
  }

  #workspaces button {
    margin: 0 0.2em;
    padding: 0;
    color: #${colors.purple};
  }

  #workspaces button.empty {
    color: #${colors.comment};
  }

  #workspaces button.active {
    color: #${colors.fg};
  }

  #workspaces button:hover {
    box-shadow: none;
  }

  #custom-window-state {
    margin: 0;
    background: none;
    color: #${colors.fg_dark};
  }

  #mpris {
    color: #${colors.green};
  }

  #custom-kblayout {
    margin: 0;
    background: none;
    color: #${colors.fg_dark}
  }

  #clock {
    color: #${colors.red};
  }

  #wireplumber {
    color: #${colors.yellow};
  }

  #backlight {
    color: #${colors.magenta};
  }

  #battery {
    color: #${colors.blue};
  }
''
