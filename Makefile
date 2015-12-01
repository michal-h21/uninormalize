all: uninormalize.pdf

uninormalize.pdf: uninormalize.tex
	lualatex uninormalize.tex

uninormalize.tex: readme.tex

readme.tex: README.md
	pandoc -t latex README.md > readme.tex
