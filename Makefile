all: uninormalize.pdf

uninormalize.pdf: uninormalize.tex
	lualatex uninormalize.tex

uninormalize.tex: README.md
	pandoc -t latex README.md > readme.tex
