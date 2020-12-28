build_files = 
all: uninormalize.pdf

uninormalize.pdf: uninormalize.tex README.md
	lualatex uninormalize.tex

.Phony: build

build: uninormalize.pdf
	mkdir -p build/uninormalize
	cp


