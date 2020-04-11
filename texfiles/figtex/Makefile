SHELL := /bin/bash --init-file $(GITHUB_PATH)/WORK/lib/bashfiles/getextrapath.sh --init-file ~/.bashrc

LIB=$(GITHUB_PATH)/WORK/lib/texfiles/

include make.inc

EXTRADIR:= $(shell getextrapath $(DOC)/figtex)

OTANK=$(DOC)/figures/$(EXTRADIR)
HERE=$(DOC)/figtex/$(EXTRADIR)

DATELABEL:= $(shell date +%Y%m%d)
CATALOGUE=$(TANK_PATH)/WORK/usefull/figures_catalogue

all: $(OBJECTS)

%.pdf: $(OTANK)/%.pdf 
	@echo building figure $<

%.tex: $(OTANK)/%.tex
	@echo building table $<

# FIGURES
.SECONDARY:
$(OTANK)/%.pdf: %.tex 
	@echo ""
	@echo ""
	@echo "Making figure $<"
	@echo ""
	if ! [ -d $(OTANK) ]; then mkdir -p $(OTANK); fi
	if ! [ -d $(CATALOGUE) ]; then mkdir -p $(CATALOGUE); fi
	if ! [ -d "aux" ]; then mkdir aux; fi
	@echo ""
	$(shell cat standalone_header.tex                     > aux/job.tex)
	$(shell cat $<                                       >> aux/job.tex)
	$(shell echo '\end{document}'                        >> aux/job.tex)
	(export TEXINPUTS=.:$(DOC)/:$(LIB)//: &&  lualatex --shell-escape -jobname=aux/job -interaction=nonstopmode \
         "\def\tank{$(TANK_PATH)}\input{aux/job.tex}" && \
          cp aux/job.pdf  $@ && cp aux/job.tex  $(OTANK)/$*_source.tex && \
          cp aux/job.pdf  $(CATALOGUE)/$(DATELABEL)_$*.pdf && cp aux/job.tex  $(CATALOGUE)/$(DATELABEL)_$*.tex )
	echo $@
	echo $@
	echo $@
	@echo ""
	@echo -e "Congratulations! File \033[7;32m $@ \033[0m built"
	@echo ""

# TABLES
.SECONDARY:
$(OTANK)/%.tex: %.tab
	@echo ""
	@echo ""
	@echo "Making table $<"
	@echo ""
	if ! [ -d $(OTANK) ]; then mkdir -p $(OTANK); fi
	if ! [ -d "aux" ]; then mkdir aux; fi
	@echo ""
	@echo ""
	$(shell cat standalone_header.tex                     > aux/job.tex)
	$(shell cat $<                                       >> aux/job.tex)
	$(shell echo '\end{document}'                        >> aux/job.tex)
	(export TEXINPUTS=.:$(DOC)/:$(LIB)//: &&  pdflatex --shell-escape -jobname=aux/job -interaction=nonstopmode \
         "\def\tank{$(TANK_PATH)}\input{aux/job.tex}" && \
          sed -i 's|\\pgfutilensuremath|\\ensuremath|g' hola.tex &&  \
          cp hola.tex  $@ && cp aux/job.tex  $(OTANK)/$*_source.tex && cp aux/job.pdf  $(OTANK)/$*.pdf && \
          cp aux/job.pdf  $(CATALOGUE)/$(DATELABEL)_$*.pdf && cp aux/job.tex  $(CATALOGUE)/$(DATELABEL)_$*.tex )
	echo $@
	echo $@
	echo $@
	@echo ""
	@echo -e "Congratulations! File \033[7;32m $@ \033[0m built"
	@echo ""

          #cp hola.tex  $@ && cp aux/job.tex  $(OTANK)/_$*.tab )
