{
  # inputs,
  pkgs,
  ...
}: let
  active_border = "rgba(b4befecc)";
  inactive_border = "rgba(1e1e2ecc)";
  animation_spead = "0.5";
in {
  wayland.windowManager.hyprland = {
    package = pkgs.hyprland;
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      "$mainMod" = "SUPER";
      monitor = [
        "DP-1,highres,1920x0,1"
        "DP-2,1920x1200,0x0,1"
      ];
      xwayland = {
        force_zero_scaling = true;
      };
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = "yes";
        };

        repeat_rate = 50;
        repeat_delay = 200;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };
      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 2;
        "col.active_border" = "${active_border}";
        "col.inactive_border" = "${inactive_border}";
        layout = "dwindle";
        apply_sens_to_raw = 1; # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
      };
      decoration = {
        rounding = 0;
        shadow_ignore_window = true;
        drop_shadow = false;
        shadow_range = 20;
        shadow_render_power = 3;
        # "col.shadow" = "rgb(${oxocarbon_background})";
        # "col.shadow_inactive" = "${background}";
        blur = {
          enabled = false;
          #   size = 5;
          #   passes = 3;
          #   new_optimizations = true;
          ignore_opacity = false;
          #   noise = 0.0117;
          #   contrast = 1.5;
          #   brightness = 1;
          #   xray = true;
        };
      };
      animations = {
        enabled = true;
        bezier = [
          "pace,0.46, 1, 0.29, 0.99"
          "overshot,0.13,0.99,0.29,1.1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
        ];
        animation = [
          "windowsIn,1,${animation_spead},md3_decel,slide"
          "windowsMove,1,${animation_spead},md3_decel,slide"
          "fade,1,${animation_spead},md3_decel"
          "workspaces,1,${animation_spead},md3_decel,slide"
          "workspaces, 1, ${animation_spead}, default"
          "specialWorkspace,1,${animation_spead},md3_decel,slide"
          "border,1,${animation_spead},md3_decel"
        ];
      };
      dwindle = {
        pseudotile = true; # enable pseudotiling on dwindle
        force_split = 0;
        preserve_split = true;
        default_split_ratio = 1.0;
        no_gaps_when_only = false;
        special_scale_factor = 0.8;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
      };

      master = {
        mfact = 0.5;
        orientation = "right";
        special_scale_factor = 0.8;
        new_is_master = true;
        no_gaps_when_only = false;
      };

      gestures = {
        workspace_swipe = false;
      };

      debug = {
        damage_tracking = 2; # leave it on 2 (full) unless you hate your GPU and want to make it suffer!
      };

      exec-once = [
        "swww init && swww img ~/Wallpapers/tree-person-standing.png"
        "dunst"
        "waybar"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];
      bind = [
        "$mainMod, Q, exec, alacritty"
        "$mainMod, B, exec, firefox"
        "$mainMod, C, killactive"
        "$mainMod, M, exit"
        "$mainMod, V, togglefloating"
        "$mainMod, R, exec, rofi -show drun -show-icons"
        "$mainMod, P, pseudo"
        "$mainMod, A, togglesplit"
        "$mainMod, F, fullscreen"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod SHIFT, 9, movetoworkspace, 9"

        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
      ];

      bindm = [
        "$mainMod, mouse:273, resizewindow"
        "$mainMod, mouse:272, movewindow"
      ];

      windowrulev2 = [
        "stayfocused, title:^()$,class:^(steam)$"
        "minsize 1 1, title:^()$,class:^(steam)$"
        "stayfocused, title:^()$,class:^(firefox)$"
        "minsize 1 1, title:^()$,class:^(firefox)$"

        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"
      ];

      workspace = [
        "1,monitor:DP-1,default:true"
        "6,monitor:DP-2,default:true"
      ];
    };
  };
}
