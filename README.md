# The `uninormalize` package

The purpose of this package is to provide Unicode normalization for LuaLaTeX. It is based on  Arthur Reutenauer's 
[code for GSOC 2008](https://code.google.com/p/google-summer-of-code-2008-tex/downloads/list), which was adapted a little bit to work with
current `Luaotfload`. For more information, see [this question on TeX.sx](http://tex.stackexchange.com/q/229044/7712).

## What does that mean?

Citing [Wikipedia](https://en.wikipedia.org/wiki/Unicode_equivalence):

> Unicode equivalence is the specification by the Unicode character encoding
> standard that some sequences of code points represent essentially the same
> character. This feature was introduced in the standard to allow compatibility
> with preexisting standard character sets, which often included similar or
> identical characters.
>
> Unicode provides two such notions, canonical equivalence and compatibility.
> Code point sequences that are defined as canonically equivalent are assumed to
> have the same appearance and meaning when printed or displayed. For example,
> the code point `U+006E` (the Latin lowercase "n") followed by `U+0303` (the
> combining tilde) is defined by Unicode to be canonically equivalent to the
> single code point `U+00F1` (the lowercase letter "ñ" of the Spanish alphabet). 

## Basic usage


    \documentclass{article}
    \usepackage{fontspec}
    \usepackage[czech]{babel}
    \setmainfont{Linux Libertine O}
    \usepackage{uninormalize}
    \begin{document}
    
    Some tests:
    \begin{itemize}
      \item combined letter ᾳ %GREEK SMALL LETTER ALPHA (U+03B1) 
                              % + COMBINING GREEK YPOGEGRAMMENI 
                              % (U+0345)
      \item normal letter ᾳ   % GREEK SMALL LETTER ALPHA WITH 
                              %YPOGEGRAMMENI (U+1FB3)
    \end{itemize}
    
    Some more combined and normal letters: 
    óóōōöö
    
    Linux Libertine does support some combined chars: \parbox{4em}{příliš}

    Using the \verb|^^^^| syntax: ^^^^0061^^^^0301 ^^^^0041^^^^0301
    \end{document}

## Package options

This package has three options:


- **buffer**  -- normalize processed document at the moment when it's
  source file is read, before processing by \TeX\ starts. This is the default
  option, it seems to work better than the next one.
- **nodes** -- normalize LuaTeX nodes. Normalization happens after the full processiny by \TeX. 
- **debug** -- print debug messages to the terminal output

Both **buffer** and **nodes** options are enabled by default, you can disable any of them by using:

    \usepackage[nodes=false,buffer=false]{uninormalize}
