{ emacs-package, ... }:

{
  programs.emacs = {
    enable = true;
    package = emacs-package;
  };
}
