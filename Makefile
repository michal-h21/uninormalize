package_name = uninormalize
doc_source = uninormalize-doc.tex
doc_dist = uninormalize-doc.pdf
build_files = README.md unicode-normalization.lua unicode-normalize-names.lua unicode-normalize.lua uninormalize.sty $(doc_source) $(doc_dist)
build_dir = build
dist_file = $(package_name).zip
dist_dir = $(build_dir)/$(package_name)


all: $(doc_dist)

uninormalize-doc.pdf: $(doc_source) README.md
	lualatex $<

.Phony: build

build: $(doc_dist)
	@rm -rf $(build_dir)
	@mkdir -p build/uninormalize
	@cp $(build_files) $(dist_dir)
	@cd $(build_dir) && zip -r $(dist_file) $(package_name)


