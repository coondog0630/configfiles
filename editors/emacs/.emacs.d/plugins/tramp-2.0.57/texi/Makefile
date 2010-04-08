# Emacs Makefile for TRAMP
# texi/Makefile.  Generated from Makefile.in by configure.

# Copyright (C) 1998, 1999, 2000, 2001, 2002, 2003, 2004,
#   2005, 2006, 2007 Free Software Foundation, Inc.

# Author: Kai Gro,A_(Bjohann <kai.grossjohann@gmx.net>
#         Michael Albinus <michael.albinus@gmx.de>
# Keywords: comm, processes

# This file is part of GNU Emacs.

# GNU Emacs is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.

# GNU Emacs is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with GNU Emacs; see the file COPYING.  If not, write to the
# Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA 02110-1301, USA.

# This Makefile requires GNU make and GNU texinfo.  If there is an
# insufficient version of makeinfo, autoconf refuses to generate
# Makefile.  Problems of texi2dvi or install-info result in a warning.

EMACS		= emacs
EMACS_INFO	= emacs
JA_MANUAL	= $(if $(findstring yes, no), jamanual, nojamanual)
INSTALL_CHAPTER	= $(if $(findstring yes, yes), \
			installchapter, noinstallchapter)
MAKEINFO	= makeinfo --no-split
TEXI2DVI	= no
INSTALL		= install -m644
INSTALL_INFO	= install-info --quiet
CP		= @cp
MKDIR		= @mkdir -p
RM		= -rm -f

prefix		= /usr/local
infodir		= ${prefix}/share/info
localinfodir	= ../info
DESTDIR		=

TEXI_FILES	= tramp.texi trampver.texi doclicense.texi \
		  $(if $(findstring yes, yes), trampinst.texi)
JA_TEXI_FILES	= $(if $(findstring yes, no), tramp_ja.texi)
INFO_FILES	= $(localinfodir)/tramp \
		  $(if $(JA_TEXI_FILES), $(localinfodir)/tramp_ja)
INSTALL_FILES	= $(DESTDIR)$(infodir)/tramp \
		  $(if $(JA_TEXI_FILES), $(DESTDIR)$(infodir)/tramp_ja)
CLEAN_FILES	= .\\\#* \\\#* .*~ *~ *.aux *.cp *.cps *.diff *.dvi *.elc *.fn *.fns *.html *.info *.ky *.log *.pg *.tmp *.toc *.tp *.vr *.vrs $(wildcard $(localinfodir)/*)

# To be used by maintainer only
NONGNU		= ../../tramp-web

.PHONY: all install clean distclean tramp dvi html savannah \
	$(INSTALL_FILES) $(localinfodir)/dir $(DESTDIR)$(infodir)/dir

all: tramp dvi html

tramp: $(INFO_FILES) $(localinfodir)/dir

install: tramp $(INSTALL_FILES) $(DESTDIR)$(infodir)/dir

clean:
	$(RM) $(CLEAN_FILES)

distclean: clean

$(localinfodir)/tramp $(localinfodir)/tramp_ja: $(TEXI_FILES) $(JA_TEXI_FILES)
	$(MKDIR) $(dir $@)
	$(MAKEINFO) --footnote-style=end -D $(EMACS_INFO) -D $(JA_MANUAL) \
		-D $(INSTALL_CHAPTER) -o $@ $(notdir $@).texi

$(DESTDIR)$(infodir)/tramp $(DESTDIR)$(infodir)/tramp_ja:
	$(MKDIR) $(dir $@)
	$(INSTALL) $(INFO_FILES) $(DESTDIR)$(infodir)

# don't call install-info if it failed in configure
$(localinfodir)/dir $(DESTDIR)$(infodir)/dir:
	$(MKDIR) $(dir $@)
	$(if $(shell test -d $(dir $@)), \
		$(if $(findstring dir, $(shell find $(dir $@) -name dir)),, \
			$(CP) dir_sample $@), \
		$(CP) dir_sample $@)
	$(if $(findstring no, $(INSTALL_INFO)),, \
		$(foreach file, $(INFO_FILES), \
			$(if $(shell grep -q -s "($(notdir $(file)))\." $@),, \
			    $(INSTALL_INFO) --info-dir=$(dir $@) \
				$(subst $(dir $(file)), $(dir $@), $(file);))))

dvi: tramp.dvi $(if $(JA_TEXI_FILES), tramp_ja.dvi)

# don't call texi2dvi if it failed in configure
%.dvi: $(TEXI_FILES) $(JA_TEXI_FILES)
	$(if $(findstring no, $(TEXI2DVI)),, \
		$(TEXI2DVI) -b -c -t "@set $(EMACS_INFO)" \
		-t "@set $(JA_MANUAL)" -t "@set $(INSTALL_CHAPTER)" $*.texi)

html: tramp.html $(if $(JA_TEXI_FILES), tramp_ja.html)

tramp.html: tramp-emacs.html tramp-xemacs.html
	$(RM) tramp.html
	ln -s tramp-emacs.html tramp.html

tramp_ja.html: tramp_ja-emacs.html tramp_ja-xemacs.html
	$(RM) tramp_ja.html
	ln -s tramp_ja-emacs.html tramp_ja.html

tramp-%.html: $(TEXI_FILES)
	$(MAKEINFO) --html -D $* -D $(JA_MANUAL) -D $(INSTALL_CHAPTER) -o $@ $<

tramp_ja-%.html: $(JA_TEXI_FILES)
	$(MAKEINFO) --html -D $* -D $(INSTALL_CHAPTER) -o $@ $<

# Maintainer targets

savannah: html
	cp tramp*emacs.html $(NONGNU)
	cp tramp-emacs.html $(NONGNU)/index.html
	cp tramp_ja-emacs.html $(NONGNU)/tramp_ja.html
	@echo ""
	@echo "Now use cvs checkin in $(NONGNU)"
	@echo ""
