{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    rofi-wayland
  ];

  xdg.configFile."rofi/config.rasi".text = ''
    * {
        font: "Figtree 13";
        g-spacing: 10px;
        g-margin: 0;
        b-color: #000000FF;
        fg-color: #cdd6f4FF;
        fgp-color: #888888FF;
        b-radius: 0px;
        g-padding: 8px;
        hl-color: #89b4faaa;
        hlt-color: #000000FF;
        alt-color: #11111baa;
        wbg-color: #080A0Faa;
        w-border: 2px solid;
        w-border-color: #b4befeFF;
        w-padding: 12px;
    }

    configuration {
        modi: "drun";
        show-icons: true;
        display-drun: "";
    }

    listview {
        columns: 1;
        lines: 10;
        fixed-height: true;
        fixed-columns: true;
        cycle: false;
        scrollbar: false;
        border: 0px solid;
    }

    window {
        transparency: "real";
        width: 500px;
        border-radius: @b-radius;
        background-color: @wbg-color;
        border: @w-border;
        border-color: @w-border-color;
        padding: @w-padding;
    }

    prompt {
        text-color: @fg-color;
    }

    inputbar {
        children: ["prompt", "entry"];
        spacing: @g-spacing;
    }

    entry {
        placeholder: "Search Apps";
        text-color: @fg-color;
        placeholder-color: @fgp-color;
    }

    mainbox {
        spacing: @g-spacing;
        margin: @g-margin;
        padding: @g-padding;
        children: ["inputbar", "listview", "message"];
    }

    element {
        spacing: @g-spacing;
        margin: @g-margin;
        padding: @g-padding;
        border: 0px solid;
        border-radius: @b-radius;
        border-color: @b-color;
        background-color: transparent;
        text-color: @fg-color;
    }

    element normal.normal {
    	background-color: transparent;
    	text-color: @fg-color;
    }

    element alternate.normal {
    	background-color: @alt-color;
    	text-color: @fg-color;
    }

    element selected.active {
    	background-color: @hl-color;
    	text-color: @hlt-color;
    }

    element selected.normal {
    	background-color: @hl-color;
    	text-color: @hlt-color;
    }

    message {
        background-color: red;
        border: 0px solid;
    }
  '';
}
