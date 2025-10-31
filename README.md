## A simple yet colorful template for Beamer slides.

The file `example.tex` contains a few frames to show how to use it.
To compile it, simply clone this repository and type `latexmk -pv example`.
This will generate and open the `.pdf` file generated.
A pre-compiled (by CI) `.pdf` file can also be found on [the release page](https://github.com/Mesabloo/beamer-theme/releases/tag/pdf).

## How to use

- Clone this repository somewhere.
- Add the directory of the cloned repository to your `$TEXINPUTS` environment variable.
  
  I personally like to do that on a per-project basis using a `.envrc` file, but this is not required.
- Add the `-recorder` option to the LaTeX engine that you use. 
  This will ensure that the path to `rainbow-beamer.cls` is correctly found, therefore that the included fonts and assets will correctly be included in your presentation.

## Options

- `listings` (default = `{}`): load the `listings` package, apply the default style, and preload some languages.
  This option accepts a comma-separated list of entries of the form `language-name[=file-name]` where
  - `language-name` is the name of the language to be used in the `lstlisting` environment.
    When `language-name` contains square brackets (for example for language flavors), it may be needed to enclose it in curly brackets.
  - `file-name` is an optional `.sty` file (without the extension!) that must be loaded to use the `language-name` in the `lstlisting` environment.
- `fonts/main`, `fonts/sans`, `fonts/mono`, `fonts/math` are font names (all default to `{}`) to be used instead of the default ones.
  
  You can set all these (in the class options) either one by one like 
  ```
  fonts/main=...,
  fonts/sans=...,
  fonts/mono=...,
  fonts/math=...
  ```
  or all at once like 
  ```
  fonts={
    main=...,
    sans=...,
    mono=...,
    math=...
  }
  ```

  Note that you do not necessarily have to set each. 
  You may choose individual aspects to customize (e.g. only the monospace font).

  For more complex customization of fonts (e.g. specifying a bold font to be used), you may pass values of the form`[fontspec-options...]{...}` (necessarily surrounded by braces `{}`).
- `withappendix[=true|false]` (default = `false`) redefines the `\appendix` command to automatically number the appendix frames with letters instead of numbers, and removes them from the total frame count.