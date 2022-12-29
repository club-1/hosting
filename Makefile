# Configuration / variables section
PREFIX ?= /usr/local

# Default installation paths
BIN_DIR     := $(DESTDIR)$(PREFIX)/bin
LIB_DIR     := $(DESTDIR)$(PREFIX)/lib/club1
ETC_DIR     := $(DESTDIR)$(PREFIX)/etc/club1
SHARE_DIR   := $(DESTDIR)$(PREFIX)/share/club1
DIRS        := $(BIN_DIR) $(LIB_DIR) $(ETC_DIR) $(SHARE_DIR)

# File lists
BIN_LIST    := dns-auth dns-bump dns-cleanup pspaceadd pspacedel pspacemod update-apache update-php update-element update-roundcube-carddav move-logs
LIB_LIST    := functions.sh dns-bump.pl
ETC_LIST    := config

# Files to install
BINS        := $(patsubst %, bin/%, $(BIN_LIST))
LIBS        := $(patsubst %, lib/club1/%, $(LIB_LIST))
ETCS        := $(patsubst %, etc/club1/%.env, $(ETC_LIST))
SHARES      := $(wildcard share/club1/*)

# Installed path
BINS_INST   := $(patsubst %, $(DESTDIR)$(PREFIX)/%, $(BINS))
LIBS_INST   := $(patsubst %, $(DESTDIR)$(PREFIX)/%, $(LIBS))
ETCS_INST   := $(patsubst %, $(DESTDIR)$(PREFIX)/%, $(ETCS))
SHARES_INST := $(patsubst %, $(DESTDIR)$(PREFIX)/%, $(SHARES))

all: $(BINS) $(ETCS)

clean:
	rm -rf bin

cleanall: clean
	rm -rf etc

install: all $(ETCS_INST) | $(DIRS)
	install -D $(BINS) $(BIN_DIR)
	install -D $(LIBS) $(LIB_DIR) -m 644
	install -D $(SHARES) $(SHARE_DIR) -m 644

$(ETCS_INST): | $(ETC_DIR)
	install -D $(ETCS) $(ETC_DIR) -m 644

uninstall:
	-rm -f $(BINS_INST)
	-rm -f $(LIBS_INST)
	-rm -f $(SHARES_INST)
	rmdir $(LIB_DIR) || true
	rmdir $(SHARE_DIR) || true

$(BINS): bin/%: src/%.sh | bin
	cp $< $@
	chmod +x $@

$(ETCS): etc/club1/%.env: | etc/club1
	cp $*.sample.env $@

bin etc/club1:
	mkdir -p $@

$(DIRS):
	install -d $@

.PHONY: all clean cleanall install uninstall
