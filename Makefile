all: uninormalize.pdf

uninormalize.pdf: uninormalize.tex README.md
	lualatex uninormalize.tex

