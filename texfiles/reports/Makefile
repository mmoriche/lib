# To define the dependency properly with bibdata.bib, do not use the extension # .bib in the main.tex file

.DEFAULT_GOAL = doc

SHELL := /bin/bash --init-file $(GITHUB_PATH)/WORK/lib/bashfiles/getextrapath.sh 

EXTRADIR = $(shell getextrapath ${GITHUB_PATH})

FIG=$(TANK_PATH)/$(EXTRADIR)/figures

LATEXMKRC=$(GITHUB_PATH)/WORK/lib/texfiles/reports/latexmkrc
MAKEFILE=$(GITHUB_PATH)/WORK/lib/texfiles/reports/Makefile
LATEXMK=latexmk -r $(LATEXMKRC)
PDFLATEX=pdflatex

# 0: deliverable report
# 1: internal report
# 2: internal + labels
-include make.inc
#INTERNAL=1

ifeq ($(INTERNAL),2)
   ODIR=$(TANK_PATH)/$(EXTRADIR)_internal
   $(shell sed -i "s|usepackage\[.*\]{myreport}|usepackage[internal,labels]{myreport}|g" main.tex )
endif
ifeq ($(INTERNAL),1)
   ODIR=$(TANK_PATH)/$(EXTRADIR)_internal
   $(shell sed -i "s|usepackage\[.*\]{myreport}|usepackage[internal]{myreport}|g" main.tex )
endif
ifeq ($(INTERNAL),0)
   ODIR=$(TANK_PATH)/$(EXTRADIR)
   $(shell sed -i "s|usepackage\[.*\]{myreport}|usepackage[]{myreport}|g" main.tex )
endif


BUILDFLAGS = -pdflatex="$(PDFLATEX) -synctex=1 -shell-escape -interaction=nonstopmode "   \
             -use-make -shell-escape

BIBFLAGS = -bibtex

aux: 
	mkdir aux

#FEX=-deps  # use this to see dependencies
FEX=

doc: main.tex make.inc $(MAKEFILE) figlinks  
	@echo ""
	@echo ""
	@echo ""
	if ! [ -d "aux" ]; then mkdir aux; fi
	($(LATEXMK) -pdf -jobname=aux/job        $(BUILDFLAGS) $(BIBFLAGS)  $(FEX) $< && \
         cp aux/job.pdf $(ODIR).pdf)
	@echo ""
	@echo ""
	@echo -e "Congratulations! File \033[7;33m$(ODIR).pdf \033[0m built"
	@echo ""

compress:
	gs -sDEVICE=pdfwrite -dPDFSETTINGS=/default -q -o $(ODIR).pdf aux/job.pdf

clean:
	$(LATEXMK) -c -jobname=aux/job main.tex
	if [ -f $(SCREEN) ]; then rm $(SCREEN); fi

figlinks:
	if [ ! -L "figures"         -a -d "$(FIG)"  ]; then ln -s $(FIG)  ./ ; fi
