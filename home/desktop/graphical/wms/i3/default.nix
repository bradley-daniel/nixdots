{
  config,
  lib,
  pkgs,
  ...
}: let
  mod = "Mod4";
in {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifer = mod;
        fonts = [""];
    };
  };
}
