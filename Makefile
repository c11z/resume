.PHONY: pdf

pdf:
	@docker run \
	-v $(CURDIR):/opt/docs \
	auchida/markdown-pdf \
	markdown=pdf \
	-o Cory-Dominguez.pdf Cory-Dominguez.md
