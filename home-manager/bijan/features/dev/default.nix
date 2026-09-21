{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bear
    black
    clang-tools
    cmake
    gcc
    gnumake
    go
    lua-language-server
    markdownlint-cli
    neovim
    nil
    nix-search-cli
    nixfmt
    pandoc
    pre-commit
    shellcheck
    stylua
    texlab
    texliveFull
  ];
}
