# Zen Mode

A simple emacs package for distraction free editing.

![Zen Experience](zen.png)

## Installation

Place the [zen-mode.el](zen-mode.el) file in the `load-path`, and in your configuration

```lisp
(require 'zen-mode)
```

To add a key binding, do the following :

```lisp
(global-set-key (kbd "C-M-z") 'zen-mode)
```

or just run `M-x zen-mode`

*Solarized themes look good*
