# vid

A minimal vi-like text editor for the terminal written in Dart 😎
 
> Note: for fun and learning; not meant to replace your current editor ;)

## Features 📋

- a minimal fast modal vi-like text editor for the terminal ⚡️
- correct rendering, editing and cursor movement of emojis and EastAsianWide ❤️‍🔥
- made for modern terminals that supports [mode 2027](https://github.com/contour-terminal/terminal-unicode-core) (e.g. [Ghostty](https://github.com/mitchellh/ghostty/), [WezTerm](https://github.com/wez/wezterm), [Contour](https://github.com/contour-terminal/contour)) 🧠
- written in pragmatic Dart only depending on the [characters](https://pub.dev/packages/characters) package ✨
- unlimited undo ↩️

## Non-goals ❌

- no syntax highlighting (we just use terminal bg / fg colors)
- no plugins (let's keep things minimal)
- no window manager (open a new tab or use terminal split features)
- no 100 % vim compat (we only support a minimal subset)
- no pre-built binaries (just [build](build.sh) it yourself)

## Keyboard shortcuts ↔️

See [bindings.dart](lib/bindings.dart)

Note the following keybindings differ from **vim** as we don't have command mode yet; also i quite like these bindings:

- Save with 's'
- Quit with 'q' or force quit with 'Q' (ignoring changes)

## Contribute 🙋‍♂️

While this is a personal project and i prefer tackling challenges on my own, I welcome thoughtful PR's that align with the editors minimal philosophy.

I do not accept issues solely for suggestions, but meaningful code contributions are appreciated. Thanks! 🚀
