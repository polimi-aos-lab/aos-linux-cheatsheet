
# Use: watchman-make -p "*.md" -t all

all: cs.linux.kernel.pdf 

%.pdf: %.md
	 pandoc $< -o $@ --lua-filter ./filters/columns.lua --pdf-engine xelatex

open: cs.linux.kernel.pdf 
	open $<

watch:
	watchman-make -p "*.md" -t all
