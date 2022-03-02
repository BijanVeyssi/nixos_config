{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      battery.disabled = true;

      directory = {
        truncation_length = 0;
        read_only = " ";
      };

      docker_context.symbol = " ";
      lua.symbol = " ";
      python.symbol = " ";
      java.symbol = " ";
      package.symbol = " ";
      perl.symbol = " ";
      ruby.symbol = " ";
      rust.symbol = " ";

      git_status = {
        style = "bold blue";
        conflicted = "[=\${count}](bold red)";
        stashed = "%\${count}"; # Escape sequence broken
        deleted = "[✘ \${count}](bold red)";
        renamed = "[»\${count}](bold yellow)";
        modified = "!\${count}";
        staged = "[+\${count}](bold yellow)";
        untracked = "?\${count}";
        ahead = "\${count}";
        behind = "[\${count}](bold cyan)";
      };
    };
  };
}
