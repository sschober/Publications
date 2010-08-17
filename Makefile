BIBFILE=publications.bib
YEARS := 2008 2009 2010

BIB_TARGETS := $(addsuffix .bib,$(YEARS))
HTML_TARGETS := $(addsuffix .html,$(YEARS))

BT2HTML_OPTS=-d -r --no-keywords --no-abstract --no-keys --use-table --no-doc --quiet

RESULT := plain.html

OPENING :="<tr><td class=\"gray\" valign=\"top\"><b>$$year</b></td><td>"
CLOSING :="</td></tr>"

.PHONY: clean all

all:	plain.html

$(RESULT): $(HTML_TARGETS)
	tmp=`mktemp`; \
	for year in $(YEARS); do \
	  test `stat cite$$year -c%s` -gt 0 && \
	  echo $(OPENING) `cat $$year.html  | grep -v "^<a.*bibtex" | sed -e "s;<hr>.*;;"` $(CLOSING) >> $$tmp; \
	done; \
	cat plain-header.html $$tmp plain-footer.html > $@

clean:
	for year in $(YEARS); do ls | grep $$year | xargs rm ; done

$(HTML_TARGETS): $(BIB_TARGETS)

$(BIB_TARGETS):	$(BIBFILE)
	for year in $(YEARS); do bib2bib -oc cite$$year -ob $$year.bib -c "year=$$year" $(BIBFILE); done

%.html:	%.bib
	bibtex2html $(BT2HTML_OPTS) $<
