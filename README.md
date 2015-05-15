# The `uninormalize` package

The purpose of this package is to provide unicode normalization for LuaLaTeX. It is based on  Arthur Reutenauer's 
[code for GSOC 2008](https://code.google.com/p/google-summer-of-code-2008-tex/downloads/list), which was adapted a little bit to work with
current `Luaotfload`. For more information, see [this question on TeX.sx](https://code.google.com/p/google-summer-of-code-2008-tex/downloads/list).

## Basic usage


    \documentclass{article}
    \usepackage{fontspec}
    \usepackage[czech]{babel}
    \setmainfont{Linux Libertine O}
    \usepackage{uninormalize}
    \begin{document}
    
    Some tests:
    \begin{itemize}
      \item combined letter ᾳ %GREEK SMALL LETTER ALPHA (U+03B1) + COMBINING GREEK YPOGEGRAMMENI (U+0345)
      \item normal letter ᾳ% GREEK SMALL LETTER ALPHA WITH YPOGEGRAMMENI (U+1FB3)
    \end{itemize}
    
    Some more combined and normal letters: 
    óóōōöö
    
    Linux Libertine does support some combined chars: \parbox{4em}{příliš}
    \end{document}

This package does have three options:


- buffer - normalize processed document when it is read from disk. This is the default option and seems to work better than the other one.
- nodes - normalize LuaTeX nodes. This unfortunatelly doesn't work well, because sometimes the input characters are changed before this stage, 
  probably by font processing. 
- debug - print debug messages to the terminal output
