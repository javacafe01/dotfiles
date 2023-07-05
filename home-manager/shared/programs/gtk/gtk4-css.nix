{ theme, ... }:

with theme.colors;
''
  @define-color surface-strongest #${bg};
  @define-color surface-strong #${lbg};
  @define-color surface-moderate #${c0};
  @define-color surface-weak #${c8};
  @define-color surface-weakest #${c8};

  @define-color white-strongest rgb(255, 255, 255);
  @define-color white-strong #${fg};
  @define-color white-moderate rgba(255, 255, 255, 0.34);
  @define-color white-weak rgba(255, 255, 255, 0.14);
  @define-color white-weakest rgba(255, 255, 255, 0.06);

  @define-color black-strongest rgb(0, 0, 0);
  @define-color black-strong rgba(0, 0, 0, 0.87);
  @define-color black-moderate rgba(0, 0, 0, 0.42);
  @define-color black-weak rgba(0, 0, 0, 0.15);
  @define-color black-weakest rgba(0, 0, 0, 0.06);

  @define-color red-tint #${c7};
  @define-color red-normal #${c7};
  @define-color red-light #${c7};
  @define-color orange-tint #${c1};
  @define-color orange-normal #${c1};
  @define-color orange-light #${c1};
  @define-color yellow-normal #${c11};
  @define-color yellow-light #${c11};
  @define-color green-tint #${c2};
  @define-color green-normal #${c2};
  @define-color green-light #${c2};
  @define-color cyan-normal #${c12};
  @define-color cyan-light #${c12};
  @define-color blue-normal #${c4};
  @define-color blue-light #${c4};
  @define-color purple-normal #${c9};
  @define-color purple-light #${c9};
  @define-color pink-normal #${c5};
  @define-color pink-light #${c5};

  @define-color accent_color #${c4};
  @define-color accent_bg_color #${c6};
  @define-color accent_fg_color @white-strong;

  @define-color destructive_color @red-light;
  @define-color destructive_bg_color @red-tint;
  @define-color destructive_fg_color @white-strong;

  @define-color success_color @green-light;
  @define-color success_bg_color @green-tint;
  @define-color success_fg_color @white-strong;

  @define-color warning_color @orange-light;
  @define-color warning_bg_color @orange-tint;
  @define-color warning_fg_color @white-strong;

  @define-color error_color @red-light;
  @define-color error_bg_color @red-tint;
  @define-color error_fg_color @white-strong;

  @define-color window_bg_color @surface-strong;
  @define-color window_fg_color @white-strong;

  @define-color view_bg_color @surface-strongest;
  @define-color view_fg_color @white-strong;

  @define-color headerbar_bg_color @surface-moderate;
  @define-color headerbar_fg_color @white-strong;
  @define-color headerbar_border_color @surface-moderate;
  @define-color headerbar_backdrop_color transparent;
  @define-color headerbar_shade_color transparent;

  @define-color card_bg_color @white-weakest;
  @define-color card_fg_color @white-strong;
  @define-color card_shade_color @white-weak;

  @define-color dialog_bg_color @surface-weak;
  @define-color dialog_fg_color @white-strong;

  @define-color popover_bg_color @surface-weakest;
  @define-color popover_fg_color @white-strong;

  @define-color shade_color @black-strongest;
  @define-color scrollbar_outline_color @white-weakest;

  @define-color borders transparent;


  window {
      border-bottom-left-radius:  0px;
      border-bottom-right-radius: 0px;
      border-top-left-radius: 0px;
      border-top-right-radius:  0px;
  }

  window contents {
      background: @surface-strongest;
      box-shadow: none;
  }

  popover contents, popover arrow {
  	background: @surface-weakest;
  }

  .solid-csd {
  	padding: 0;
  }

  headerbar {
      padding: 0.3em;
      padding-top: calc(0.3em + 3px);
  }
''
