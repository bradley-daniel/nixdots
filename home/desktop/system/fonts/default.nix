{pkgs, ...}: {

  home.packages = with pkgs; [
    nerdfix # Fix obsolete nerd font icons
    noto-fonts
    dejavu_fonts
    font-awesome
    fira-code-symbols
    powerline-symbols
    material-design-icons

    # fonts.nerd-fonts.IBMPlexMono
    # fonts.nerd-fonts.CascadiaCode
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono
    # fonts.nerd-fonts.IntelOneMono

    # (nerdfonts.override {fonts = ["IBMPlexMono" "CascadiaCode" "FiraCode" "FiraMono" "JetBrainsMono" "IntelOneMono"];})
  ];
}
