all: uninormalize.pdf

uninormalize.pdf: uninormalize.tex readme.tex
	lualatex uninormalize.tex

readme.tex: README.md
	pandoc -t latex README.md > readme.tex
