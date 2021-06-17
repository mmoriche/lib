# To define the dependency properly with bibdata.bib, do not use the extension
# .bib in the main.tex file

.DEFAULT_GOAL = doc

SHELL := /bin/bash --init-file $(GITHUB_PATH)/WORK/lib/bashfiles/getextrapath.sh 
EXTRADIR = $(shell getextrapath ${GITHUB_PATH})
BASENM = $(shell basename $(EXTRADIR))
ifdef SUFFIX
   ODIR=$(DROPBOX_PATH)/$(EXTRADIR)/$(BASENM)$(SUFFIX)
else
   ODIR=$(DROPBOX_PATH)/$(EXTRADIR)/$(BASENM)
endif


LATEXMK=latexmk
PDFLATEX=pdflatex
LABEL = $(shell basename ${PWD})
JOB = "aux/$(LABEL)-paper"

# CUSTOM BUILD RULES
# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.

# -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# --shell-escape allows pdflatex to write in the direcgtory, generating
#  eps-converted-to.pdf files
# missing file reference and interactively asking you for an alternative.

BUILDFLAGS = -pdflatex="$(PDFLATEX)  -synctex=1 --shell-escape -interaction=nonstopmode"   \
             -use-make --shell-escape

BIBFLAGS = -bibtex

#FEX=-deps  # use this to see dependencies
#FEX=

dir: 
	if ! [ -d "aux" ]; then mkdir aux; fi

doc: main.tex dir
	@echo ""
	@echo ""
	@echo ""
	($(LATEXMK)  -pdf -jobname=aux/job $(BUILDFLAGS) $(BIBFLAGS) $(FEX) $< && \
         cp aux/job.pdf $(ODIR).pdf)
	@echo -e "Congratulations! File \033[7;35m$(ODIR).pdf \033[0m built"
	@echo ""
	#@if [ -d "/tmp" ] ; then cp aux/job.pdf /tmp/ ; fi
	@echo ""

compress:
	gs -sDEVICE=pdfwrite -dPDFSETTINGS=/default -q -o $(ODIR)_comp.pdf $(ODIR).pdf

clean:
	$(LATEXMK) -c -jobname=aux/job main.tex
	if [ -f $(SCREEN) ]; then rm $(SCREEN); fi

